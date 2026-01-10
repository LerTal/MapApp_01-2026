//
//  MackRouteViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import Combine

class MackRouteViewModel: RouteViewModel {
    @Published private(set) var state: RouteViewState = .idle
    @Published var route: MKRoute? = nil
    @Published var steps: [RouteStep] = []
}
