//
//  TaskDetailView-ViewModel.swift
//  ToDo
//
//  Created by Igor L on 25/05/2024.
//

import Foundation
import SwiftData

extension TaskDetailView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var task: ToDoTask
        var showingToolBar = false
        // to keep track for any changes
        var modifiedTaskName: String
        var modifiedTaskDesc: String
        // for DatePickerView
        var showDueDate = false
        var dueDate: Date?
        var dueDateDisplay = Date()
        
        init(modelContext: ModelContext, task: ToDoTask) {
            self.modelContext = modelContext
            self.task = task
            self.modifiedTaskName = task.name
            self.modifiedTaskDesc = task.desc
        }
        
        func resetShowDueDate() {
            dueDate = nil
            showDueDate = false
            task.dueDate = nil
        }
        
        func updateDueDate() {
            if (dueDate != nil) {
                dueDate = dueDateDisplay
            } else {
                dueDate = dueDateDisplay
                showDueDate = true
            }
            
            toggleToolBar(newValue: task.name, newDate: dueDate!)
        }
        
        func save() {
            task.name = modifiedTaskName
            task.desc = modifiedTaskDesc
            task.dueDate = dueDate
            try? modelContext.save()
        }
        
        func toggleToolBar(newValue: String, newDate: Date) {
            if task.name != newValue ||
                task.desc != newValue || task.dueDate != newDate {
                showingToolBar = true
            } else {
                showingToolBar = false
            }
        }
    }
}
