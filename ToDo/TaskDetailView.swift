//
//  TaskDetailView.swift
//  ToDo
//
//  Created by Igor L on 05/05/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct TaskDetailView: View {
    let task: ToDoTask
    
    var body: some View {
        Form {
            Section("Name"){
                Text(task.name)
            }
            
            Section("Description"){
                Text(task.desc)
            }

            Section("Due Date"){
                Text(task.dueDate?.formatted() ?? "N/A")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    let taskEx = ToDoTask(name: "Study",
                      desc: "Program",
                      dueDate: Date.now,
                      reminder: Date.now
    )
    
    return TaskDetailView(task: taskEx)
        .environment(LocalNotifManager())
        .modelContainer(container)
}
