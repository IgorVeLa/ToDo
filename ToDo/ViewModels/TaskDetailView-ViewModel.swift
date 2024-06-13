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
    class ViewModel: CalendarOverlay {
        var modelContext: ModelContext
        var task: ToDoTask
        var showingToolBar = false
        // to keep track for any changes
        var tempTaskName: String
        var tempTaskDesc: String
        var tempDueTask: Date?
        
        var calendarOverlay = CalendarOverlay()
        
        init(modelContext: ModelContext, task: ToDoTask) {
            self.modelContext = modelContext
            self.task = task
            self.tempTaskName = task.name
            self.tempTaskDesc = task.desc
            self.tempDueTask = task.dueDate
        }
        
        func save() {
            if tempDueTask == nil {
                // allows to save task if set to no date
                task.name = tempTaskName
                task.desc = tempTaskDesc
                try? modelContext.save()
            } else {
                // save task to new modified one
                task.name = tempTaskName
                task.desc = tempTaskDesc
                task.dueDate = tempDueTask
                try? modelContext.save()
            }
        }
        
        func toggleToolBar(newValue: String, newDate: Date?) {
            if task.name != newValue ||
                task.desc != newValue || task.dueDate != newDate {
                showingToolBar = true
            } else {
                showingToolBar = false
            }
        }
        
        func cancel() {
            if task.dueDate == nil {
                // if task due date has been set to no date then add date back
                task.dueDate = tempDueTask
            } else {
                tempDueTask = task.dueDate
            }
        }
        
        override func resetShowDueDate() {
            tempDueTask = nil
            // stops showing task dueDate
            task.dueDate = nil
            // hides overlay
            showDueDate = false
            
            showingToolBar = true
        }
        
        override func updateDueDate() {
            if (dueDate != nil) {
                dueDate = dueDateDisplay
                tempDueTask = dueDate
            } else {
                dueDate = dueDateDisplay
                tempDueTask = dueDate
                showDueDate = true
            }
        }
    }
}
