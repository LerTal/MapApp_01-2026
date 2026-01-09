//
//  DirectionsService.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit

protocol DirectionsService {
    func route(
        from start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D
    ) async throws -> MKRoute
}

final class DirectionsServiceImpl: DirectionsService {

    func route(
        from start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D
    ) async throws -> MKRoute {

        let request = MKDirections.Request()
        request.source = MKMapItem(location: start.toCLLocation(), address: nil)
        request.destination = MKMapItem(location: end.toCLLocation(), address: nil)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        let response = try await directions.calculate()

        guard let route = response.routes.first else {
            throw NSError(domain: "NoRoute", code: 0)
        }

        return route
    }
}
