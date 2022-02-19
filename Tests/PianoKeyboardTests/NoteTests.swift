//
//  File.swift
//  
//
//  Created by Gary Newby on 05/04/2023.
//

import Foundation
import XCTest
@testable import PianoKeyboard

class NoteTests: XCTestCase {
    
    func test_numberToNoteName() {
        XCTAssertEqual(Note.name(for: 0), "C-1")
        XCTAssertEqual(Note.name(for: 30, preferSharps: true), "F#1")
        XCTAssertEqual(Note.name(for: 30), "Gb1")
        XCTAssertEqual(Note.name(for: 60), "C4")
        XCTAssertEqual(Note.name(for: 68), "Ab4")
        XCTAssertEqual(Note.name(for: 119), "B8")
    }

    func test_noteNameToNumber() {
        XCTAssertEqual(Note.midiNumber(for: "C-1"), 0)
        XCTAssertEqual(Note.midiNumber(for: "C#-1"), 1)
        XCTAssertEqual(Note.midiNumber(for: "F#1"), 30)
        XCTAssertEqual(Note.midiNumber(for: "Gb1"), 30)
        XCTAssertEqual(Note.midiNumber(for: "C4"), 60)
        XCTAssertEqual(Note.midiNumber(for: "Ab4"), 68)
        XCTAssertEqual(Note.midiNumber(for: "B8"), 119)
    }
}
