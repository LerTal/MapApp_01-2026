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
    @Published var startSuggestions: [String] = []
    @Published var endSuggestions: [String] = []
    @Published var isValid: Bool = false
    
    init(coordinator: Coordinator, geocodingService: GeocodingService) {
        self.coordinator = coordinator
        self.geocodingService = geocodingService
        bind()
    }
    
    private func bind() {
        bindValidation()
        bindStartAddressSuggestions()
        bindEndAddressSuggestions()
    }
    
    private func bindValidation() {
        Publishers.CombineLatest($startAddress, $endAddress)
            .map { !$0.isEmpty && !$1.isEmpty }
            .removeDuplicates()
            .assign(to: &$isValid)
    }

    private func bindStartAddressSuggestions() {
        $startAddress
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [geocodingService] query -> AnyPublisher<[String], Never> in
                guard query.count >= 3 else {
                    return Just([]).eraseToAnyPublisher()
                }
                return geocodingService.suggestions(for: query)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$startSuggestions)
    }
    
    private func bindEndAddressSuggestions() {
        $endAddress
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [geocodingService] query -> AnyPublisher<[String], Never> in
                guard query.count >= 3 else {
                    return Just([]).eraseToAnyPublisher()
                }
                return geocodingService.suggestions(for: query)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$endSuggestions)
    }
    
    func didTapShowRoute() {
        Task {
            do {
                let geoStart = try await geocodingService.geocode(address: startAddress)
                let geoEnd = try await geocodingService.geocode(address: endAddress)
                let pair = LocationPair(startLocation: geoStart, endLocation: geoEnd)
                coordinator.showRouteMap(pair)
            } catch {
                print("\(error)")
            }
        }
    }
}
