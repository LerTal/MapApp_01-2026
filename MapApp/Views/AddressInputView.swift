//
//  AddressInputView.swift
//  MapApp
//
//  Created by Tal L on 08/01/2026.
//

import Foundation
import SwiftUI
import Combine

struct AddressInputView<ViewModel: AddressInputViewModel>: View {
    @StateObject var viewModel: ViewModel
    @FocusState private var startAddressFocused: Bool
    @FocusState private var endAddressFocused: Bool
    
    var body: some View {
        VStack {
            textField_StartAddress()
            
            textField_EndAddress()
            
            Button("Show Route") {
                viewModel.didTapShowRoute(for: LocationPair.mock1)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: 1, style: .circular))
            .disabled(!viewModel.isValid)
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .navigationTitle("Address Input View")
    }
    
    private func textField_StartAddress() -> some View {
        TextField("Start address", text: $viewModel.startAddress)
            .focused($startAddressFocused)
            .addressStyle()
    }
    
    private func textField_EndAddress() -> some View {
        TextField("End address", text: $viewModel.endAddress)
            .focused($endAddressFocused)
            .addressStyle()
    }
}

private extension View {
    func addressStyle() -> some View {
        self
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary, lineWidth: 1)
        )
    }
}

#Preview {
    AddressInputView(viewModel: MockAddressInputViewModel())
}
