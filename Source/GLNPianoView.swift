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
    func pianoKeyUp(_ keyNumber:Int)
    func pianoKeyDown(_ keyNumber:Int)
}

@IBDesignable class GLNPianoView : UIView {
    
    @IBInspectable var totalNumKeys:Int = 24
    
    static let minNumberOfKeys = 12
    static let maxNumberOfKeys = 61
    
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
    
    func clamp(_ value:Int, min:Int,  max:Int) -> Int {
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
            keyDown.add(NSNumber(value: false as Bool))
            keyRects.add(NSValue(cgRect: CGRect.zero))
            keyLayers.add(NSNull())
            if (isWhiteKey(i)) {
                whiteKeyCount += 1
            }
        }
        
        isMultipleTouchEnabled = true
        layer.masksToBounds = true
        if let subLayers = layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
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
        
        if (blackUpImg == nil) {
            blackUpImg = keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown:false)
        }
        if (blackDoImg == nil) {
            blackDoImg = keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown:true)
        }
        if (whiteUpImg == nil) {
            whiteUpImg = keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown:false)
        }
        if (whiteDoImg == nil) {
            whiteDoImg = keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown:true)
        }
        
        var runningX:CGFloat = 0
        
        // White Keys
        for i in 0 ..< totalNumKeys {
            if (isWhiteKey(i)) {
                let newX = (runningX + 0.5)
                let newW = ((runningX + whiteKeyWidth + 0.5) - newX)
                let keyRect = CGRect(x: newX, y: 0, width: newW, height: whiteKeyHeight - 1)
                let keyLayer = createCALayer(UIColor.white, aRect:keyRect, white:true)
                keyLayers[i] = keyLayer;
                layer.addSublayer(keyLayer)
                runningX += whiteKeyWidth
            }
        }
        
        runningX = 0.0
        
        // Black Keys
        for i in 0 ..< self.totalNumKeys {
            if (isWhiteKey(i)) {
                runningX += whiteKeyWidth
            } else {
                let keyRect = CGRect(x: (runningX - blackKeyOffset), y: 0, width: blackKeyWidth, height: blackKeyHeight)
                let keyLayer = createCALayer(UIColor.black, aRect:keyRect, white:false)
                keyLayers[i] = keyLayer;
                layer.addSublayer(keyLayer)
            }
        }
    }
    
    func setNumberOfKeys(count: Int) {
        totalNumKeys = count
        setNeedsLayout()
    }
    
    func whiteKeyWidthForRect(_ rect:CGRect) -> CGFloat {
        return (rect.size.width / CGFloat(whiteKeyCount))
    }
    
    func createCALayer(_ color:UIColor, aRect:CGRect, white:Bool) -> CALayer {
        let rect = CGRect(x: aRect.minX, y: aRect.minY - (self.keyCornerRadius*2.0), width: aRect.width, height: aRect.height + (self.keyCornerRadius*2.0))
        let layer  = CALayer()
        
        if let blackUp = blackUpImg?.cgImage,
            let whiteUp = whiteUpImg?.cgImage
        {
            var x:CGFloat = 0.0
            
            layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.02, height: 0.02)
            if (white) {
                x = 1.0
                layer.contents = whiteUp
            }
            layer.frame = rect.insetBy(dx: x, dy: 0)
            layer.isOpaque = true
            layer.backgroundColor = color.cgColor
            layer.cornerRadius = self.keyCornerRadius
            
            // Disable implict animations for specified keys
            layer.actions = ["onOrderIn":NSNull(), "onOrderOut":NSNull(), "self.sublayers":NSNull(), "contents":NSNull(), "bounds":NSNull(), "position":NSNull()]
            if (!white) {
                // Black
                layer.contents       = blackUp
                layer.masksToBounds  = true
            }
        }
        
        return layer
    }
    
    func keyDown(_ keyNum:Int) {
        if keyNum < keyLayers.count {
            if let keyLayer = keyLayers[keyNum] as? CALayer {
                if (isWhiteKey(keyNum)) {
                    keyLayer.contents = whiteDoImg?.cgImage
                    keyLayer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.1, height: 0.1)
                } else {
                    keyLayer.contents = blackDoImg?.cgImage
                }
            }
        }
    }
    
    func keyUp(_ keyNum:Int) {
        if keyNum < keyLayers.count {
            if let keyLayer = keyLayers[keyNum] as? CALayer {
                if (isWhiteKey(keyNum)) {
                    keyLayer.contents = whiteUpImg?.cgImage
                    keyLayer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.02, height: 0.02)
                } else {
                    keyLayer.contents = blackUpImg?.cgImage
                }
            }
        }
    }
    
    func isWhiteKey(_ key:Int) -> Bool {
        let k = key % 12
        return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
    }
    
    //Mark - Update
    
    func updateKeyRects() {
        if (lastWidth == bounds.size.width) {
            return
        }
        lastWidth = bounds.size.width
        
        let rect           = self.frame
        let whiteKeyHeight = self.bounds.size.height
        let blackKeyHeight = whiteKeyHeight * blackHeight
        let whiteKeyWidth  = whiteKeyWidthForRect(rect)
        let blackKeyWidth  = whiteKeyWidth * blackWidth
        let leftKeyBound   = whiteKeyWidth - (blackKeyWidth / 2.0)
        
        var lastWhiteKey:CGFloat = 0
        keyRects[0] = NSValue(cgRect: CGRect(x: 0, y: 0, width: whiteKeyWidth, height: whiteKeyHeight))
        for i in 1 ..< totalNumKeys {
            if (!isWhiteKey(i)) {
                keyRects[i] = NSValue(cgRect:CGRect(x: (lastWhiteKey * whiteKeyWidth) + leftKeyBound, y: 0, width: blackKeyWidth, height: blackKeyHeight))
            } else {
                lastWhiteKey += 1
                keyRects[i] = NSValue(cgRect:CGRect(x: lastWhiteKey * whiteKeyWidth, y: 0, width: whiteKeyWidth, height: whiteKeyHeight))
            }
        }
    }
    
    func updateKeyStates() {
        updateKeyRects()
        
        let touches = currentTouches.allObjects as NSArray
        let count = touches.count
        let currentKeyState = NSMutableArray()
        
        for i in 0 ..< totalNumKeys {
            currentKeyState[i] = NSNumber(value: false as Bool)
        }
        
        for i in 0 ..< count {
            let touch = touches.object(at: i)
            let point = (touch as AnyObject).location(in: self)
            let index = getKeyboardKey(point)
            if (index != NSNotFound) {
                currentKeyState[index] = NSNumber(value: true as Bool)
            }
        }
        
        for i in 0 ..< totalNumKeys {
            if (keyDown[i] as? Bool != currentKeyState[i] as? Bool) {
                let keyDownState = (currentKeyState[i] as AnyObject).boolValue
                if let downState = keyDownState {
                    keyDown[i] = NSNumber(value: (downState as Bool))
                    if ((keyDownState) == true) {
                        delegate?.pianoKeyDown(i)
                        keyDown(i)
                    } else {
                        delegate?.pianoKeyUp(i)
                        keyUp(i)
                    }
                }
            }
        }
        
        setNeedsDisplay()
    }
    
    func getKeyboardKey(_ point:CGPoint) -> Int {
        var keyNum = NSNotFound
        for i in 0 ..< totalNumKeys {
            if ((keyRects[i] as AnyObject).cgRectValue.contains(point)) {
                keyNum = i
                if (!isWhiteKey(i)) {
                    break
                }
            }
        }
        return keyNum
    }
    
    //Mark - Touch Handling Code
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouches.add(touch)
        }
        updateKeyStates()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateKeyStates()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouches.remove(touch)
        }
        updateKeyStates()
    }
    
    //MARK: - Image generation
    
    func keyImage(_ aSize:CGSize, blackKey:Bool, keyDown:(Bool)) -> UIImage {
        let scale = UIScreen.main.scale
        var size:CGSize = aSize
        size.width *= scale
        size.height *= scale
        UIGraphicsBeginImageContext(size)
        
        if let context = UIGraphicsGetCurrentContext() {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            if (blackKey) {
                let fillColor = UIColor(red: 0.379, green: 0.379, blue: 0.379, alpha: 1)
                let strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.951)
                let gradient1Colors = [strokeColor.cgColor, fillColor.cgColor]
                let gradient1Locations:[CGFloat] = [0.11, 1.0]
                
                if let gradient1 = CGGradient(colorsSpace: colorSpace, colors: gradient1Colors as CFArray, locations: gradient1Locations) {
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    let rectanglePath = UIBezierPath(rect:CGRect(x: frame.minX, y: frame.minY, width: size.width, height: size.height))
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
                    
                    let roundedRectangleRect = CGRect(x: frame.minX +  border, y: frame.minY, width: width, height: topRectHeight)
                    let roundedRectanglePath = UIBezierPath(roundedRect:roundedRectangleRect, cornerRadius: self.keyCornerRadius)
                    context.saveGState()
                    roundedRectanglePath.addClip()
                    context.drawLinearGradient(gradient1, start: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.minY), end: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.maxY), options: [])
                    context.restoreGState()
                    
                    let roundedRectangle2Rect = CGRect(x: frame.minX +  border, y: frame.minY + bottomRectOffset, width: width, height: bottomRectHeight)
                    let roundedRectangle2Path = UIBezierPath(roundedRect: roundedRectangle2Rect, cornerRadius: self.keyCornerRadius)
                    context.saveGState()
                    roundedRectangle2Path.addClip()
                    context.drawLinearGradient(gradient1, start: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.maxY), end: CGPoint(x: roundedRectangle2Rect.midX, y: roundedRectangle2Rect.minY), options: [])
                }
                
            } else {
                var fillColor = UIColor(red:0.1, green: 0.1, blue: 0.1, alpha: 0.20)
                var strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.0)
                
                if (keyDown) {
                    fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.50)
                    strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.0)
                }
                
                let gradient1Colors = [strokeColor.cgColor, fillColor.cgColor]
                let gradient1Locations:[CGFloat] = [0.1, 1.0]
                if let gradient1 = CGGradient(colorsSpace: colorSpace, colors: gradient1Colors as CFArray, locations: gradient1Locations) {
                    let rectanglePath = UIBezierPath(rect:CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.saveGState()
                    rectanglePath.addClip()
                    context.drawRadialGradient(gradient1, startCenter: CGPoint(x: size.width/2.0, y: size.height/2.0), startRadius: size.height * 0.01, endCenter: CGPoint(x: size.width/2.0, y: size.height/2.0), endRadius: size.height * 0.6, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
                }
            }
            context.restoreGState()
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        }
        return UIImage()
    }
    
}

















