//
//  AnyKeyboardStyle.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 12/05/2023.
//

import SwiftUI

public struct AnyKeyboardStyle: KeyboardStyle {
    public typealias Layout = AnyView
    public let naturalKeySpace: CGFloat

    let naturalColorClosure: (Bool) -> Color
    let sharpFlatColorClosure: (Bool) -> Color
    let labelColorClosure: (Int) -> Color
    let layoutClosure: ((PianoKeyboardViewModel, GeometryProxy) -> Layout)?

    public init<T: KeyboardStyle>(style: T) {
        naturalKeySpace = style.naturalKeySpace
        naturalColorClosure = style.naturalColor
        sharpFlatColorClosure = style.sharpFlatColor
        labelColorClosure = style.labelColor
        layoutClosure = style.layout as? ((PianoKeyboardViewModel, GeometryProxy) -> Layout)
    }

    public func naturalColor(_ down: Bool) -> Color {
        naturalColorClosure(down)
    }

    public func sharpFlatColor(_ down: Bool) -> Color {
        sharpFlatColorClosure(down)
    }

    public func labelColor(_ noteNumber: Int) -> Color {
        labelColorClosure(noteNumber)
    }
    
    public func layout(viewModel: PianoKeyboardViewModel, geometry: GeometryProxy) -> Layout {
        layoutClosure?(viewModel, geometry) ?? AnyView(Text("Layout missing").foregroundColor(.white))
    }
}
