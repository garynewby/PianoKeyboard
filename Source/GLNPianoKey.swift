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
    
    public var layer:CALayer
    public var isKeyDown = false
    private var whiteDoImage:UIImage?
    private var whiteUpImage:UIImage?
    private var blackDoImage:UIImage?
    private var blackUpImage:UIImage?
    private var noteNumber: Int
    
    init(color:UIColor, aRect:CGRect, whiteKey:Bool, blackKeyWidth:CGFloat, blackKeyHeight:CGFloat, keyCornerRadius:CGFloat, showNotes: Bool, noteNumber: Int) {
        self.noteNumber = noteNumber;
        layer = CALayer()
        let rect = CGRect(x: aRect.minX, y: aRect.minY - (keyCornerRadius*2.0), width: aRect.width, height: aRect.height + (keyCornerRadius*2.0))

        blackUpImage = self.keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown:false, keyCornerRadius: keyCornerRadius)
        blackDoImage = self.keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown:true, keyCornerRadius: keyCornerRadius)
        
        whiteUpImage = self.keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown:false, keyCornerRadius: keyCornerRadius)
        whiteDoImage = self.keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown:true, keyCornerRadius: keyCornerRadius)
        
        if let blackUp = blackUpImage?.cgImage,
            let whiteUp = whiteUpImage?.cgImage {
            var x:CGFloat = 0.0
            layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.02, height: 0.02)
            if (whiteKey) {
                x = 1.0
                layer.contents = whiteUp
            }
            layer.frame = rect.insetBy(dx: x, dy: 0)
            layer.isOpaque = true
            layer.backgroundColor = color.cgColor
            layer.cornerRadius = keyCornerRadius
            layer.masksToBounds = true
            
            // Disable implict animations for specified keys
            layer.actions = ["onOrderIn":NSNull(), "onOrderOut":NSNull(), "sublayers":NSNull(), "contents":NSNull(), "bounds":NSNull(), "position":NSNull()]
            if (!whiteKey) {
                // Black
                layer.contents       = blackUp
                layer.masksToBounds  = true
            }
        }
        
        if (showNotes) {
              if (whiteKey) {
                layer.addSublayer(noteLayer(keyRect: aRect))
              }
        }
    }
    
    func setImage(keyNum: Int, isDown: Bool) {
        if (keyNum.isWhiteKey()) {
            layer.contents = (isDown) ? whiteDoImage?.cgImage :  whiteUpImage?.cgImage
            let wh = (isDown) ? 0.1 : 0.02
            layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: wh, height: wh)
        } else {
            layer.contents = (isDown) ? blackDoImage?.cgImage : blackUpImage?.cgImage
        }
    }
    
    func keyImage(_ aSize:CGSize, blackKey:Bool, keyDown:(Bool), keyCornerRadius:CGFloat) -> UIImage {
        let scale = UIScreen.main.scale
        var size:CGSize = aSize
        size.width *= scale
        size.height *= scale
        
        UIGraphicsBeginImageContext(size)
        
        if let context = UIGraphicsGetCurrentContext() {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            if (blackKey) {
                let strokeColor1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.951)
                let strokeColor2 = UIColor(red: 0.379, green: 0.379, blue: 0.379, alpha: 1)
                let gradientColors = [strokeColor1.cgColor, strokeColor2.cgColor]
                let gradientLocations:[CGFloat] = [0.11, 1.0]
                
                if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: gradientLocations) {
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    let rectanglePath = UIBezierPath(rect:CGRect(x: frame.minX, y: frame.minY, width: size.width, height: size.height))
                    strokeColor1.setFill()
                    rectanglePath.fill()
                    
                    let border = size.width*0.15
                    let width = size.width*0.7
                    var topRectHeight = size.height*0.86
                    var bottomRectOffset = size.height*0.875
                    let bottomRectHeight = size.height*0.125
                    if (keyDown) {
                        topRectHeight = size.height*0.91
                        bottomRectOffset = size.height*0.925
                    }
                    
                    let roundedRectangleRect = CGRect(x: frame.minX +  border, y: frame.minY, width: width, height: topRectHeight)
                    let roundedRectanglePath = UIBezierPath(roundedRect:roundedRectangleRect, cornerRadius: keyCornerRadius)
                    context.saveGState()
                    roundedRectanglePath.addClip()
                    context.drawLinearGradient(gradient, start: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.minY), end: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.maxY), options: [])
                    context.restoreGState()
                    
                    let roundedRectangle2Rect = CGRect(x: frame.minX +  border, y: frame.minY + bottomRectOffset, width: width, height: bottomRectHeight)
                    let roundedRectangle2Path = UIBezierPath(roundedRect: roundedRectangle2Rect, cornerRadius: keyCornerRadius)
                    context.saveGState()
                    roundedRectangle2Path.addClip()
                    context.drawLinearGradient(gradient, start: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.maxY), end: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.minY), options: [])
                }
                
            } else {
                // White key
                let strokeColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                var strokeColor2 = UIColor(red:0.1, green: 0.1, blue: 0.1, alpha: 0.20)
                if (keyDown) {
                    strokeColor2 = GLNPianoHelper.noteColourFor(midiNumber: noteNumber, alpha: 0.75)
                    // Background
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    context.setFillColor(GLNPianoHelper.noteColourFor(midiNumber: noteNumber, alpha: 0.30).cgColor)
                    context.fill(frame)
                }
                
                let gradientColors = [strokeColor1.cgColor, strokeColor2.cgColor]
                let gradientLocations:[CGFloat] = [0.1, 1.0]
                
                if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: gradientLocations) {
                    let rectanglePath = UIBezierPath(rect:CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.saveGState()
                    rectanglePath.addClip()
                    context.drawRadialGradient(gradient, startCenter: CGPoint(x: size.width/2.0, y: size.height/2.0), startRadius: size.height * 0.01, endCenter: CGPoint(x: size.width/2.0, y: size.height/2.0), endRadius: size.height * 0.6, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                }
            }
            context.restoreGState()
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        }
        return UIImage()
    }
    
    func noteLayer(keyRect: CGRect) -> CATextLayer {
        let noteLayer = VerticallyCenteredTextLayer()
        noteLayer.string = GLNPianoHelper.noteStringFor(midiNumber: noteNumber)
        noteLayer.foregroundColor = UIColor.white.cgColor
        noteLayer.backgroundColor = GLNPianoHelper.noteColourFor(midiNumber: noteNumber, alpha: 0.35).cgColor
        noteLayer.font = UIFont.boldSystemFont(ofSize: 0.0)
        noteLayer.fontSize = (keyRect.size.width/4.0)
        noteLayer.alignmentMode = "center"
        let width  = keyRect.size.width/2.0
        let height = width
        noteLayer.cornerRadius = (height * 0.5)
        noteLayer.frame = CGRect(x: (keyRect.size.width * 0.25), y: (keyRect.size.height - height), width: width, height: height)
        return noteLayer
    }
    
}



