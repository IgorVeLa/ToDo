//
//  ContentViewTests.swift
//  ToDoTests
//
//  Created by Igor L on 28/06/2024.
//

import SwiftData
import XCTest
@testable import ToDo

final class ContentViewTests: XCTestCase {
    
    private var context: ModelContext!
    private var viewModel: ContentView.ViewModel!
    
    @MainActor
    override func setUpWithError() throws {
        // put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false

        // mock context
        context = mockContainer.mainContext
        viewModel = ContentView.ViewModel(modelContext: context)
    }

    override func tearDownWithError() throws {
        // put teardown code here. This method is called after the invocation of each test method in the class.
        context = nil
        viewModel = nil
    }

    func testEmptyTasks() throws {
        viewModel.fetchData()
        XCTAssertEqual(viewModel.tasks.count, 0, "There should be 0 tasks when the app is first launched.")
    }
    
    func testCreateTasks() throws {
        try createSampleData()
        
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.tasks.count, 3, "There should be 3 tasks.")
    }
    
    func testTaskOrder() throws {
        try createSampleData()
        
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.tasks[0].name, "Do taxes")
        XCTAssertEqual(viewModel.tasks[1].name, "Clean")
    }
    
    func testDeleteTasks() throws {
        try testCreateTasks()
        
        viewModel.delete(at: IndexSet(integer: 0))
        viewModel.delete(at: IndexSet(integer: 0))
        
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.tasks.count, 1, "There should be 3 tasks.")
    }

    func testPerformanceExample() throws {
        // this is an example of a performance test case.
        self.measure {
            // put the code you want to measure the time of here.
        }
    }
    
    func createSampleData() throws {
        let date = Date.now
        let exampleDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        context.insert(ToDoTask(name: "Study", desc: "Anatomy 101"))
        context.insert(ToDoTask(name: "Clean", desc: "Room"))
        context.insert(ToDoTask(name: "Do taxes", dueDate: exampleDate))
        try? context.save()
    }
}

