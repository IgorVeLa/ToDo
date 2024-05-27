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
        
        init(modelContext: ModelContext, task: ToDoTask) {
            self.modelContext = modelContext
            self.task = task
            self.modifiedTaskName = task.name
            self.modifiedTaskDesc = task.desc
        }
        
        func save() {
            if modifiedTaskName != task.name ||
                modifiedTaskDesc != task.desc {
                task.name = modifiedTaskName
                task.desc = modifiedTaskDesc
                try? modelContext.save()
            } else {
                task.name = modifiedTaskName
            }
        }
        
        func toggleToolBar(newValue: String) {
            if task.name == newValue ||
                task.desc == newValue {
                showingToolBar = false
            } else {
                showingToolBar = true
            }
        }
    }
}
