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
    private var keyObjectsArray:[GLNPianoKey?] = []
    private static let minNumberOfKeys = 12
    private static let maxNumberOfKeys = 61
    private var currentTouchesSet = NSMutableSet(capacity:maxNumberOfKeys)
    private var blackHeight:CGFloat = 0
    private var blackWidth:CGFloat = 0
    private var lastWidth:CGFloat = 0
    private var whiteKeyCount = 0
    private var keyCornerRadius:CGFloat = 0
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        totalNumKeys = GLNPianoHelper.clamp(totalNumKeys, min: GLNPianoView.minNumberOfKeys, max: GLNPianoView.maxNumberOfKeys)
    }
    
    func commonInit() {
        blackHeight = 0.585
        blackWidth = 0.80
        keyCornerRadius = blackWidth * 8.0
        whiteKeyCount = 0
        lastWidth = 0
        currentTouchesSet = NSMutableSet()
        keyObjectsArray = [GLNPianoKey?](repeating: nil, count: (totalNumKeys + 1))
        
        for i in 1 ..< totalNumKeys+1 {
            if (i.isWhiteKey()) {
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
        
        let rect:CGRect    = bounds
        let whiteKeyHeight = rect.size.height
        let whiteKeyWidth  = whiteKeyWidthForRect(rect)
        let blackKeyHeight = rect.size.height * blackHeight
        let blackKeyWidth  = whiteKeyWidth * blackWidth
        let blackKeyOffset = blackKeyWidth / 2.0
        
        // White Keys
        var x:CGFloat = 0
        for i in 0 ..< totalNumKeys {
            if (i.isWhiteKey()) {
                let newX = (x + 0.5)
                let newW = ((x + whiteKeyWidth + 0.5) - newX)
                let keyRect = CGRect(x: newX, y: 0, width: newW, height: whiteKeyHeight - 1)
                let key =  GLNPianoKey.init(color: UIColor.white, aRect: keyRect, whiteKey: true, blackKeyWidth: blackKeyWidth,
                                            blackKeyHeight: blackKeyHeight, keyCornerRadius: keyCornerRadius, showNotes: showNotes, noteNumber:(i + Int(octave)))
                keyObjectsArray[i] = key;
                layer.addSublayer(key.layer)
                x += whiteKeyWidth
            }
        }
        // Black Keys
        x = 0.0
        for i in 0 ..< totalNumKeys {
            if (i.isWhiteKey()) {
                x += whiteKeyWidth
            } else {
                let keyRect = CGRect(x: (x - blackKeyOffset), y: 0, width: blackKeyWidth, height: blackKeyHeight)
                let key = GLNPianoKey.init(color: UIColor.black, aRect: keyRect, whiteKey: false, blackKeyWidth: blackKeyWidth,
                                           blackKeyHeight: blackKeyHeight, keyCornerRadius: keyCornerRadius, showNotes: showNotes, noteNumber:(i + Int(octave)))
                keyObjectsArray[i] = key;
                layer.addSublayer(key.layer)
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
    
    func updateKeys() {
        let touches = currentTouchesSet.allObjects as Array
        let count = touches.count
        
        var keyIsDownAtIndex = [Bool](repeating: false, count: totalNumKeys)
        
        for i in 0 ..< count {
            let touch = touches[i]
            let point = (touch as AnyObject).location(in: self)
            let index = getKeyContaining(point)
            if (index != NSNotFound) {
                keyIsDownAtIndex[index] = true
            }
        }
        
        for i in 0 ..< totalNumKeys {
            if (keyObjectsArray[i]?.isKeyDown != keyIsDownAtIndex[i]) {
                if (keyIsDownAtIndex[i]) {
                    delegate?.pianoKeyDown(UInt8(i))
                    keyObjectsArray[i]?.setImage(keyNum: i, isDown: true)
                } else {
                    delegate?.pianoKeyUp(UInt8(i))
                    keyObjectsArray[i]?.setImage(keyNum: i, isDown: false)
                }
                keyObjectsArray[i]?.isKeyDown = keyIsDownAtIndex[i]
            }
            
        }
        setNeedsDisplay()
    }
    
    func getKeyContaining(_ point:CGPoint) -> Int {
        var keyNum = NSNotFound
        for i in 0 ..< totalNumKeys {
            if let frame = keyObjectsArray[i]?.layer.frame, frame.contains(point) {
                keyNum = i
                if (!i.isWhiteKey()) {
                    break
                }
            }
        }
        return keyNum
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouchesSet.add(touch)
        }
        updateKeys()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouchesSet.add(touch)
        }
        updateKeys()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouchesSet.remove(touch)
        }
        updateKeys()
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

















