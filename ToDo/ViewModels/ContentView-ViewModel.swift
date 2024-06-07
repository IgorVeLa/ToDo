//
//  ContentView-ViewModel.swift
//  ToDo
//
//  Created by Igor L on 14/05/2024.
//

import Foundation
import SwiftData

extension ContentView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var tasks = [ToDoTask]()
        
        var showingAddTaskView = false
        var showingDetailTask: ToDoTask? = nil
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
        
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<ToDoTask>(sortBy: [SortDescriptor(\.created, order: .reverse)])
                tasks = try modelContext.fetch(descriptor)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        func delete(at offsets: IndexSet) {
            for offset in offsets {
                // find task in our query
                let task = tasks[offset]
                // remove from db
                modelContext.delete(task)
            }
            // remove from model array
            tasks.remove(atOffsets: offsets)
            try? modelContext.save()
        }
    }
}
