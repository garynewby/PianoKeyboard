//
//  File.swift
//  
//
//  Created by Gary Newby on 05/04/2023.
//

import Foundation
import XCTest
@testable import PianoKeyboard

class PianoKeyViewModelTests: XCTestCase {

    func test_isNatural() {
        var sut = PianoKeyViewModel(keyIndex: 33, noteOffset: 10)
        XCTAssertTrue(sut.isNatural)

        sut = PianoKeyViewModel(keyIndex: 89, noteOffset: 5)
        XCTAssertFalse(sut.isNatural)
    }

    func test_noteNumber() {
        let sut = PianoKeyViewModel(keyIndex: 33, noteOffset: 10)
        XCTAssertEqual(sut.noteNumber, 43)
    }

    func test_name() {
        let sut = PianoKeyViewModel(keyIndex: 60, noteOffset: 12)
        XCTAssertEqual(sut.name, "C5")
    }
}
