//
//  GeocodingService.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import Combine

enum GeocodingError: Error {
    case locationNotFound
    case invalidAddress
}

protocol GeocodingService {
    func geocode(address: String) async throws -> CLLocationCoordinate2D
    func suggestions(for query: String) -> AnyPublisher<[String], Never>
}

final class MapKitGeocodingService: NSObject, GeocodingService {

    private let completer = MKLocalSearchCompleter()
    private let subject = PassthroughSubject<[String], Never>()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address]
    }

    func geocode(address: String) async throws -> CLLocationCoordinate2D {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else {
            throw GeocodingError.invalidAddress
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = trimmed
        request.resultTypes = .address

        let response = try await MKLocalSearch(request: request).start()

        guard let item = response.mapItems.first else {
            throw GeocodingError.locationNotFound
        }

        if #available(iOS 26.0, *) {
            guard item.address != nil else {
                throw GeocodingError.locationNotFound
            }
            return item.location.coordinate
        } else {
            let placemark = item.placemark
            guard
                placemark.thoroughfare != nil ||
                placemark.locality != nil ||
                placemark.administrativeArea != nil
            else {
                throw GeocodingError.locationNotFound
            }
            return item.location.coordinate
        }
    }

    func suggestions(for query: String) -> AnyPublisher<[String], Never> {
        guard !query.isEmpty else {
            return Just([]).eraseToAnyPublisher()
        }

        completer.queryFragment = query

        return subject
            .eraseToAnyPublisher()
    }
}


extension MapKitGeocodingService: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let addresses = completer.results.map {
            [$0.title, $0.subtitle]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        }

        subject.send(addresses)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        subject.send([])
    }
}
