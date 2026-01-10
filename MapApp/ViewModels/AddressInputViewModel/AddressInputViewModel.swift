//
//  AddressInputViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import Foundation
import Combine

@MainActor
protocol AddressInputViewModel: AnyObject, ObservableObject {
    var startAddress: String { get set }
    var endAddress: String { get set }
    var startSuggestions: [String] { get }
    var endSuggestions: [String] { get }
    var isValid: Bool { get }
    
    func didTapShowRoute(for locationPair: LocationPair)
}
