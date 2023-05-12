//
//  RoundedCornersShape.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 12/05/2023.
//

import SwiftUI

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
