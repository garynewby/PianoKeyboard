//
//  File.swift
//  
//
//  Created by Gary Newby on 05/04/2023.
//

import Foundation
import XCTest
@testable import PianoKeyboard

class PianoKeyboardViewModelTests: XCTestCase {

    func test_numberOfKeys() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 25

        XCTAssertEqual(sut.keys.count, 25)
        XCTAssertEqual(sut.keyRects.count, 25)
    }

    func test_naturalKeyCount() {
        let sut = PianoKeyboardViewModel()
        sut.numberOfKeys = 25

        XCTAssertEqual(sut.naturalKeyCount, 15)
    }
}
