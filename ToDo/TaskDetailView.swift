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
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext, task: ToDoTask) {
        let viewModel = ViewModel(modelContext: modelContext, task: task)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("", text: $viewModel.modifiedTaskName)
                        .onChange(of: viewModel.modifiedTaskName) { (oldValue, newValue) in
                            viewModel.toggleToolBar(newValue: newValue)
                        }
                }
                
                Section("Description") {
                    TextField("", text: $viewModel.modifiedTaskDesc)
                        .onChange(of: viewModel.modifiedTaskDesc) { (oldValue, newValue) in
                            viewModel.toggleToolBar(newValue: newValue)
                        }
                }
                
                // turn due date display into view to be reusable
                Section("Due Date") {
                    Text(viewModel.task.dueDate?.formatted() ?? "N/A")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.showingToolBar)
                }
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
    
    return TaskDetailView(modelContext: container.mainContext, task: taskEx)
        .environment(LocalNotifManager())
        .modelContainer(container)
}
