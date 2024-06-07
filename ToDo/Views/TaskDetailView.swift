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
                    TextField("", text: $viewModel.tempTaskName)
                        .onChange(of: viewModel.tempTaskName) { (oldValue, newValue) in                            viewModel.toggleToolBar(newValue: newValue, newDate: viewModel.task.dueDate)
                        }
                }
                
                Section("Description") {
                    TextField("", text: $viewModel.tempTaskDesc)
                        .onChange(of: viewModel.tempTaskDesc) { (oldValue, newValue) in
                            viewModel.toggleToolBar(newValue: newValue, newDate: viewModel.task.dueDate)
                        }
                }
                
                Section("Due Date") {
                    if let dueDate = viewModel.task.dueDate {
                        HStack {
                            CancelButton(cancelMethod: viewModel.resetShowDueDate)
                            
                            Text((((viewModel.dueDate != nil) ?
                                   viewModel.tempDueTask?.formatted(.dateTime.day().month().year()) :
                                    dueDate.formatted(.dateTime.day().month().year())) ?? "")
                            )
                            .overlay {
                                DateOverlay(selectedDateDisplay: $viewModel.dueDateDisplay)
                            }
                            
                            Text((((viewModel.dueDate != nil) ?
                                   viewModel.tempDueTask?.formatted(.dateTime.hour().minute()) :
                                    dueDate.formatted(.dateTime.hour().minute())) ?? "")
                            )
                            .overlay {
                                DateOverlay(selectedDateDisplay: $viewModel.dueDateDisplay)
                            }
                        }
                        .onChange(of: viewModel.dueDateDisplay) { (oldValue, newValue) in
                            viewModel.toggleToolBar(newValue: viewModel.task.name, newDate: newValue)
                            viewModel.updateDueDate()
                        }
                    } else {
                        HStack {
                            Text("No due date")
                                .opacity(viewModel.showDueDate ? 0.01 : 1)
                            
                            Spacer()
                            
                            CalendarOverlayView(showDueDate: $viewModel.showDueDate,
                                                selectedDate: $viewModel.dueDate,
                                                selectedDateDisplay: $viewModel.dueDateDisplay,
                                                cancelDueDate: viewModel.cancel,
                                                onDateChange: viewModel.updateDueDate)
                            .onChange(of: viewModel.dueDateDisplay) { (oldValue, newValue) in
                                viewModel.toggleToolBar(newValue: viewModel.task.name, newDate: newValue)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.cancel()
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
