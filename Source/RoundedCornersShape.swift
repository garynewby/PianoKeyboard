//
//  RoundedCornersShape.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 12/05/2023.
//

import SwiftUI

public struct RoundedCorners: OptionSet, Sendable {
    public let rawValue: Int

    public static let topLeft = RoundedCorners(rawValue: 1 << 0)
    public static let topRight = RoundedCorners(rawValue: 1 << 1)
    public static let bottomLeft = RoundedCorners(rawValue: 1 << 2)
    public static let bottomRight = RoundedCorners(rawValue: 1 << 3)

    public init(rawValue: Int) { self.rawValue = rawValue }
}

public struct RoundedCornersShape: InsettableShape {
    public let corners: RoundedCorners
    public let radius: CGFloat
    private var insetAmount: CGFloat = 0

    public init(corners: RoundedCorners, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }

    public func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let maxRadius = min(r.width, r.height) * 0.5

        let tl = corners.contains(.topLeft) ? min(radius, maxRadius) : 0
        let tr = corners.contains(.topRight) ? min(radius, maxRadius) : 0
        let br = corners.contains(.bottomRight) ? min(radius, maxRadius) : 0
        let bl = corners.contains(.bottomLeft) ? min(radius, maxRadius) : 0

        var path = Path()
        path.move(to: CGPoint(x: r.minX + tl, y: r.minY))
        path.addLine(to: CGPoint(x: r.maxX - tr, y: r.minY))
        path.addArc(center: CGPoint(x: r.maxX - tr, y: r.minY + tr), radius: tr, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY - br))
        path.addArc(center: CGPoint(x: r.maxX - br, y: r.maxY - br), radius: br, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: r.minX + bl, y: r.maxY))
        path.addArc(center: CGPoint(x: r.minX + bl, y: r.maxY - bl), radius: bl, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: r.minX, y: r.minY + tl))
        path.addArc(center: CGPoint(x: r.minX + tl, y: r.minY + tl), radius: tl, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.closeSubpath()
        return path
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }
}
