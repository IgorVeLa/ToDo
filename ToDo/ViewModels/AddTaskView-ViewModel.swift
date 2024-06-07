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
    class ViewModel: CalendarOverlay {
        var modelContext: ModelContext
        var lnManager: LocalNotifManager
        
        var name = ""
        var desc = ""
        
        var calendarOverlay = CalendarOverlay()
        
        init(modelContext: ModelContext, lnManager: LocalNotifManager) {
            self.modelContext = modelContext
            self.lnManager = lnManager
        }
        
        func save() {
            // add Task object to modelContainer
            let newTask = ToDoTask(name: name, desc: desc, dueDate: calendarOverlay.dueDate)
            // add optional dates
            if let dueDate = calendarOverlay.dueDate {
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
