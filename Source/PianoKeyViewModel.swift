//
//  PianoKeyViewModel.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import Foundation

public struct PianoKeyViewModel {
    let keyIndex: Int
    let noteOffset: Int
    public var touchDown = false
    public var latched = false

    public var noteNumber: Int {
        keyIndex + noteOffset
    }

    public var name: String {
        Note.name(for: noteNumber)
    }

    public var isNatural: Bool {
        let k = noteNumber % 12
        return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
    }
}
