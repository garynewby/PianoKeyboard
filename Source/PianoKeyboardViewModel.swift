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

public class PianoKeyboardViewModel: ObservableObject, PianoKeyViewModelDelegateProtocol {
    @Published public var keys: [PianoKeyViewModel] = []
    @Published public var noteOffset = 60
    @Published public var showLabels = true
    @Published public var latch = false {
        didSet { reset() }
    }

    public var keyRects: [CGRect] = []
    public weak var delegate: PianoKeyboardDelegate?
    public var numberOfKeys = 18 {
        didSet { configureKeys() }
    }
    public var naturalKeyCount: Int {
        keys.filter { $0.isNatural }.count
    }

    var touches: [CGPoint] = [] {
        didSet { updateKeys() }
    }

    public init() {
        configureKeys()
    }

    func naturalKeyWidth(_ width: CGFloat, space: CGFloat) -> CGFloat {
        (width - (space * CGFloat(naturalKeyCount - 1))) / CGFloat(naturalKeyCount)
    }

    private func configureKeys() {
        keys = Array(repeating: PianoKeyViewModel(keyIndex: 0, delegate: self), count: numberOfKeys)
        keyRects = Array(repeating: .zero, count: numberOfKeys)

        for i in 0..<numberOfKeys {
            keys[i] = PianoKeyViewModel(keyIndex: i, delegate: self)
        }
    }

    private func updateKeys() {
        var keyDownAt = Array(repeating: false, count: numberOfKeys)

        for touch in touches {
            if let index = getKeyContaining(touch) {
                keyDownAt[index] = true
            }
        }

        for index in 0..<numberOfKeys {
            let noteNumber = keys[index].noteNumber

            if keys[index].touchDown != keyDownAt[index] {
                if latch {
                    let keyLatched = keys[index].latched

                    if keyDownAt[index] && keyLatched {
                        delegate?.pianoKeyUp(noteNumber)
                        keys[index].latched = false
                        keys[index].touchDown = false
                    }
                    if keyDownAt[index] && !keyLatched {
                        delegate?.pianoKeyDown(noteNumber)
                        keys[index].latched = true
                        keys[index].touchDown = true
                    }

                } else {
                    if keyDownAt[index] {
                        delegate?.pianoKeyDown(noteNumber)
                    } else {
                        delegate?.pianoKeyUp(noteNumber)
                    }
                    keys[index].touchDown = keyDownAt[index]
                }
            } else {
                if keys[index].touchDown && keyDownAt[index] && keys[index].latched {
                    delegate?.pianoKeyUp(noteNumber)
                    keys[index].latched = false
                    keys[index].touchDown = false
                }
            }
        }
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
        for i in 0..<numberOfKeys {
            keys[i].touchDown = false
            keys[i].latched = false
            delegate?.pianoKeyUp(keys[i].noteNumber)
        }
    }
}
