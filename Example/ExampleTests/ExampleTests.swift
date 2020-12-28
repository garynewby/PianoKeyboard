//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Gary Newby on 05/12/2019.
//  Copyright © 2019 Gary Newby. All rights reserved.
//

import XCTest
@testable import Example

class ExampleTests: XCTestCase {
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

    func test_clampNumber() {
        XCTAssertEqual(Int(100).clamp(min: 0, max: 10), 10)
        XCTAssertEqual(Int(-10).clamp(min: 0, max: 10), 0)
        XCTAssertEqual(CGFloat(100.0).clamp(min: 0.0, max: 10.0), 10.0)
        XCTAssertEqual(CGFloat(-10.0).clamp(min: 0.0, max: 10.0), 0.0)
    }

    func test_isWhiteKey() {
        XCTAssertTrue(Int(33).isWhiteKey())
        XCTAssertTrue(Int(60).isWhiteKey())
        XCTAssertTrue(Int(71).isWhiteKey())
        XCTAssertTrue(Int(89).isWhiteKey())
    }
}
