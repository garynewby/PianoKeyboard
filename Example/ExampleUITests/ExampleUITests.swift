//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Gary Newby on 14/08/2020.
//  Copyright © 2020 Gary Newby. All rights reserved.
//

import XCTest

class ExampleUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_stepperIncrementsKeyCount() {
        let coordinate = app.steppers["keyNumberStepper"].coordinate(withNormalizedOffset: CGVector(dx: 0.75, dy: 0.5))
        coordinate.tap()
        XCTAssertEqual(app.staticTexts["keyNumberLabel"].label, "23")
    }

    func test_stepperDecrementsKeyCount() {
        let coordinate = app.steppers["keyNumberStepper"].coordinate(withNormalizedOffset: CGVector(dx: 0.25, dy: 0.5))
        coordinate.tap()
        XCTAssertEqual(app.staticTexts["keyNumberLabel"].label, "21")
    }

    func test_stepperIncrementsOctave() {
        let coordinate = app.steppers["octaveStepper"].coordinate(withNormalizedOffset: CGVector(dx: 0.75, dy: 0.5))
        coordinate.tap()
        XCTAssertEqual(app.staticTexts["octaveLabel"].label, "72")
    }

    func test_stepperDecrementsOctave() {
        let coordinate = app.steppers["octaveStepper"].coordinate(withNormalizedOffset: CGVector(dx: 0.25, dy: 0.5))
        coordinate.tap()
        XCTAssertEqual(app.staticTexts["octaveLabel"].label, "48")
    }

    func test_showNotes() {
        // Hide
        app.switches["showNotesSwitch"].tap()

        sleep(1)

        // Show
        app.switches["showNotesSwitch"].tap()

        waitForElementToExist(app.otherElements["Do"])
        waitForElementToExist(app.otherElements["Re"])
        waitForElementToExist(app.otherElements["Mi"])

        app.otherElements["Do"].press(forDuration: 1.0)
        app.otherElements["Re"].press(forDuration: 1.0)
        app.otherElements["Mi"].press(forDuration: 1.0)

    }
}
