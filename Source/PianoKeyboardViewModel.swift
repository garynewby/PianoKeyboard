//
//  PianoKeyboardViewModel.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI

public protocol PianoKeyboardDelegate: AnyObject {
    func pianoKeyUp(_ keyNumber: Int)
    func pianoKeyDown(_ keyNumber: Int)
}

@Observable
public class PianoKeyboardViewModel {
    
    public var keys: [PianoKeyViewModel] = []
    public var keysPressed: [String] = []
    public var latch = false { didSet { reset() } }
    public var keyRects: [CGRect] = []
    public weak var delegate: PianoKeyboardDelegate?

    private let noteOffset: Int

    public var numberOfKeys = 18 {
        didSet {
            configureKeys()
        }
    }

    public var naturalKeyCount: Int {
        keys.filter { $0.isNatural }.count
    }

    var touches: [CGPoint] = [] {
        didSet { updateKeys() }
    }

    public init(noteOffset: Int = 60) {
        self.noteOffset = noteOffset
        configureKeys()
    }

    func naturalKeyWidth(_ width: CGFloat, space: CGFloat) -> CGFloat {
        (width - (space * CGFloat(naturalKeyCount - 1))) / CGFloat(naturalKeyCount)
    }

    private func configureKeys() {
        keys = Array(repeating: PianoKeyViewModel(keyIndex: 0, noteOffset: noteOffset), count: numberOfKeys)
        keyRects = Array(repeating: .zero, count: numberOfKeys)

        for i in 0..<numberOfKeys {
            keys[i] = PianoKeyViewModel(keyIndex: i, noteOffset: noteOffset)
        }
    }

    private func updateKeys() {
        var keyDownAt = Array(repeating: false, count: numberOfKeys)
        var updatedKeys = keys

        for touch in touches {
            if let index = getKeyContaining(touch) {
                keyDownAt[index] = true
            }
        }

        for index in 0..<numberOfKeys {
            let noteNumber = updatedKeys[index].noteNumber

            if updatedKeys[index].touchDown != keyDownAt[index] {
                if latch {
                    if keyDownAt[index] {
                        let keyLatched = updatedKeys[index].latched
                        if keyLatched {
                            keyUp(noteNumber)
                            updatedKeys[index].latched = false
                            updatedKeys[index].touchDown = false
                        } else {
                            keyDown(noteNumber)
                            updatedKeys[index].latched = true
                            updatedKeys[index].touchDown = true
                        }
                    }

                } else {
                    if keyDownAt[index] {
                        keyDown(noteNumber)
                    } else {
                        keyUp(noteNumber)
                    }
                    updatedKeys[index].touchDown = keyDownAt[index]
                }
            } else {
                if updatedKeys[index].touchDown && keyDownAt[index] && updatedKeys[index].latched {
                    keyUp(noteNumber)
                    updatedKeys[index].latched = false
                    updatedKeys[index].touchDown = false
                }
            }
        }
        keys = updatedKeys
    }

    private func keyDown(_ number: Int) {
        keysPressed.append(Note.name(for: number))
        delegate?.pianoKeyDown(number)
    }

    private func keyUp(_ number: Int) {
        let note = Note.name(for: number)
        guard let index = keysPressed.firstIndex(of: note) else {
            return
        }
        keysPressed.remove(at: index)
        delegate?.pianoKeyUp(number)
    }

    private func getKeyContaining(_ point: CGPoint) -> Int? {
        var keyNum: Int?
        for index in 0..<numberOfKeys {
            if keyRects[index].contains(point) {
                keyNum = index
                if !keys[index].isNatural {
                    break
                }
            }
        }
        return keyNum
    }

    private func reset() {
        var updatedKeys = keys
        for i in 0..<numberOfKeys {
            updatedKeys[i].touchDown = false
            updatedKeys[i].latched = false
            keyUp(updatedKeys[i].noteNumber)
        }
        keys = updatedKeys
    }
}
