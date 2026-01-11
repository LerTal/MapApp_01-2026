//
//  AddressInputView.swift
//  MapApp
//
//  Created by Tal L on 08/01/2026.
//

import Foundation
import SwiftUI
import Combine

enum AddressField: Hashable {
    case start
    case end
}

struct TextFieldFrameKey: PreferenceKey {
    static var defaultValue: [AddressField: Anchor<CGRect>] = [:]
    
    static func reduce(
        value: inout [AddressField: Anchor<CGRect>],
        nextValue: () -> [AddressField: Anchor<CGRect>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct AddressInputView<ViewModel: AddressInputViewModel>: View {
    @StateObject var viewModel: ViewModel
    @FocusState private var focusedField: AddressField?
    @State private var visibleError: String? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background tap catcher
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
            
            // Main content
            VStack(spacing: 12) {
                textField_StartAddress()
                textField_EndAddress()
                
                Button("Show Route") {
                    viewModel.didTapShowRoute()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isValid || viewModel.state == .loading)
                .overlay {
                    if case .loading = viewModel.state {
                        ProgressView()
                            .padding(8)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                // ERROR MESSAGE BELOW CONTENT
                if let message = visibleError {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                        .transition(.opacity)
                        .animation(.easeInOut, value: visibleError)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .animation(.default, value: viewModel.state)
        }
        // Listen for failed state changes
        .onChange(of: viewModel.state) {
            let animationDurationSec: TimeInterval = 3
            if case .failed(let message) = viewModel.state {
                withAnimation {
                    visibleError = message
                }
                
                // Auto-dismiss after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDurationSec) {
                    withAnimation {
                        visibleError = nil
                    }
                }
            }
        }
        .overlayPreferenceValue(TextFieldFrameKey.self) { anchors in
            GeometryReader { proxy in
                
                // START FIELD OVERLAY
                if focusedField == .start,
                   let anchor = anchors[.start],
                   !viewModel.startSuggestions.isEmpty {
                    
                    let frame = proxy[anchor]
                    
                    SuggestionsList(
                        suggestions: viewModel.startSuggestions
                    ) { selected in
                        viewModel.startAddress = selected
                        focusedField = nil
                    }
                    .frame(width: frame.width)
                    .offset(x: frame.minX, y: frame.maxY + 8)
                    .zIndex(10)
                }
                
                // END FIELD OVERLAY
                if focusedField == .end,
                   let anchor = anchors[.end],
                   !viewModel.endSuggestions.isEmpty {
                    
                    let frame = proxy[anchor]
                    
                    SuggestionsList(
                        suggestions: viewModel.endSuggestions
                    ) { selected in
                        viewModel.endAddress = selected
                        focusedField = nil
                    }
                    .frame(width: frame.width)
                    .offset(x: frame.minX, y: frame.maxY + 8)
                    .zIndex(10)
                }
            }
        }
        .navigationTitle("Address Input View")
    }
    
    // MARK: - Fields
    
    private func textField_StartAddress() -> some View {
        TextField("Start address", text: $viewModel.startAddress)
            .focused($focusedField, equals: .start)
            .addressStyle()
            .anchorPreference(
                key: TextFieldFrameKey.self,
                value: .bounds
            ) { [.start: $0] }
    }
    
    private func textField_EndAddress() -> some View {
        TextField("End address", text: $viewModel.endAddress)
            .focused($focusedField, equals: .end)
            .addressStyle()
            .anchorPreference(
                key: TextFieldFrameKey.self,
                value: .bounds
            ) { [.end: $0] }
    }
}

#Preview {
    AddressInputView(viewModel: MockAddressInputViewModel())
}

struct SuggestionsList: View {
    let suggestions: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(suggestions, id: \.self) { s in
                Button {
                    onSelect(s)
                } label: {
                    Text(s)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .buttonStyle(.plain)
                Divider()
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
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
