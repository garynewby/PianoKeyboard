//
//  GLNPianoKey.swift
//  GLNPianoView
//
//  Created by Gary Newby on 23/09/2017.
//  Copyright © 2017 Gary Newby. All rights reserved.
//

import UIKit

public enum GLNPianoKeyType {
    case white
    case black
}

public final class GLNPianoKey {
    private var upImage: UIImage?
    private var downImage: UIImage?
    public var type: GLNPianoKeyType
    public var imageLayer: CALayer
    public var highlightLayer: CALayer
    public var noteNumber: Int
    public var isDown = false
    public var noteLayer: GLNNoteNameLayer?

    init(color: UIColor, rect: CGRect, type: GLNPianoKeyType, cornerRadius: CGFloat, showNotes: Bool, noteNumber: Int, blackKeyWidth: CGFloat = 0, blackKeyHeight: CGFloat = 0) {
        self.noteNumber = noteNumber
        self.type = type
        let x: CGFloat = 1.0
        let rect = CGRect(x: rect.minX, y: rect.minY - (cornerRadius * 2.0), width: rect.width, height: rect.height + (cornerRadius * 2.0))

        imageLayer = CALayer()
        imageLayer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.02, height: 0.02)
        imageLayer.frame = rect.insetBy(dx: x, dy: 0)
        imageLayer.isOpaque = true
        imageLayer.backgroundColor = color.cgColor
        imageLayer.cornerRadius = cornerRadius
        imageLayer.masksToBounds = true
        imageLayer.actions = ["onOrderIn": NSNull(), "onOrderOut": NSNull(), "sublayers": NSNull(), "contents": NSNull(), "bounds": NSNull(), "position": NSNull()]
        highlightLayer = CALayer()
        highlightLayer.backgroundColor = UIColor.clear.cgColor
        highlightLayer.frame = imageLayer.bounds
        imageLayer.addSublayer(highlightLayer)
        
        if type == .white {
            upImage = UIImage.keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown: false, keyCornerRadius: cornerRadius, noteNumber: noteNumber)
            downImage = UIImage.keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown: true, keyCornerRadius: cornerRadius, noteNumber: noteNumber)
            if let image = upImage?.cgImage {
                imageLayer.contents = image
            }
            if showNotes {
                noteLayer = GLNNoteNameLayer(layerHeight: imageLayer.frame.size.height, keyRect: rect, noteNumber: noteNumber)
                if let noteLayer = noteLayer {
                    imageLayer.addSublayer(noteLayer)
                }
            }
        } else {
            upImage = UIImage.keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown: false, keyCornerRadius: cornerRadius, noteNumber: noteNumber)
            downImage = UIImage.keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown: true, keyCornerRadius: cornerRadius, noteNumber: noteNumber)
            if let image = upImage?.cgImage {
                imageLayer.contents = image
            }
        }
    }

    func setImage(keyNum _: Int, isDown: Bool) {
        if type == .white {
            let shadowDimension = isDown ? 0.1 : 0.02
            imageLayer.contents = isDown ? downImage?.cgImage : upImage?.cgImage
            imageLayer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: shadowDimension, height: shadowDimension)
        } else {
            imageLayer.contents = isDown ? downImage?.cgImage : upImage?.cgImage
        }
    }
}
