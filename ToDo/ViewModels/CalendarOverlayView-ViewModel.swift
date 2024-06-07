//
//  CalendarOverlayView-ViewModel.swift
//  ToDo
//
//  Created by Igor L on 06/06/2024.
//

import Foundation

@Observable
class CalendarOverlay {
    var showDueDate = false
    var dueDate: Date?
    var dueDateDisplay = Date()
    
    func dueDateToggle() {
        showDueDate.toggle()
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
}
