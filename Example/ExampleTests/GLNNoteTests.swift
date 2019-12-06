//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Gary Newby on 05/12/2019.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import XCTest
@testable import Example

class GLNNoteTests: XCTestCase {
    func test_numberToNoteName() {
        XCTAssertEqual(GLNNote.name(for: 0), "C-1")
        XCTAssertEqual(GLNNote.name(for: 30, preferSharps: true), "F#1")
        XCTAssertEqual(GLNNote.name(for: 30), "Gb1")
        XCTAssertEqual(GLNNote.name(for: 60), "C4")
        XCTAssertEqual(GLNNote.name(for: 68), "Ab4")
        XCTAssertEqual(GLNNote.name(for: 119), "B8")
    }

    func test_noteNameToNumber() {
        XCTAssertEqual(GLNNote.midiNumber(for: "C-1"), 0)
        XCTAssertEqual(GLNNote.midiNumber(for: "C#-1"), 1)
        XCTAssertEqual(GLNNote.midiNumber(for: "F#1"), 30)
        XCTAssertEqual(GLNNote.midiNumber(for: "Gb1"), 30)
        XCTAssertEqual(GLNNote.midiNumber(for: "C4"),  60)
        XCTAssertEqual(GLNNote.midiNumber(for: "Ab4"), 68)
        XCTAssertEqual(GLNNote.midiNumber(for: "B8"),  119)
    }
}
