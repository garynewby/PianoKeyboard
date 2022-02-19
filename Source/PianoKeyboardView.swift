//
//  PianoKeyboardView.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI
import UIKit

public struct PianoKeyboardView<T: KeyboardStyle>: View {
    @ObservedObject private var viewModel: PianoKeyboardViewModel
    var style: T

    public init(
        viewModel: PianoKeyboardViewModel = PianoKeyboardViewModel(),
        style: T = ClassicStyle()
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

struct Previews_PianoKeyboardView_Previews: PreviewProvider {
    static let pianoKeyboardViewModel = PianoKeyboardViewModel()
    static let classicStyle = ClassicStyle()
    static let modernStyle = ModernStyle()

    static var previews: some View {
        VStack {
            PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ClassicStyle())
            PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ModernStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.black)
    }
}

