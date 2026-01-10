//
//  RouteViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import Combine

enum RouteViewState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

struct RouteStep: Identifiable {
    let id = UUID()
    let instruction: String
    let distance: CLLocationDistance
    let coordinate: CLLocationCoordinate2D
    let polyline: MKPolyline
}

@MainActor
protocol RouteViewModel: ObservableObject {
    var state: RouteViewState { get }
    var route: MKRoute? { get }
    var steps: [RouteStep] { get }
}


