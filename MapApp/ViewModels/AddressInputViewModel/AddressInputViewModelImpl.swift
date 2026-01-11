//
//  AddressInputViewModelImpl.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import Foundation
import Combine

final class AddressInputViewModelImpl: AddressInputViewModel {

    private let coordinator: Coordinator
    private let geocodingService: GeocodingService

    @Published var startAddress: String = ""
    @Published var endAddress: String = ""
    @Published private(set) var startSuggestions: [String] = []
    @Published private(set) var endSuggestions: [String] = []
    @Published private(set) var isValid: Bool = false
    @Published private(set) var state: AddressInputViewState = .idle

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
            .assign(to: &$endSuggestions)
    }

    func didTapShowRoute() {
        state = .loading

        Task {
            do {
                let geoStart = try await geocodingService.geocode(address: startAddress)
                let geoEnd = try await geocodingService.geocode(address: endAddress)
                let pair = LocationPair(startLocation: geoStart, endLocation: geoEnd)
                
                state = .idle
                coordinator.showRouteMap(pair)
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }
}

