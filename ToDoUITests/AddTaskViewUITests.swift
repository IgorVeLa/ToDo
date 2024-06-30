//
//  AddTaskViewUITests.swift
//  ToDoUITests
//
//  Created by Igor L on 28/06/2024.
//

import XCTest

final class AddTaskViewUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        // Stop test when fail
        continueAfterFailure = false
        // Initialise the XCTest
        app = XCUIApplication()
        // Launch app
        app.launch()
    }

    override func tearDownWithError() throws {
        // ensure test won't have residual values
        app = nil
    }

    func testFromContentUnavailable() throws {
        let overlayButton = app.buttons["noTaskButton"]
        XCTAssertTrue(overlayButton.exists)
        overlayButton.tap()
        
        let addTaskView = app.otherElements["AddTaskView"]
        XCTAssertTrue(addTaskView.exists)
    }

    func testFromToolBar() throws {
        
    }
}
