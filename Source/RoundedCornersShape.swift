//
//  RoundedCornersShape.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 12/05/2023.
//

import SwiftUI

public struct RoundedCornersShape: Shape {
    #if !os(macOS)

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

    #else

    public struct WhatCorners: OptionSet, Sendable {
        public let rawValue : Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let topLeft      = WhatCorners(rawValue: 1<<0)
        public static let topRight     = WhatCorners(rawValue: 1<<1)
        public static let bottomLeft   = WhatCorners(rawValue: 1<<2)
        public static let bottomRight  = WhatCorners(rawValue: 1<<3)
        public static let allCorners   : WhatCorners = [topLeft, topRight, bottomLeft, bottomRight]
    }
    let corners: WhatCorners
    let radius: CGFloat

    public init(corners: WhatCorners, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }

    public func path(in rect: CGRect) -> Path {
        return UnevenRoundedRectangle(
            topLeadingRadius: (corners.contains(.topLeft) ? radius : 0),
            bottomLeadingRadius: (corners.contains(.bottomLeft) ? radius : 0),
            bottomTrailingRadius: (corners.contains(.bottomRight) ? radius : 0),
            topTrailingRadius: (corners.contains(.topRight) ? radius : 0),
            style: .continuous
        ).path(in: rect)
    }

    #endif
}
