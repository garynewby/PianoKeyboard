//
//  KeyboardStyle.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 25/03/2023.
//

import SwiftUI

public protocol KeyboardStyle {
    associatedtype Layout: View

    var naturalKeySpace: CGFloat { get }
    func naturalColor(_ down: Bool) -> Color
    func sharpFlatColor(_ down: Bool) -> Color
    func labelColor(_ noteNumber: Int) -> Color
    func layout(viewModel: PianoKeyboardViewModel, geometry: GeometryProxy) -> Layout
}
