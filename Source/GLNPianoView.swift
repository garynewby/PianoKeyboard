//
//  GLNPianoView.swift
//  GLNPianoView
//
//  Created by Gary Newby on 16/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol GLNPianoViewDelegate {
    func pianoKeyUp(keyNumber:Int)
    func pianoKeyDown(keyNumber:Int)
}

@IBDesignable class GLNPianoView : UIView {
    
    @IBInspectable var totalNumKeys:Int = minNumberOfKeys
    
    static let maxNumberOfKeys = 61
    static let minNumberOfKeys = 12
    
    var delegate:GLNPianoViewDelegate?
    var keyDown = NSMutableArray(capacity:maxNumberOfKeys)
    var keyRects = NSMutableArray(capacity:maxNumberOfKeys)
    var keyLayers = NSMutableArray(capacity:maxNumberOfKeys)
    var currentTouches = NSMutableSet(capacity:maxNumberOfKeys)
    var whiteDoImg:UIImage?
    var whiteUpImg:UIImage?
    var blackDoImg:UIImage?
    var blackUpImg:UIImage?
    var blackHeight:CGFloat = 0
    var blackWidth:CGFloat = 0
    var lastWidth:CGFloat = 0
    var keyCornerRadius:CGFloat = 0
    var whiteKeyCount = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        totalNumKeys = clamp(totalNumKeys, min: GLNPianoView.minNumberOfKeys, max: GLNPianoView.maxNumberOfKeys)
    }
    
    func clamp(value:Int, min:Int,  max:Int) -> Int {
        let r = value < min ? min : value;
        return r > max ? max : r;
    }
    
    func commonInit() {
        blackHeight = 0.585
        blackWidth = 0.63
        keyCornerRadius = blackWidth * 8.0
        whiteKeyCount = 0
        
        currentTouches = NSMutableSet()
        keyDown = NSMutableArray()
        keyRects = NSMutableArray()
        keyLayers = NSMutableArray()
        
        for i in 1 ..< totalNumKeys+1 {
            keyDown.addObject(NSNumber(bool: false))
            keyRects.addObject(NSValue(CGRect: CGRectZero))
            keyLayers.addObject(NSNull())
            if (isWhiteKey(i)) {
                whiteKeyCount += 1
            }
        }
        
        multipleTouchEnabled = true
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commonInit()
        
        let rect:CGRect = bounds
        let whiteKeyHeight = rect.size.height
        let whiteKeyWidth  = whiteKeyWidthForRect(rect)
        let blackKeyHeight = rect.size.height * self.blackHeight
        let blackKeyWidth  = whiteKeyWidth * self.blackWidth
        let blackKeyOffset = blackKeyWidth / 2.0
        
        blackUpImg = blackKeyImage(CGSizeMake(blackKeyWidth, blackKeyHeight), keyDown:false)
        blackDoImg = blackKeyImage(CGSizeMake(blackKeyWidth, blackKeyHeight), keyDown:true)
        whiteUpImg = whiteKeyImage(CGSizeMake(21, 21), keyDown:false)
        whiteDoImg = whiteKeyImage(CGSizeMake(21, 21), keyDown:true)
        
        var runningX:CGFloat = 0
        
        // White Keys
        for i in 0 ..< totalNumKeys {
            if (isWhiteKey(i)) {
                let newX = (runningX + 0.5)
                let newW = ((runningX + whiteKeyWidth + 0.5) - newX)
                let keyRect = CGRectMake(newX, 0, newW, whiteKeyHeight - 1)
                keyLayers[i] = createCALayer(UIColor.whiteColor(), aRect:keyRect, white:true)
                layer.addSublayer(keyLayers[i] as! CALayer)
                runningX += whiteKeyWidth
            }
        }
        
        runningX = 0.0
        
        // Black Keys
        for i in 0 ..< self.totalNumKeys {
            if (isWhiteKey(i)) {
                runningX += whiteKeyWidth
            } else {
                let keyRect = CGRectMake((runningX - blackKeyOffset), 0, blackKeyWidth, blackKeyHeight)
                keyLayers[i] = createCALayer(UIColor.blackColor(), aRect:keyRect, white:false)
                layer.addSublayer(keyLayers[i] as! CALayer)
            }
        }
    }
    
    func whiteKeyWidthForRect(rect:CGRect) -> CGFloat {
        return (rect.size.width / CGFloat(whiteKeyCount))
    }
    
    func createCALayer(color:UIColor, aRect:CGRect, white:Bool) -> CALayer {
        
        let rect = CGRectMake(CGRectGetMinX(aRect), CGRectGetMinY(aRect) - (self.keyCornerRadius*2.0), CGRectGetWidth(aRect), CGRectGetHeight(aRect) + (self.keyCornerRadius*2.0))
        let layer  = CALayer()
        let blackUp = blackUpImg!.CGImage!
        let whiteUp = whiteUpImg!.CGImage!
        var x:CGFloat = 0.0
        
        layer.contentsCenter = CGRectMake(0.5, 0.5, 0.02, 0.02)
        if (white) {
            x = 1.0
            layer.contents = whiteUp
        }
        layer.frame = CGRectInset(rect, x, 0)
        layer.opaque = true
        layer.backgroundColor = color.CGColor
        layer.cornerRadius = self.keyCornerRadius
        
        // Disable implict animations for specified keys
        layer.actions = ["onOrderIn":NSNull(), "onOrderOut":NSNull(), "self.sublayers":NSNull(), "contents":NSNull(), "bounds":NSNull(), "position":NSNull()]
        if (!white) {
            // Black
            layer.contents       = blackUp
            layer.masksToBounds  = true
        }
        
        return layer
    }
    
    func keyDown(keyNum:Int) {
        if keyNum < keyLayers.count {
            let layer = keyLayers[keyNum] as! CALayer
            if (isWhiteKey(keyNum)) {
                layer.contents = whiteDoImg?.CGImage
                layer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1)
            } else {
                layer.contents = blackDoImg?.CGImage
            }
        }
    }
    
    func keyUp(keyNum:Int) {
        if keyNum < keyLayers.count {
            let layer = keyLayers[keyNum] as! CALayer
            if (isWhiteKey(keyNum)) {
                layer.contents = whiteUpImg?.CGImage
                layer.contentsCenter = CGRectMake(0.5, 0.5, 0.02, 0.02)
            } else {
                layer.contents = blackUpImg?.CGImage
            }
        }
    }
    
    func isWhiteKey(key:Int) -> Bool {
        let k = key % 12
        return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
    }
    
    //Mark - Update
    
    func updateKeyRects() {
        if (lastWidth == bounds.size.width) {
            return
        }
        lastWidth = bounds.size.width
        
        let rect            = self.frame
        let whiteKeyHeight = self.bounds.size.height
        let blackKeyHeight = whiteKeyHeight * blackHeight
        let whiteKeyWidth  = whiteKeyWidthForRect(rect)
        let blackKeyWidth  = whiteKeyWidth * blackWidth
        let leftKeyBound   = whiteKeyWidth - (blackKeyWidth / 2.0)
        
        var lastWhiteKey:CGFloat = 0
        keyRects[0] = NSValue(CGRect: CGRectMake(0, 0, whiteKeyWidth, whiteKeyHeight))
        
        for i in 1 ..< totalNumKeys {
            if (!isWhiteKey(i)) {
                keyRects[i] = NSValue(CGRect:CGRectMake((lastWhiteKey * whiteKeyWidth) + leftKeyBound, 0, blackKeyWidth, blackKeyHeight))
            } else {
                lastWhiteKey += 1
                keyRects[i] = NSValue(CGRect:CGRectMake(lastWhiteKey * whiteKeyWidth, 0, whiteKeyWidth, whiteKeyHeight))
            }
        }
    }
    
    func updateKeyStates() {
        
        updateKeyRects()
        
        let touches = currentTouches.allObjects as NSArray
        let count = touches.count
        let currentKeyState = NSMutableArray()
        
        for i in 0 ..< totalNumKeys {
            currentKeyState[i] = NSNumber(bool: false)
        }
        
        for i in 0 ..< count {
            let touch = touches.objectAtIndex(i)
            let point = touch.locationInView(self)
            let index = getKeyboardKey(point)
            if (index != NSNotFound) {
                currentKeyState[index] = NSNumber(bool: true)
            }
        }
        
        for i in 0 ..< totalNumKeys {
            if (keyDown[i] as! Bool != currentKeyState[i] as! Bool) {
                let keyDownState = currentKeyState[i].boolValue
                keyDown[i] = NSNumber(bool:keyDownState)
                if ((keyDownState) == true) {
                    delegate?.pianoKeyDown(i)
                    keyDown(i)
                } else {
                    delegate?.pianoKeyUp(i)
                    keyUp(i)
                }
            }
        }
        
        setNeedsDisplay()
    }
    
    func getKeyboardKey(point:CGPoint) -> Int {
        var keyNum = NSNotFound
        for i in 0 ..< totalNumKeys {
            if (CGRectContainsPoint(keyRects[i].CGRectValue(), point)) {
                keyNum = i
                if (!isWhiteKey(i)) {
                    break
                }
            }
        }
        return keyNum
    }
    
    //Mark - Touch Handling Code
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            currentTouches.addObject(touch)
        }
        updateKeyStates()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateKeyStates()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            currentTouches.removeObject(touch)
        }
        updateKeyStates()
    }
    
    //MARK: - Image generation
    
    func blackKeyImage(aSize:CGSize, keyDown:(Bool)) -> UIImage {
        
        let scale = UIScreen.mainScreen().scale
        var size:CGSize = aSize
        size.width *= scale
        size.height *= scale
        UIGraphicsBeginImageContext(size)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        
        let fillColor = UIColor(red: 0.379, green: 0.379, blue: 0.379, alpha: 1)
        let strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.951)
        
        let gradient1Colors = [strokeColor.CGColor, fillColor.CGColor]
        let gradient1Locations:[CGFloat] = [0.11, 1.0]
        let gradient1 = CGGradientCreateWithColors(colorSpace, gradient1Colors, gradient1Locations)
        
        let frame = CGRectMake(0, 0, size.width, size.height)
        
        let rectanglePath = UIBezierPath(rect:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, size.height))
        strokeColor.setFill()
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
        
        let roundedRectangleRect = CGRectMake(CGRectGetMinX(frame) +  border, CGRectGetMinY(frame), width, topRectHeight)
        let roundedRectanglePath = UIBezierPath(roundedRect:roundedRectangleRect, cornerRadius: self.keyCornerRadius)
        CGContextSaveGState(context)
        roundedRectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient1, CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)), [])
        CGContextRestoreGState(context)
        
        let roundedRectangle2Rect = CGRectMake(CGRectGetMinX(frame) +  border, CGRectGetMinY(frame) + bottomRectOffset, width, bottomRectHeight)
        let roundedRectangle2Path = UIBezierPath(roundedRect: roundedRectangle2Rect, cornerRadius: self.keyCornerRadius)
        CGContextSaveGState(context)
        roundedRectangle2Path.addClip()
        CGContextDrawLinearGradient(context, gradient1, CGPointMake(CGRectGetMidX(roundedRectangle2Rect), CGRectGetMaxY(roundedRectangle2Rect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangle2Rect), CGRectGetMinY(roundedRectangle2Rect)), [])
        CGContextRestoreGState(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    func whiteKeyImage(aSize:CGSize, keyDown:(Bool)) -> UIImage {
        
        let scale = UIScreen.mainScreen().scale
        var size = aSize
        size.width *= scale
        size.height *= scale
        
        UIGraphicsBeginImageContext(size)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()!
        let context = UIGraphicsGetCurrentContext()!
        var fillColor = UIColor(red:0.1, green: 0.1, blue: 0.1, alpha: 0.20)
        var strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.0)
        
        if (keyDown) {
            fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.50)
            strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.0)
        }
        
        let gradient1Colors = [strokeColor.CGColor, fillColor.CGColor]
        let gradient1Locations:[CGFloat] = [0.1, 1.0]
        let gradient1 = CGGradientCreateWithColors(colorSpace, gradient1Colors, gradient1Locations)!
        
        let rectanglePath = UIBezierPath(rect:CGRectMake(0, 0, size.width, size.height))
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawRadialGradient(context, gradient1, CGPointMake(size.width/2.0, size.height/2.0), size.height * 0.01,
                                    CGPointMake(size.width/2.0, size.height/2.0), size.height * 0.6, [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        CGContextRestoreGState(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
}

















