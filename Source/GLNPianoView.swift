//
//  GLNPianoView.swift
//  GLNPianoView
//
//  Created by Gary Newby on 16/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore

public protocol GLNPianoViewDelegate: class  {
    func pianoKeyUp(_ keyNumber: UInt8)
    func pianoKeyDown(_ keyNumber: UInt8)
}

@IBDesignable public class GLNPianoView : UIView {
    
    @IBInspectable var totalNumKeys:Int = 24
    @IBInspectable var showNotes:Bool = true
    public weak var delegate:GLNPianoViewDelegate?
    public var octave: UInt8 = 60
    private static let minNumberOfKeys = 12
    private static let maxNumberOfKeys = 61
    private var keyDown = NSMutableArray(capacity:maxNumberOfKeys)
    private var keyRects = NSMutableArray(capacity:maxNumberOfKeys)
    private var keyLayers = NSMutableArray(capacity:maxNumberOfKeys)
    private var currentTouches = NSMutableSet(capacity:maxNumberOfKeys)
    private var whiteDoImg:UIImage?
    private var whiteUpImg:UIImage?
    private var blackDoImg:UIImage?
    private var blackUpImg:UIImage?
    private var blackHeight:CGFloat = 0
    private var blackWidth:CGFloat = 0
    private var lastWidth:CGFloat = 0
    private var whiteKeyCount = 0
    var keyCornerRadius:CGFloat = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        totalNumKeys = clamp(totalNumKeys, min: GLNPianoView.minNumberOfKeys, max: GLNPianoView.maxNumberOfKeys)
    }
    
    func commonInit() {
        blackHeight = 0.585
        blackWidth = 0.80
        keyCornerRadius = blackWidth * 8.0
        whiteKeyCount = 0
        lastWidth = 0
        
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
        
        let rect:CGRect = bounds
        let whiteKeyHeight = rect.size.height
        let whiteKeyWidth  = whiteKeyWidthForRect(rect)
        let blackKeyHeight = rect.size.height * blackHeight
        let blackKeyWidth  = whiteKeyWidth * blackWidth
        let blackKeyOffset = blackKeyWidth / 2.0
        
        blackUpImg = keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown:false)
        blackDoImg = keyImage(CGSize(width: blackKeyWidth, height: blackKeyHeight), blackKey: true, keyDown:true)
        whiteUpImg = keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown:false)
        whiteDoImg = keyImage(CGSize(width: 21, height: 21), blackKey: false, keyDown:true)
        
        // White Keys
        var x:CGFloat = 0
        for i in 0 ..< totalNumKeys {
            if (isWhiteKey(i)) {
                let newX = (x + 0.5)
                let newW = ((x + whiteKeyWidth + 0.5) - newX)
                let keyRect = CGRect(x: newX, y: 0, width: newW, height: whiteKeyHeight - 1)
                let keyLayer = createCALayer(UIColor.white, aRect:keyRect, white:true)
                keyLayers[i] = keyLayer;
                layer.addSublayer(keyLayer)
                if (showNotes) {
                    layer.addSublayer(noteLayer(midiNumber: i + Int(octave), keyRect: keyRect, textColour: UIColor.lightGray))
                }
                x += whiteKeyWidth
            }
        }
        
        // Black Keys
        x = 0.0
        for i in 0 ..< totalNumKeys {
            if (isWhiteKey(i)) {
                x += whiteKeyWidth
            } else {
                let keyRect = CGRect(x: (x - blackKeyOffset), y: 0, width: blackKeyWidth, height: blackKeyHeight)
                let keyLayer = createCALayer(UIColor.black, aRect:keyRect, white:false)
                keyLayers[i] = keyLayer;
                layer.addSublayer(keyLayer)
                if (showNotes) {
                    layer.addSublayer(noteLayer(midiNumber: i + Int(octave), keyRect: keyRect, textColour: UIColor.white))
                }
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
        let rect = CGRect(x: aRect.minX, y: aRect.minY - (keyCornerRadius*2.0), width: aRect.width, height: aRect.height + (keyCornerRadius*2.0))
        let layer  = CALayer()
        if let blackUp = blackUpImg?.cgImage, let whiteUp = whiteUpImg?.cgImage {
            var x:CGFloat = 0.0
            layer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.02, height: 0.02)
            if (white) {
                x = 1.0
                layer.contents = whiteUp
            }
            layer.frame = rect.insetBy(dx: x, dy: 0)
            layer.isOpaque = true
            layer.backgroundColor = color.cgColor
            layer.cornerRadius = keyCornerRadius
            
            // Disable implict animations for specified keys
            layer.actions = ["onOrderIn":NSNull(), "onOrderOut":NSNull(), "sublayers":NSNull(), "contents":NSNull(), "bounds":NSNull(), "position":NSNull()]
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
    
    func updateKeyRects() {
        if (lastWidth == bounds.size.width) {
            return
        }
        lastWidth = bounds.size.width
        
        let rect           = frame
        let whiteKeyHeight = bounds.size.height
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
                        delegate?.pianoKeyDown(UInt8(i))
                        keyDown(i)
                    } else {
                        delegate?.pianoKeyUp(UInt8(i))
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
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouches.add(touch)
        }
        updateKeyStates()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateKeyStates()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouches.remove(touch)
        }
        updateKeyStates()
    }
    
    func toggleShowNotes() {
        showNotes = !showNotes
        setNeedsLayout()
    }
    
    func setOctave(_ value: Int) {
        octave = UInt8(value)
        setNeedsLayout()
    }
    
}

















