//
//  PianoKeyViewModel.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import SwiftUI

public protocol PianoKeyViewModelDelegateProtocol {
    var noteOffset: Int { get }
}

public struct PianoKeyViewModel: Identifiable {
    let keyIndex: Int
    let delegate: PianoKeyViewModelDelegateProtocol
    public var touchDown = false
    public var latched = false

    public var id: Int {
        noteNumber
    }

    public var noteNumber: Int {
        keyIndex + delegate.noteOffset
    }

    public var name: String {
        Note.name(for: noteNumber)
    }

    public var isNatural: Bool {
        let k = noteNumber % 12
        return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11)
    }

    static func == (lhs: PianoKeyViewModel, rhs: PianoKeyViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
