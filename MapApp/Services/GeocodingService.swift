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
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        request.resultTypes = .address

        let response = try await MKLocalSearch(request: request).start()

        guard let location = response.mapItems.first?.location else {
            throw GeocodingError.locationNotFound
        }

        return location.coordinate
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
