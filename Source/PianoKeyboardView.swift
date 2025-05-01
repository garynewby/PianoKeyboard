//
//  PianoKeyboardView.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI

public struct PianoKeyboardView<T: KeyboardStyle>: View {
    @ObservedObject private var viewModel: PianoKeyboardViewModel
    var style: T

    public init(
        viewModel: PianoKeyboardViewModel = PianoKeyboardViewModel(),
        style: T
    ) {
        self.viewModel = viewModel
        self.style = style
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                style.layout(viewModel: viewModel, geometry: geometry)
                TouchesView(viewModel: viewModel)
            }
            .background(.black)
        }
    }
}

#Preview {
    let pianoKeyboardViewModel = PianoKeyboardViewModel()
    VStack {
        PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ClassicStyle())
        PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ModernStyle())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(.black)
}

