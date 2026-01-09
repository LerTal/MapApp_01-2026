//
//  GeocodingService.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit

enum GeocodingError: Error {
    case locationNotFound
}

protocol GeocodingService {
    func geocode(address: String) async throws -> CLLocationCoordinate2D
}

final class MapKitGeocodingService: GeocodingService {

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
}

