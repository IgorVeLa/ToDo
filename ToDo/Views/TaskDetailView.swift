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
                        .onChange(of: viewModel.modifiedTaskName) { (oldValue, newValue) in                            viewModel.toggleToolBar(newValue: newValue, newDate: viewModel.originalTaskDate)
                        }
                }
                
                Section("Description") {
                    TextField("", text: $viewModel.modifiedTaskDesc)
                        .onChange(of: viewModel.modifiedTaskDesc) { (oldValue, newValue) in
                            viewModel.toggleToolBar(newValue: newValue, newDate: viewModel.originalTaskDate)
                        }
                }
                
                Section("Due Date") {
                        HStack {
                            CancelButton(cancelMethod: viewModel.resetShowDueDate)
                            
                            Text(((viewModel.calendarOverlay.dueDate != nil) ?
                                  viewModel.calendarOverlay.dueDate?.formatted(.dateTime.day().month().year()) :
                                    viewModel.task.dueDate?.formatted(.dateTime.day().month().year())) ?? "N/A"
                            )
                            .overlay {
                                DateOverlay(selectedDateDisplay: $viewModel.calendarOverlay.dueDateDisplay)
                            }
                            .onChange(of: viewModel.calendarOverlay.dueDateDisplay) {
                                viewModel.calendarOverlay.updateDueDate()
                            }
                            
                            Text(((viewModel.calendarOverlay.dueDate != nil) ?
                                  viewModel.calendarOverlay.dueDate?.formatted(.dateTime.hour().minute()) :
                                    viewModel.task.dueDate?.formatted(.dateTime.hour().minute())) ?? ""
                            )
                            .overlay {
                                TimeOverlay(selectedDateDisplay: $viewModel.calendarOverlay.dueDateDisplay)
                            }
                            .onChange(of: viewModel.calendarOverlay.dueDateDisplay) {
                                viewModel.calendarOverlay.updateDueDate()
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.dueDate = viewModel.originalTaskDate
                        viewModel.save()
                        print("original date: \(viewModel.originalTaskDate)")
                        print("dueDate: \(viewModel.dueDate)")
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
