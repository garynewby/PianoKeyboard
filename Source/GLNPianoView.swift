//
//  GLNPianoView.swift
//  GLNPianoView
//
//  Created by Gary Newby on 16/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import QuartzCore

public protocol GLNPianoViewDataSource: class  {
    func numberOfKeysPerOctaveInPiano(_ piano: GLNPianoView) -> Int
    func piano(_ piano: GLNPianoView, isWhiteKey key: Int) -> Bool
    func piano(_ piano: GLNPianoView, shouldShowTextForKey key: Int) -> Bool
    func piano(_ piano: GLNPianoView, textForKey key: Int) -> String
}

public protocol GLNPianoViewDelegate: class  {
    func pianoKeyUp(_ keyNumber: UInt8)
    func pianoKeyDown(_ keyNumber: UInt8)
}

@IBDesignable
public class GLNPianoView : UIView {
    
    @IBInspectable public var totalNumKeys:Int = 24 {
        didSet {
            whiteKeyCount = 0
            for i in 1 ..< (totalNumKeys + 1) where self.isWhiteKey(i) {
                whiteKeyCount += 1
            }
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var showNotes:Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var octave: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public weak var delegate:GLNPianoViewDelegate?
    public weak var dataSource:GLNPianoViewDataSource?
    public private(set) var keys:[GLNPianoKey] = []
    private var touches = Set<UITouch>()
    private var whiteKeyCount = 0
    
    public var keysPerOctave: Int {
        return dataSource?.numberOfKeysPerOctaveInPiano(self) ?? 12
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        isMultipleTouchEnabled = true
        layer.masksToBounds = true
    }
    
    override public func prepareForInterfaceBuilder() {
        self.totalNumKeys = 24
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if touches.count > 0 {
            return
        }
        
        keys.removeAll()
        
        if let subLayers = layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let blackHeight: CGFloat      = 0.585
        let blackWidth: CGFloat       = 0.80
        let keyCornerRadius: CGFloat  = blackWidth * 8.0
        let rect: CGRect              = bounds
        let whiteKeyHeight            = rect.size.height
        let whiteKeyWidth             = rect.size.width / CGFloat(whiteKeyCount)
        let blackKeyHeight            = rect.size.height * blackHeight
        let blackKeyWidth             = whiteKeyWidth * blackWidth
        let blackKeyOffset            = blackKeyWidth / 2.0
        
        // White Keys
        var x:CGFloat = 0
        for i in 0 ..< totalNumKeys {
            if self.isWhiteKey(i) {
                let newX = (x + 0.5)
                let newW = ((x + whiteKeyWidth + 0.5) - newX)
                let keyRect = CGRect(x: newX, y: 0, width: newW, height: whiteKeyHeight - 1)
                let noteNumber = i + octave
                let showNotes = self.showNotes && dataSource?.piano(self, shouldShowTextForKey: noteNumber) ?? true
                let key =  GLNPianoKey.init(color: UIColor.white,
                                            aRect: keyRect,
                                            whiteKey: true,
                                            blackKeyWidth: blackKeyWidth,
                                            blackKeyHeight: blackKeyHeight,
                                            keyCornerRadius: keyCornerRadius,
                                            showNotes: showNotes,
                                            noteText: textForNote(noteNumber),
                                            noteNumber: noteNumber,
                                            keysPerOctave: keysPerOctave)
                keys.append(key)
                layer.addSublayer(key.layer)
                x += whiteKeyWidth
            }
        }
        
        // Black Keys
        x = 0.0
        for i in 0 ..< totalNumKeys {
            if self.isWhiteKey(i) {
                x += whiteKeyWidth
            } else {
                let keyRect = CGRect(x: (x - blackKeyOffset), y: 0, width: blackKeyWidth, height: blackKeyHeight)
                let key = GLNPianoKey.init(color: UIColor.black,
                                           aRect: keyRect,
                                           whiteKey: false,
                                           blackKeyWidth: blackKeyWidth,
                                           blackKeyHeight: blackKeyHeight,
                                           keyCornerRadius: keyCornerRadius,
                                           showNotes: false,
                                           noteNumber: i + octave,
                                           keysPerOctave: keysPerOctave)
                keys.append(key)
                layer.addSublayer(key.layer)
            }
        }
        
        keys.sort { $0.noteNumber < $1.noteNumber }
    }
    
    private func isWhiteKey(_ key: Int) -> Bool {
        let k = key % 12
        let isWhiteKey = (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
        return  dataSource?.piano(self, isWhiteKey: key) ?? isWhiteKey
    }
    
    private func textForNote(_ noteNumber: Int) -> String {
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
            "C8", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
        return dataSource?.piano(self, textForKey: noteNumber) ?? "\(notesArray[noteNumber])"
    }
    
    public func updateKeys() {
        var keyIsDownAtIndex = [Bool](repeating: false, count: totalNumKeys)
        
        for touch in touches {
            let point = touch.location(in: self)
            let index = getKeyContaining(point)
            if index != NSNotFound {
                keyIsDownAtIndex[index - octave] = true
            }
        }
        
        for key in keys {
            let noteNumber = key.noteNumber
            let isKeyDown = keyIsDownAtIndex[noteNumber - octave]
            if key.isKeyDown != isKeyDown {
                if isKeyDown {
                    delegate?.pianoKeyDown(UInt8(noteNumber))
                } else {
                    delegate?.pianoKeyUp(UInt8(noteNumber))
                }
                key.isKeyDown = isKeyDown
            }
        }
    }
    
    private func getKeyContaining(_ point:CGPoint) -> Int {
        var keyNum = NSNotFound
        for key in keys {
            if key.layer.frame.contains(point) {
                keyNum = key.noteNumber
                if !key.isWhiteKey {
                    break
                }
            }
        }
        return keyNum
    }
    
    public func reset() {
        touches.removeAll()
        setNeedsLayout()
    }
    
    // MARK: - Touches
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.formUnion(touches)
        updateKeys()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.formUnion(touches)
        updateKeys()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.subtract(touches)
        updateKeys()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches.subtract(touches)
        updateKeys()
    }
    
}
