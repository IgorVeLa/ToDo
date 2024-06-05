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
                            viewModel.toggleToolBar(newValue: newValue, newDate: viewModel.task.dueDate!)
                        }
                }
                
                Section("Description") {
                    TextField("", text: $viewModel.modifiedTaskDesc)
                        .onChange(of: viewModel.modifiedTaskDesc) { (oldValue, newValue) in
                            viewModel.toggleToolBar(newValue: newValue, newDate: viewModel.task.dueDate!)
                        }
                }
                
                // turn due date display into view to be reusable
                Section("Due Date") {
                    if (viewModel.task.dueDate != nil) {
                        HStack {
                            Button("\(Image(systemName: "xmark.circle"))") {
                                viewModel.resetShowDueDate()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text(((viewModel.dueDate != nil) ?
                                  viewModel.dueDate?.formatted(.dateTime.day().month().year()) :
                                    viewModel.task.dueDate?.formatted(.dateTime.day().month().year())) ?? "N/A"
                            )
                                .overlay {
                                    DatePicker(
                                        "",
                                        selection: $viewModel.dueDateDisplay,
                                        displayedComponents: [.date]
                                    )
                                    .blendMode(.destinationOver)
                                }
                                .onChange(of: viewModel.dueDateDisplay) {
                                    viewModel.updateDueDate()
                                }
                            Text(((viewModel.dueDate != nil) ?
                                  viewModel.dueDate?.formatted(.dateTime.hour().minute()) :
                                    viewModel.task.dueDate?.formatted(.dateTime.hour().minute())) ?? ""
                            )
                                .overlay {
                                    DatePicker(
                                        "",
                                        selection: $viewModel.dueDateDisplay,
                                        displayedComponents: [.hourAndMinute]
                                    )
                                    .blendMode(.destinationOver)
                                }
                                .onChange(of: viewModel.dueDateDisplay) {
                                    viewModel.updateDueDate()
                                }
                        }
                    } else {
                        HStack {
                            Text("No due date")
                                .opacity(viewModel.showDueDate ? 0 : 0.7)
                            
                            Spacer()
                        
                            Text((viewModel.showDueDate ? viewModel.dueDate?.formatted(.dateTime.day().month().year()) : "")!)
                            Image(systemName: "calendar")
                                .overlay {
                                    DatePicker(
                                        "",
                                        selection: $viewModel.dueDateDisplay,
                                        in: Date.now...,
                                        displayedComponents: [.date]
                                    )
                                    .blendMode(.destinationOver)
                                }
                                .onChange(of: viewModel.dueDateDisplay) {
                                    viewModel.updateDueDate()
                                }
                            
                            Text((viewModel.showDueDate ? viewModel.dueDate?.formatted(.dateTime.hour().minute()) : "")!)
                            Image(systemName: "clock")
                                .overlay {
                                    DatePicker(
                                        "",
                                        selection: $viewModel.dueDateDisplay,
                                        in: Date.now...,
                                        displayedComponents: [.hourAndMinute]
                                    )
                                    .blendMode(.destinationOver)
                                }
                                .onChange(of: viewModel.dueDateDisplay) {
                                    viewModel.updateDueDate()
                                }
                        }
                    }
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
