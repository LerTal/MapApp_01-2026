//
//  AddressInputViewModel.swift
//  MapApp
//
//  Created by Tal L on 09/01/2026.
//

import Foundation

enum AddressInputViewState: Equatable {
    case idle
    case loading
    case failed(String)
}

@MainActor
protocol AddressInputViewModel: AnyObject, ObservableObject {
    var startAddress: String { get set }
    var endAddress: String { get set }
    var startSuggestions: [String] { get }
    var endSuggestions: [String] { get }
    var isValid: Bool { get }
    var state: AddressInputViewState { get }
    
    func didTapShowRoute()
}
