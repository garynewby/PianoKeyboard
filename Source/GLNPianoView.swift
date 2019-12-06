//
//  GLNPianoView.swift
//  GLNPianoView
//
//  Created by Gary Newby on 16/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit

@objc public protocol GLNPianoViewDelegate: class {
    func pianoKeyUp(_ keyNumber: Int)
    func pianoKeyDown(_ keyNumber: Int)
}

@IBDesignable public class GLNPianoView: UIView {
    
    @IBInspectable var showNotes: Bool = true
    @objc public weak var delegate: GLNPianoViewDelegate?
    private var keysArray: [GLNPianoKey?] = []
    private var currentTouches = NSMutableSet(capacity: Int(maxNumberOfKeys))
    private static let minNumberOfKeys = 12
    private static let maxNumberOfKeys = 61
    private var _octave = 60
    private var _numberOfKeys = 24
    private var whiteKeyCount = 0
    private var _blackKeyHeight: CGFloat = 0.60
    private var _blackKeyWidth: CGFloat = 0.80
    private var keyCornerRadius: CGFloat = 0
    private var labels: [String?] = Array.init(repeating: nil, count: 128)
    
    @IBInspectable public var blackKeyHeight: CGFloat {
        get {
            return _blackKeyHeight
        }
        set {
            let value = newValue.clamp(min: 0, max: 10)
            _blackKeyHeight = (value.rounded() + 5) * 0.05
        }
    }
    
    @IBInspectable public var blackKeyWidth: CGFloat {
        get {
            return _blackKeyWidth
        }
        set {
            let value = newValue.clamp(min: 0, max: 8)
            _blackKeyWidth = (value.rounded() + 10) * 0.05
        }
    }

    @IBInspectable public var numberOfKeys: Int {
        get {
            return _numberOfKeys
        }
        set {
            _numberOfKeys = newValue.clamp(min: GLNPianoView.minNumberOfKeys, max: GLNPianoView.maxNumberOfKeys)
            initKeys()
            setNeedsLayout()
        }
    }

    public var octave: Int {
        get {
            return _octave
        }
        set {
            _octave = newValue
            initKeys()
            setNeedsLayout()
        }
    }
    
    @objc public func toggleShowNotes() {
        showNotes.toggle()
        setNeedsLayout()
    }
    
    @objc public func aKeyIsDown() -> Bool {
        var downKeyCount = 0
        for key in keysArray {
            if let k = key, k.isDown {
                downKeyCount += 1
            }
        }
        return (downKeyCount > 0)
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initKeys()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initKeys()
    }

    private func initKeys() {
        keyCornerRadius = _blackKeyWidth * 8.0
        whiteKeyCount = 0
        currentTouches = NSMutableSet()
        keysArray = [GLNPianoKey?](repeating: nil, count: Int(_numberOfKeys + 1))
        for index in 1 ..< _numberOfKeys + 1 {
            if index.isWhiteKey() {
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

        let rect: CGRect = bounds
        let whiteKeyHeight = rect.size.height
        let whiteKeyWidth = whiteKeyWidthForRect(rect)
        let blackKeyHeight = rect.size.height * _blackKeyHeight
        let blackKeyWidth = whiteKeyWidth * _blackKeyWidth
        let blackKeyOffset = blackKeyWidth / 2.0

        // White Keys
        var xPosition: CGFloat = 0
        for index in 0 ..< _numberOfKeys {
            if index.isWhiteKey() {
                let newX = (xPosition + 0.5)
                let newW = ((xPosition + whiteKeyWidth + 0.5) - newX)
                let keyRect = CGRect(x: newX, y: 0, width: newW, height: whiteKeyHeight - 1)
                let noteNumber = index + octave
                let key = GLNPianoKey(color: UIColor.white, rect: keyRect, type: .white, cornerRadius: keyCornerRadius, showNotes: showNotes, noteNumber: noteNumber, label: labels[noteNumber])
                keysArray[index] = key
                layer.addSublayer(key.imageLayer)
                xPosition += whiteKeyWidth
            }
        }
        // Black Keys
        xPosition = 0.0
        for index in 0 ..< _numberOfKeys {
            if index.isWhiteKey() {
                xPosition += whiteKeyWidth
            } else {
                let keyRect = CGRect(x: (xPosition - blackKeyOffset), y: 0, width: blackKeyWidth, height: blackKeyHeight)
                let noteNumber = index + octave
                let key = GLNPianoKey(color: UIColor.black, rect: keyRect, type: .black, cornerRadius: keyCornerRadius, showNotes: showNotes, noteNumber: noteNumber, label: labels[noteNumber], blackKeyWidth: blackKeyWidth, blackKeyHeight: blackKeyHeight)
                keysArray[index] = key
                layer.addSublayer(key.imageLayer)
            }
        }
    }
    
    private func whiteKeyWidthForRect(_ rect: CGRect) -> CGFloat {
        return (rect.size.width / CGFloat(whiteKeyCount))
    }
    
    private func updateKeys() {
        let touches = currentTouches.allObjects as Array
        var keyIsDownAt = [Bool](repeating: false, count: _numberOfKeys)
        
        for touchIndex in 0 ..< touches.count {
            let touch = touches[touchIndex]
            let point = (touch as AnyObject).location(in: self)
            let index = getKeyContaining(point)
            if index != NSNotFound {
                keyIsDownAt[index] = true
            }
        }
        
        for index in 0 ..< _numberOfKeys {
            if keysArray[index]?.isDown != keyIsDownAt[index] {
                if keyIsDownAt[index] {
                    delegate?.pianoKeyDown(index)
                    keysArray[index]?.setImage(keyNum: index, isDown: true)
                } else {
                    delegate?.pianoKeyUp(index)
                    keysArray[index]?.setImage(keyNum: index, isDown: false)
                }
                keysArray[index]?.isDown = keyIsDownAt[index]
            }
        }
        setNeedsDisplay()
    }
    
    private func getKeyContaining(_ point: CGPoint) -> Int {
        var keyNum = NSNotFound
        for index in 0 ..< _numberOfKeys {
            if let frame = keysArray[index]?.imageLayer.frame, frame.contains(point) {
                keyNum = index
                if !index.isWhiteKey() {
                    break
                }
            }
        }
        return keyNum
    }

    // MARK: - Highlighting

    public func highlightKeys(noteNames: [String], color: UIColor, play: Bool = false) {
        reset(didPlay: play)
        for note in noteNames {
            let noteNumber = GLNNote.midiNumber(for: note)
            highlight(noteNumber: noteNumber, color: color, play: play)
        }
    }

    public func highlightKeys(noteNumbers: [Int], color: UIColor, play: Bool = false) {
        reset(didPlay: play)
        for noteNumber in noteNumbers {
            highlight(noteNumber: noteNumber, color: color, play: play)
        }
    }

    public func highlightKey(noteName: String, color: UIColor, play: Bool = false) {
        reset(didPlay: play)
        let noteNumber = GLNNote.midiNumber(for: noteName)
        highlight(noteNumber: noteNumber, color: color, play: play)
    }

    public func highlightKey(noteNumber: Int, color: UIColor, play: Bool = false, resets: Bool = true) {
        reset(didPlay: play)
        highlight(noteNumber: noteNumber, color: color, play: play, resets: resets)
    }

    private func highlight(noteNumber: Int, color: UIColor, play: Bool, resets: Bool = true) {
        for key in keysArray {
            if let key = key, key.noteNumber == noteNumber  {
                key.highlightLayer.backgroundColor = color.cgColor
                key.resetsHighLight = resets
                if play {
                    delegate?.pianoKeyDown(key.noteNumber - octave)
                }
            }
        }
    }

    public func reset(didPlay: Bool) {
        for key in keysArray {
            if let key = key  {
                if key.resetsHighLight {
                    key.highlightLayer.backgroundColor = UIColor.clear.cgColor
                }
                if didPlay {
                    delegate?.pianoKeyUp(key.noteNumber - octave)
                }
            }
        }
    }

    // MARK: - Labels

    public func setLabel(for midiNumber: Int, text: String) {
        guard midiNumber < labels.count else {
            return
        }
        labels[midiNumber] = text
    }

    // MARK: - Touches
    
    public override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            currentTouches.add(touch)
        }
        updateKeys()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            currentTouches.add(touch)
        }
        updateKeys()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            currentTouches.remove(touch)
        }
        updateKeys()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            currentTouches.remove(touch)
        }
        updateKeys()
    }
}
