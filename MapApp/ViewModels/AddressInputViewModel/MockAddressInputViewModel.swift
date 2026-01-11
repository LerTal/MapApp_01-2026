//
//  MockAddressInputViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import Foundation
import Combine

class MockAddressInputViewModel: AddressInputViewModel {
    @Published var startAddress: String = ""
    @Published var endAddress: String = ""
    @Published private(set) var startSuggestions: [String] = []
    @Published private(set) var endSuggestions: [String] = []
    @Published private(set) var isValid: Bool = false
    @Published private(set) var state: AddressInputViewState = .idle
    
    func didTapShowRoute() {
        print("\(#function)")
    }
}
