//
//  AddTaskView-ViewModel.swift
//  ToDo
//
//  Created by Igor L on 23/05/2024.
//

import Foundation
import SwiftData
import SwiftUI

extension AddTaskView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var lnManager: LocalNotifManager
        
        var name = ""
        var desc = ""
        
        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
        
        var showDueDate = false
        var dueDate: Date?
        var dueDateDisplay = Date()
        
        init(modelContext: ModelContext, lnManager: LocalNotifManager) {
            self.modelContext = modelContext
            self.lnManager = lnManager
        }
        
        func resetShowDueDate() {
            dueDate = nil
            showDueDate = false
        }
        
        func updateDueDate() {
            if (dueDate != nil) {
                dueDate = dueDateDisplay
            } else {
                dueDate = dueDateDisplay
                showDueDate = true
            }
        }
        
        func save() {
            // add Task object to modelContainer
            let newTask = ToDoTask(name: name, desc: desc, dueDate: dueDate)
            // add optional dates
            if let dueDate {
                Task {
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
                    let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                              title: name,
                                                              body: desc,
                                                              dateComponents: dateComponents,
                                                              repeats: false)
                    await lnManager.schedule(localNotif: localNotification)
                }
            }
            
            modelContext.insert(newTask)
            try? modelContext.save()
        }
    }
}
