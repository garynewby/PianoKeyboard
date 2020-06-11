//
//  Extensions.swift
//  PianoView
//
//  Created by Gary Newby on 23/09/2017.
//  Copyright © 2017 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore

extension UIImage {
    static func keyImage(_ aSize: CGSize, blackKey: Bool, keyDown: Bool, keyCornerRadius: CGFloat, noteNumber: Int) -> UIImage? {
        let scale = UIScreen.main.scale
        var size: CGSize = aSize
        size.width *= scale
        size.height *= scale

        UIGraphicsBeginImageContext(size)

        if let context = UIGraphicsGetCurrentContext() {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if blackKey {
                let strokeColor1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.951)
                let strokeColor2 = UIColor(red: 0.379, green: 0.379, blue: 0.379, alpha: 1)
                let gradientColors = [strokeColor1.cgColor, strokeColor2.cgColor]
                let gradientLocations: [CGFloat] = [0.11, 1.0]

                if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: gradientLocations) {
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    let rectanglePath = UIBezierPath(rect: CGRect(x: frame.minX, y: frame.minY, width: size.width, height: size.height))
                    strokeColor1.setFill()
                    rectanglePath.fill()

                    let border = size.width * 0.15
                    let width = size.width * 0.7
                    var topRectHeight = size.height * 0.86
                    var bottomRectOffset = size.height * 0.875
                    let bottomRectHeight = size.height * 0.125
                    if keyDown {
                        topRectHeight = size.height * 0.91
                        bottomRectOffset = size.height * 0.925
                    }

                    let roundedRectangleRect = CGRect(x: frame.minX + border, y: frame.minY, width: width, height: topRectHeight)
                    let roundedRectanglePath = UIBezierPath(roundedRect: roundedRectangleRect, cornerRadius: keyCornerRadius)
                    context.saveGState()
                    roundedRectanglePath.addClip()
                    context.drawLinearGradient(gradient,
                                               start: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.minY),
                                               end: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.maxY),
                                               options: [])
                    context.restoreGState()

                    let roundedRectangle2Rect = CGRect(x: frame.minX + border, y: frame.minY + bottomRectOffset, width: width, height: bottomRectHeight)
                    let roundedRectangle2Path = UIBezierPath(roundedRect: roundedRectangle2Rect, cornerRadius: keyCornerRadius)
                    context.saveGState()
                    roundedRectangle2Path.addClip()
                    context.drawLinearGradient(gradient,
                                               start: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.maxY),
                                               end: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.minY),
                                               options: [])
                }
            } else {
                // White key
                let strokeColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                var strokeColor2 = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.20)

                if keyDown {
                    strokeColor2 = UIColor.noteColourFor(midiNumber: noteNumber, alpha: 0.75)
                    // Background
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    context.setFillColor(UIColor.noteColourFor(midiNumber: noteNumber, alpha: 0.30).cgColor)
                    context.fill(frame)
                }

                let gradientColors = [strokeColor1.cgColor, strokeColor2.cgColor]
                let gradientLocations: [CGFloat] = [0.1, 1.0]

                if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: gradientLocations) {
                    let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.saveGState()
                    rectanglePath.addClip()
                    context.drawRadialGradient(gradient,
                                               startCenter: CGPoint(x: size.width / 2.0, y: size.height / 2.0),
                                               startRadius: size.height * 0.01,
                                               endCenter: CGPoint(x: size.width / 2.0, y: size.height / 2.0),
                                               endRadius: size.height * 0.6,
                                               options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                }
            }
            context.restoreGState()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    static func noteColourFor(midiNumber: Int, alpha: Float) -> UIColor {
        let hue = (CGFloat(midiNumber).truncatingRemainder(dividingBy: 12.0) / 12.0)
        return UIColor(hue: hue, saturation: 0.0, brightness: 0.40, alpha: CGFloat(alpha))
    }
}

extension Int {
    func clamp(min: Int, max: Int) -> Int {
        let r = self < min ? min : self
        return r > max ? max : r
    }

    func isWhiteKey() -> Bool {
        let k = self % 12
        return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
    }
}

extension CGFloat {
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        let r = self < min ? min : self
        return r > max ? max : r
    }
}
