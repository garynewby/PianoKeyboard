//
//  PianoKeyboardTests.swift
//  PianoKeyboardTests
//
//  Created by Gary Newby on 05/04/2023.
//

import SwiftUI
import Testing
@testable import PianoKeyboard

private final class DelegateSpy: PianoKeyboardDelegate {
    var keyDownCalls: [Int] = []
    var keyUpCalls: [Int] = []

    func pianoKeyUp(_ keyNumber: Int) {
        keyUpCalls.append(keyNumber)
    }

    func pianoKeyDown(_ keyNumber: Int) {
        keyDownCalls.append(keyNumber)
    }
}

@Suite("PianoKeyboard")
struct PianoKeyboardTests {
    @Test("Note.name from MIDI")
    func numberToNoteName() {
        #expect(Note.name(for: 0) == "C-1")
        #expect(Note.name(for: 30, preferSharps: true) == "F#1")
        #expect(Note.name(for: 30) == "Gb1")
        #expect(Note.name(for: 60) == "C4")
        #expect(Note.name(for: 68) == "Ab4")
        #expect(Note.name(for: 119) == "B8")
    }

    @Test("MIDI from note name")
    func noteNameToNumber() {
        #expect(Note.midiNumber(for: "C-1") == 0)
        #expect(Note.midiNumber(for: "C#-1") == 1)
        #expect(Note.midiNumber(for: "F#1") == 30)
        #expect(Note.midiNumber(for: "Gb1") == 30)
        #expect(Note.midiNumber(for: "C4") == 60)
        #expect(Note.midiNumber(for: "Ab4") == 68)
        #expect(Note.midiNumber(for: "B8") == 119)
        #expect(Note.midiNumber(for: "H2") == 36)
    }

    @Test("Key natural vs accidental")
    func isNatural() {
        var sut = PianoKeyViewModel(keyIndex: 33, noteOffset: 10)
        #expect(sut.isNatural)

        sut = PianoKeyViewModel(keyIndex: 89, noteOffset: 5)
        #expect(!sut.isNatural)
    }

    @Test("Key noteNumber")
    func noteNumber() {
        let sut = PianoKeyViewModel(keyIndex: 33, noteOffset: 10)
        #expect(sut.noteNumber == 43)
    }

    @Test("Key display name")
    func name() {
        let sut = PianoKeyViewModel(keyIndex: 60, noteOffset: 12)
        #expect(sut.name == "C5")
    }

    @Test("Resize keys for count")
    func numberOfKeys() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 25

        #expect(sut.keys.count == 25)
        #expect(sut.keyRects.count == 25)
    }

    @Test("Default 18 keys")
    func defaultKeyCount() {
        let sut = PianoKeyboardViewModel()

        #expect(sut.numberOfKeys == 18)
        #expect(sut.keys.count == 18)
        #expect(sut.keyRects.count == 18)
        #expect(sut.naturalKeyCount == 11)
    }

    @Test("Naturals for 25 keys")
    func naturalKeyCount() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 25

        #expect(sut.naturalKeyCount == 15)
    }

    @Test("Naturals after shrink")
    func naturalKeyCountAfterShrinking() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 12

        #expect(sut.keys.count == 12)
        #expect(sut.naturalKeyCount == 7)
    }

    @Test("Classic natural width")
    func classicStyleNaturalKeyWidth() {
        let style = ClassicStyle(naturalKeySpace: 3)
        let width: CGFloat = 1_000
        let naturalCount = 10
        let space: CGFloat = 3
        let expected = (width - (space * CGFloat(naturalCount - 1))) / CGFloat(naturalCount)
        #expect(style.naturalKeyWidth(width, naturalKeyCount: naturalCount, space: space) == expected)
    }

    @Test("Modern vs classic width")
    func modernStyleNaturalKeyWidthAndSpacing() {
        let modern = ModernStyle()
        let classic = ClassicStyle(naturalKeySpace: 2)
        let width: CGFloat = 600
        let naturalCount = 12
        #expect(modern.naturalKeySpace == 2)
        #expect(
            modern.naturalKeyWidth(width, naturalKeyCount: naturalCount, space: modern.naturalKeySpace)
                == classic.naturalKeyWidth(width, naturalKeyCount: naturalCount, space: 2)
        )
    }

    @Test("VM width matches style")
    func viewModelNaturalKeyWidthMatchesStyle() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 25
        let style = ClassicStyle(naturalKeySpace: 3)
        let totalWidth: CGFloat = 800
        let space: CGFloat = 3
        #expect(
            sut.naturalKeyWidth(totalWidth, space: space)
                == style.naturalKeyWidth(totalWidth, naturalKeyCount: sut.naturalKeyCount, space: space)
        )
    }

    @Test("Touch down/up + delegate")
    func touchDownAndUpUpdatesStateAndDelegate() {
        let sut = PianoKeyboardViewModel()
        let delegate = DelegateSpy()
        sut.delegate = delegate
        sut.numberOfKeys = 3
        sut.keyRects = [
            CGRect(x: 0, y: 0, width: 30, height: 100),
            CGRect(x: 30, y: 0, width: 30, height: 100),
            CGRect(x: 60, y: 0, width: 30, height: 100),
        ]

        sut.touches = [CGPoint(x: 10, y: 10)]
        #expect(sut.keys[0].touchDown)
        #expect(sut.keysPressed == ["C4"])
        #expect(delegate.keyDownCalls == [60])

        sut.touches = []
        #expect(!sut.keys[0].touchDown)
        #expect(sut.keysPressed.isEmpty)
        #expect(delegate.keyUpCalls == [60])
    }

    @Test("Multi-touch keys")
    func multipleTouchesPressMultipleKeys() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 3
        sut.keyRects = [
            CGRect(x: 0, y: 0, width: 30, height: 100),
            CGRect(x: 30, y: 0, width: 30, height: 100),
            CGRect(x: 60, y: 0, width: 30, height: 100),
        ]

        sut.touches = [CGPoint(x: 10, y: 10), CGPoint(x: 70, y: 10)]

        #expect(sut.keys[0].touchDown)
        #expect(!sut.keys[1].touchDown)
        #expect(sut.keys[2].touchDown)
        #expect(Set(sut.keysPressed) == Set(["C4", "D4"]))
    }

    @Test("Latch toggle")
    func latchModeTogglesPressedKey() {
        let sut = PianoKeyboardViewModel()
        let delegate = DelegateSpy()
        sut.delegate = delegate
        sut.numberOfKeys = 2
        sut.keyRects = [
            CGRect(x: 0, y: 0, width: 30, height: 100),
            CGRect(x: 30, y: 0, width: 30, height: 100),
        ]
        sut.latch = true

        sut.touches = [CGPoint(x: 10, y: 10)]
        #expect(sut.keys[0].touchDown)
        #expect(sut.keys[0].latched)
        #expect(sut.keysPressed == ["C4"])

        sut.touches = []
        #expect(sut.keys[0].touchDown)
        #expect(sut.keys[0].latched)

        sut.touches = [CGPoint(x: 10, y: 10)]
        #expect(!sut.keys[0].touchDown)
        #expect(!sut.keys[0].latched)
        #expect(sut.keysPressed.isEmpty)
        #expect(delegate.keyDownCalls == [60])
        #expect(delegate.keyUpCalls == [60])
    }

    @Test("Latch off clears")
    func latchResetClearsPressedState() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 2
        sut.keyRects = [
            CGRect(x: 0, y: 0, width: 30, height: 100),
            CGRect(x: 30, y: 0, width: 30, height: 100),
        ]
        sut.latch = true
        sut.touches = [CGPoint(x: 10, y: 10)]
        sut.touches = []

        sut.latch = false
        #expect(sut.keysPressed.isEmpty)
        #expect(!sut.keys[0].touchDown)
        #expect(!sut.keys[0].latched)
    }

    @Test("Overlap: sharp wins")
    func sharpKeyWinsWhenRectsOverlap() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 2 // C4, C#4
        let overlap = CGRect(x: 0, y: 0, width: 30, height: 100)
        sut.keyRects = [overlap, overlap]

        sut.touches = [CGPoint(x: 10, y: 10)]

        #expect(!sut.keys[0].touchDown)
        #expect(sut.keys[1].touchDown)
        #expect(sut.keysPressed == ["Db4"])
    }
}
