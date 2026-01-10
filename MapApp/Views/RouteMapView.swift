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
            mapLayer
            overlayLayer
        }
    }
    
    // MARK: - Map
    @ViewBuilder
    private var mapLayer: some View {
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
    }
    
    // MARK: - Overlay
    @ViewBuilder
    private var overlayLayer: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
            
        case .loading:
            ProgressView("Loading route…")
                .scaleEffect(1.2)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            
        case .loaded:
            EmptyView()
            
        case .failed(let message):
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                Text(message)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}


#Preview {
    RouteMapView(viewModel: MackRouteViewModel())
}
