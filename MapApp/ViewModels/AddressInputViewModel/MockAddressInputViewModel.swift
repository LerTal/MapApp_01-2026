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
    @Published var startSuggestions: [String] = []
    @Published var endSuggestions: [String] = []
    @Published var isValid: Bool = false
    
    func didTapShowRoute() {
        print("\(#function)")
    }
}
