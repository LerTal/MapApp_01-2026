//
//  RouteViewModelImpl.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import Combine

final class RouteViewModelImpl: RouteViewModel {

    // MARK: - Published state
    @Published var route: MKRoute?
    @Published var steps: [RouteStep] = []
    @Published var isLoading = false

    private let directionsService: DirectionsService

    init(
        directionsService: DirectionsService,
        locationPair: LocationPair
    ) {
        self.directionsService = directionsService
        
        Task {
            await loadRoute(
                from: locationPair.startLocation,
                to: locationPair.endLocation
            )
        }
    }

    private func loadRoute(
        from start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D
    ) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let route = try await directionsService.route(from: start, to: end)
            self.route = route
            self.steps = Self.mapSteps(route.steps)
        } catch {
            print("Route error:", error)
        }
    }

    private static func mapSteps(_ steps: [MKRoute.Step]) -> [RouteStep] {
        steps
            .filter { !$0.instructions.isEmpty }
            .compactMap { step in
                guard let coord = step.polyline.coordinates.first else {
                    return nil
                }

                return RouteStep(
                    instruction: step.instructions,
                    distance: step.distance,
                    coordinate: coord,
                    polyline: step.polyline
                )
            }
    }
}
