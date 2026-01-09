//
//  LocationPair.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import Foundation
import CoreLocation

struct LocationPair: Hashable {
    let startLocation: CLLocationCoordinate2D
    let endLocation: CLLocationCoordinate2D

    // MARK: - Equatable
    static func == (lhs: LocationPair, rhs: LocationPair) -> Bool {
        lhs.startLocation.latitude == rhs.startLocation.latitude &&
        lhs.startLocation.longitude == rhs.startLocation.longitude &&
        lhs.endLocation.latitude == rhs.endLocation.latitude &&
        lhs.endLocation.longitude == rhs.endLocation.longitude
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(startLocation.latitude)
        hasher.combine(startLocation.longitude)
        hasher.combine(endLocation.latitude)
        hasher.combine(endLocation.longitude)
    }
}


extension LocationPair {
    
    static var mock1: LocationPair {
        LocationPair(
            startLocation: CLLocationCoordinate2D(latitude: 32.0853, longitude: 34.7818),
            endLocation: CLLocationCoordinate2D(latitude: 31.7683, longitude: 35.2137)
        )
    }
}
