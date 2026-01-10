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

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }

            VStack(spacing: 12) {
                textField_StartAddress()
                textField_EndAddress()

                Button("Show Route") {
                    viewModel.didTapShowRoute(for: LocationPair.mock1)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isValid)

                Spacer()
            }
            .padding(.horizontal, 20)
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
