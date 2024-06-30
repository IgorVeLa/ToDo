//
//  ContentViewUITests.swift
//  ToDoUITests
//
//  Created by Igor L on 15/06/2024.
//

import XCTest

class ContentViewUITests: XCTestCase {

    private var app: XCUIApplication!
    
    // Runs every test
    override func setUpWithError() throws {
        // Stop test when fail
        continueAfterFailure = false
        // Initialise the XCTest
        app = XCUIApplication()
        // Launch app
        app.launch()
    }
    
    // Runs when test ends
    override func tearDownWithError() throws {
        // ensure test won't have residual values
        app = nil
    }
    
    func testOverlay() throws {
        let overlayButton = app.buttons["noTaskButton"]
        
        XCTAssertTrue(overlayButton.exists)
    }
    
    func testToolbar() {
        // TODO: have sample data for tasks to bypass overlay
    }
    
    func testList() throws {
        let overlayButton = app.buttons["noTaskButton"]
        XCTAssertTrue(overlayButton.exists)
        overlayButton.tap()
        
        // TODO: have sample data for tasks to bypass overlay
        
        let addTaskView = app.otherElements["AddTaskView"]
        XCTAssertTrue(addTaskView.exists)
    }
}
