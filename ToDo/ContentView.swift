//
//  ContentView.swift
//  ToDo
//
//  Created by Igor L on 02/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(LocalNotifManager.self) var lnManager
    
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks) { task in
                        HStack {
                            Button(task.completed ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "circle"))") {
                                task.completed.toggle()
                            }
                            .buttonStyle(.plain)
                            
                            Text(task.name)
                            
                            Spacer()
                            
                            Text(task.dueDate?.formatted(.dateTime.day().month().year()) ?? "")
                        }
                        .opacity(task.completed ? 0.3 : 1)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showingDetailTaskView = true
                        }
                        .sheet(isPresented: $viewModel.showingDetailTaskView) {
                            TaskDetailView(task: task)
                                .presentationDetents([.medium])
                        }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("TODO")
            .overlay {
                if viewModel.tasks.isEmpty {
                    Button {
                        viewModel.showingAddTaskView.toggle()
                    } label: {
                        ContentUnavailableView("No tasks", systemImage: "square.and.pencil", description: Text("Tap to add"))
                    }
                    .sheet(isPresented: $viewModel.showingAddTaskView, onDismiss: viewModel.fetchData) {
                        AddTaskView(modelContext: viewModel.modelContext, lnManager: lnManager)
                            .presentationDetents([.medium])
                    }
                }
            }
            .toolbar {
                if !viewModel.tasks.isEmpty {
                    ToolbarItem {
                        EditButton()
                    }
                    
                    ToolbarItem {
                        Button("\(Image(systemName: "plus"))") {
                            viewModel.showingAddTaskView.toggle()
                        }
                        .sheet(isPresented: $viewModel.showingAddTaskView, onDismiss: viewModel.fetchData) {
                            AddTaskView(modelContext: viewModel.modelContext, lnManager: lnManager)
                                .presentationDetents([.medium])
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    return ContentView(modelContext: container.mainContext)
        .environment(LocalNotifManager())
        .modelContainer(container)
}
