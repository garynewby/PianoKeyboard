//
//  UITestsHelpers.swift
//  ExampleUITests
//
//  Created by Gary Newby on 14/08/2020.
//  Copyright © 2020 Gary Newby. All rights reserved.
//

import XCTest

extension XCTestCase {

    func waitForElementToExist(_ element: XCUIElement) {
      let exists = NSPredicate(format: "exists == true")
      expectation(for: exists, evaluatedWith: element, handler: nil)
      waitForExpectations(timeout: 10, handler: nil)
    }

}

extension XCUIElement {

    func assertContains(text: String) {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let elementQuery = staticTexts.containing(predicate)
        XCTAssertTrue(elementQuery.count > 0)
    }
}
