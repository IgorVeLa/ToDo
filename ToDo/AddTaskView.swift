//
//  AddTaskView.swift
//  ToDo
//
//  Created by Igor L on 03/05/2024.
//

import Foundation
import SwiftData
import SwiftUI
import UserNotifications

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext, lnManager: LocalNotifManager) {
        let viewModel = ViewModel(modelContext: modelContext, lnManager: lnManager)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter task name", text: $viewModel.name)
                
                TextField("Description", text: $viewModel.desc)
                
                // reask for authorisation if declined previously
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Due Date")
                        
                        Spacer()
                        
                        if viewModel.showDueDate {
                            Button("\(Image(systemName: "xmark.circle"))") {
                                viewModel.resetShowDueDate()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
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
            .task {
                try? await viewModel.lnManager.requestAuthorisation()
            }
            .navigationTitle("New Task")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    return AddTaskView(modelContext: container.mainContext, lnManager: LocalNotifManager())
        .environment(LocalNotifManager())
        .modelContainer(container)
}
