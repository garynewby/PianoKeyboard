//
//  GLNPianoKey.swift
//  GLNPianoView
//
//  Created by Gary Newby on 23/09/2017.
//  Copyright © 2017 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore

public class GLNPianoKey {

    public var layer: CALayer
    public var noteNumber: Int
    public var isDown = false
    public var isWhiteKey = false
    private var whiteDown: UIImage?
    private var whiteUp: UIImage?
    private var blackDown: UIImage?
    private var blackUp: UIImage?

    init(color: UIColor, aRect: CGRect, whiteKey: Bool, blackKeyWidth: CGFloat, blackKeyHeight: CGFloat, keyCornerRadius: CGFloat, showNotes: Bool, noteNumber: Int) {
        self.noteNumber = noteNumber
        isWhiteKey = whiteKey
        layer = CALayer()
        let rect = CGRect(x: aRect.minX, y: aRect.minY - (keyCornerRadius * 2.0), width: aRect.width, height: aRect.height + (keyCornerRadius * 2.0))

        blackUp = keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown: false, keyCornerRadius: keyCornerRadius)
        blackDown = keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown: true, keyCornerRadius: keyCornerRadius)

        whiteUp = keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown: false, keyCornerRadius: keyCornerRadius)
        whiteDown = keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown: true, keyCornerRadius: keyCornerRadius)

        if let blackUp = blackUp?.cgImage,
            let whiteUp = whiteUp?.cgImage {
            var x: CGFloat = 0.0
            layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.02, height: 0.02)
            if isWhiteKey {
                x = 1.0
                layer.contents = whiteUp
            }
            layer.frame = rect.insetBy(dx: x, dy: 0)
            layer.isOpaque = true
            layer.backgroundColor = color.cgColor
            layer.cornerRadius = keyCornerRadius
            layer.masksToBounds = true

            // Disable implict animations for specified keys
            layer.actions = ["onOrderIn": NSNull(), "onOrderOut": NSNull(), "sublayers": NSNull(), "contents": NSNull(), "bounds": NSNull(), "position": NSNull()]
            if !isWhiteKey {
                // Black
                layer.contents = blackUp
                layer.masksToBounds = true
            }
        }

        if showNotes {
            if whiteKey {
                layer.addSublayer(noteLayer(keyRect: aRect))
            }
        }
    }

    func setImage(keyNum _: Int, isDown: Bool) {
        if isWhiteKey {
            layer.contents = isDown ? whiteDown?.cgImage : whiteUp?.cgImage
            let wh = isDown ? 0.1 : 0.02
            layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: wh, height: wh)
        } else {
            layer.contents = isDown ? blackDown?.cgImage : blackUp?.cgImage
        }
    }

    func keyImage(_ aSize: CGSize, blackKey: Bool, keyDown: Bool, keyCornerRadius: CGFloat) -> UIImage? {
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
                    context.drawLinearGradient(gradient, start: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.minY), end: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.maxY), options: [])
                    context.restoreGState()

                    let roundedRectangle2Rect = CGRect(x: frame.minX + border, y: frame.minY + bottomRectOffset, width: width, height: bottomRectHeight)
                    let roundedRectangle2Path = UIBezierPath(roundedRect: roundedRectangle2Rect, cornerRadius: keyCornerRadius)
                    context.saveGState()
                    roundedRectangle2Path.addClip()
                    context.drawLinearGradient(gradient, start: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.maxY), end: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.minY), options: [])
                }

            } else {
                // White key
                let strokeColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                var strokeColor2 = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.20)
                if keyDown {
                    strokeColor2 = noteColourFor(midiNumber: noteNumber, alpha: 0.75)
                    // Background
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    context.setFillColor(noteColourFor(midiNumber: noteNumber, alpha: 0.30).cgColor)
                    context.fill(frame)
                }

                let gradientColors = [strokeColor1.cgColor, strokeColor2.cgColor]
                let gradientLocations: [CGFloat] = [0.1, 1.0]

                if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: gradientLocations) {
                    let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.saveGState()
                    rectanglePath.addClip()
                    context.drawRadialGradient(gradient, startCenter: CGPoint(x: size.width / 2.0, y: size.height / 2.0), startRadius: size.height * 0.01, endCenter: CGPoint(x: size.width / 2.0, y: size.height / 2.0), endRadius: size.height * 0.6, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                }
            }
            context.restoreGState()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func noteLayer(keyRect: CGRect) -> CATextLayer {
        let noteLayer = VerticallyCenteredTextLayer()
        noteLayer.string = noteStringFor(midiNumber: noteNumber)
        noteLayer.foregroundColor = UIColor.white.cgColor
        noteLayer.backgroundColor = noteColourFor(midiNumber: noteNumber, alpha: 0.35).cgColor
        noteLayer.font = UIFont.boldSystemFont(ofSize: 0.0)
        noteLayer.fontSize = (keyRect.size.width / 4.0)
        noteLayer.alignmentMode = .center
        let width = keyRect.size.width / 2.0
        let height = width
        noteLayer.cornerRadius = (height * 0.5)
        noteLayer.frame = CGRect(x: (keyRect.size.width * 0.25), y: (layer.frame.size.height - height - 10), width: width, height: height)
        return noteLayer
    }

    func noteColourFor(midiNumber: Int, alpha: Float) -> UIColor {
        let hue = (CGFloat(midiNumber).truncatingRemainder(dividingBy: 12.0) / 12.0)
        return UIColor(hue: hue, saturation: 0.0, brightness: 0.40, alpha: CGFloat(alpha))
    }

    func noteStringFor(midiNumber: Int) -> String {
        let index = Int(midiNumber)
        let notesArray = [
            "C-1", "C#-1", "D-1", "Eb-1", "E-1", "F-1", "F#-1", "G-1", "Ab-1", "A-1", "Bb-1", "B-1",
            "C0", "C#0", "D0", "Eb0", "E0", "F0", "F#0", "G0", "Ab0", "A0", "Bb0", "B0",
            "C1", "C#1", "D1", "Eb1", "E1", "F1", "F#1", "G1", "Ab1", "A1", "Bb1", "B1",
            "C2", "C#2", "D2", "Eb2", "E2", "F2", "F#2", "G2", "Ab2", "A2", "Bb2", "B2",
            "C3", "C#3", "D3", "Eb3", "E3", "F3", "F#3", "G3", "Ab3", "A3", "Bb3", "B3",
            "C4", "C#4", "D4", "Eb4", "E4", "F4", "F#4", "G4", "Ab4", "A4", "Bb4", "B4",
            "C5", "C#5", "D5", "Eb5", "E5", "F5", "F#5", "G5", "Ab5", "A5", "Bb5", "B5",
            "C6", "C#6", "D6", "Eb6", "E6", "F6", "F#6", "G6", "Ab6", "A6", "Bb6", "B6",
            "C7", "C#7", "D7", "Eb7", "E7", "F7", "F#7", "G7", "Ab7", "A7", "Bb7", "B7",
            "C8", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
        ]
        return "\(notesArray[index])"
    }
}

private class VerticallyCenteredTextLayer: CATextLayer {
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: (bounds.size.height - fontSize) / 2.0 - fontSize / 10.0)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
