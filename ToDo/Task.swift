//
//  Task.swift
//  ToDo
//
//  Created by Igor L on 02/05/2024.
//

import Foundation
import SwiftData

@Model
class ToDoTask {
    var name = ""
    var desc = ""
    var completed = false
    var dueDate: Date?
    var reminder: Date?
    
    init(name: String = "", desc: String = "", completed: Bool = false, dueDate: Date? = nil, reminder: Date? = nil) {
        self.name = name
        self.desc = desc
        self.completed = completed
        self.dueDate = dueDate
        self.reminder = reminder
    }
}
