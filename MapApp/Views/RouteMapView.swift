//
//  RouteMapView2.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import MapKit
import SwiftUI
import Combine

extension CLLocationCoordinate2D {
    func toCLLocation() -> CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = Array(
            repeating: kCLLocationCoordinate2DInvalid,
            count: pointCount
        )
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

struct RouteMapView<ViewModel: RouteViewModel>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            Map {
                if let route = viewModel.route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                    
                    if let start = route.polyline.coordinates.first {
                        Marker("Start", coordinate: start)
                            .tint(.green)
                    }
                    
                    if let end = route.polyline.coordinates.last {
                        Marker("End", coordinate: end)
                            .tint(.red)
                    }
                    
                    // Step markers
                    ForEach(route.steps.indices, id: \.self) { index in
                        let step = route.steps[index]
                        Marker(step.instructions, coordinate: step.polyline.coordinate)
                            .tint(.blue)
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}


#Preview {
    RouteMapView(viewModel: MackRouteViewModel())
}
