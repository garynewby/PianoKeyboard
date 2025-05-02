//
//  PianoInputField.swift
//  PianoKeyboard
//
//  Created by Evan Templeton on 5/2/25.
//

import SwiftUI

public struct PianoInputField: View {
    @StateObject private var viewModel = PianoKeyboardViewModel()
    @Binding private var keysPressed: [String]
    
    public init(keysPressed: Binding<[String]>) {
        self._keysPressed = keysPressed
    }
    
    public var body: some View {
        PianoKeyboardView(viewModel: viewModel, style: ClassicStyle())
            .onChange(of: viewModel.pressedKeys) { oldKeys, newKeys in
                if newKeys != oldKeys {
                    keysPressed = newKeys
                }
            }
    }
}

private extension PianoInputField {
    struct ExampleView: View {
        @State private var keysPressed: [String] = []
        var body: some View {
            VStack {
                Color.white
                HStack {
                    if !keysPressed.isEmpty {
                        ForEach(keysPressed, id: \.self) { key in
                            Text(key)
                        }
                    } else {
                        Text("Press a key...")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                PianoInputField(keysPressed: $keysPressed)
            }
        }
    }
}

#Preview {
    PianoInputField.ExampleView()
}
