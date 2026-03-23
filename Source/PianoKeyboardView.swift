//
//  PianoKeyboardView.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI

public struct PianoKeyboardView<T: KeyboardStyle>: View {
    private let viewModel: PianoKeyboardViewModel
    private let style: T

    public init(viewModel: PianoKeyboardViewModel, style: T) {
        self.viewModel = viewModel
        self.style = style
    }

    public var body: some View {
        GeometryReader { geometry in
            style.layout(viewModel: viewModel, geometry: geometry)
                .allowsHitTesting(false)
                .overlay(alignment: .top) {
                    TouchesView(viewModel: viewModel)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .background(.black)
        }
        .clipped()
    }
}

#Preview {
    @Previewable @State var viewModel = PianoKeyboardViewModel()

    VStack {
        PianoKeyboardView(viewModel: viewModel, style: ClassicStyle())
        PianoKeyboardView(viewModel: viewModel, style: ModernStyle())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(.black)
}
