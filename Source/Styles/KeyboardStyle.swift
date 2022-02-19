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
        layoutClosure = style.layout as? (PianoKeyboardViewModel, GeometryProxy) -> AnyKeyboardStyle.Layout ?? nil
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
        layoutClosure?(viewModel, geometry) ?? AnyView(erasing: EmptyView())
    }
}

public struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    public init(corners: UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
