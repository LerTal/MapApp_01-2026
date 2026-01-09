//
//  AddressInputViewModelImpl.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import Foundation
import Combine

class AddressInputViewModelImpl: AddressInputViewModel {
    private let coordinator: Coordinator
    private let geocodingService: GeocodingService
    
    @Published var startAddress: String = ""
    @Published var endAddress: String = ""
    @Published var isValid: Bool = false
    
    init(coordinator: Coordinator, geocodingService: GeocodingService) {
        self.coordinator = coordinator
        self.geocodingService = geocodingService
        bind()
    }
    
    private func bind() {
            Publishers.CombineLatest($startAddress, $endAddress)
                .map { !$0.isEmpty && !$1.isEmpty }
                .removeDuplicates()
                .assign(to: &$isValid)
        }
    
    func didTapShowRoute(for locationPair: LocationPair) {
        coordinator.showRouteMap(locationPair)
    }
}
