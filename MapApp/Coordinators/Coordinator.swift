//
//  Coordinator.swift
//  MapApp
//
//  Created by Tal L on 08/01/2026.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

enum Route: Hashable, Identifiable {
    case routeMap(locationPair: LocationPair)
    
    var id: String {
        switch self {
        case .routeMap(let locationPair): return "routeMap_\(locationPair)"
        }
    }
}

protocol Coordinator: AnyObject {
    func showRouteMap(_ locationPair: LocationPair)
}

class CoordinatorImpl: Coordinator, ObservableObject {
    @Published var path = NavigationPath() //TODO: maybe inject later
    @Published var sheet: Route?
    
//    init(path: NavigationPath) {
//        self.path = path
//    }
    
    private func push(_ route: Route) {
        path.append(route)
    }
    
    private func present(_ route: Route) {
        sheet = route
    }
    
    // Coordinator
    
    func showRouteMap(_ locationPair: LocationPair) {
        push(.routeMap(locationPair: locationPair))
    }
}

struct CoordinatorView: View {
    @StateObject var coordinator = CoordinatorImpl() //TODO: maybe inject later
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            rootView()
                .navigationDestination(for: Route.self) { route in
                    destinationFactory(route)
                }
        }
        .sheet(item: $coordinator.sheet) { route in
            destinationFactory(route)
        }
    }
    
    func rootView() -> some View {
        let geocodingService = MapKitGeocodingService()
        let viewModel = AddressInputViewModelImpl(coordinator: coordinator, geocodingService: geocodingService)
        return AddressInputView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func destinationFactory(_ route: Route) -> some View {
        switch route {
        case .routeMap(let locationPair):
            let service = DirectionsServiceImpl()
            let viewModel = RouteViewModelImpl(directionsService: service, locationPair: locationPair)
            RouteMapView(viewModel: viewModel)
        }
    }
}
