//
//  Todo.swift
//  ToDo
//
//  Created by Igor L on 02/05/2024.
//

import Foundation

struct Todo {
    var name = ""
    var done = false
    var date = Date.now
    var reminder: Date?
}
