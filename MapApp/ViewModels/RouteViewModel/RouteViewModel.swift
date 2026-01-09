//
//  RouteViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import Combine

struct RouteStep: Identifiable {
    let id = UUID()
    let instruction: String
    let distance: CLLocationDistance
    let coordinate: CLLocationCoordinate2D
    let polyline: MKPolyline
}

@MainActor
protocol RouteViewModel: ObservableObject {
    var route: MKRoute? { get }
    var steps: [RouteStep] { get }
    var isLoading: Bool { get }
}


