//
//  MackRouteViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import Combine

class MackRouteViewModel: RouteViewModel {
    @Published var route: MKRoute? = nil
    @Published var steps: [RouteStep] = []
    @Published var isLoading: Bool = true
}
