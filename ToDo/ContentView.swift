//
//  ContentView.swift
//  ToDo
//
//  Created by Igor L on 02/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(LocalNotifManager.self) var lnManager
    
    @Query private var tasks: [ToDoTask]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @State private var showingAddTaskView = false
    @State private var showingDetailTaskView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
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
                            showingDetailTaskView = true
                        }
                        .sheet(isPresented: $showingDetailTaskView) {
                            TaskDetailView(task: task)
                                .presentationDetents([.medium])
                        }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("TODO")
            .overlay {
                if tasks.isEmpty {
                    Button {
                        showingAddTaskView.toggle()
                    } label: {
                        ContentUnavailableView("No tasks", systemImage: "square.and.pencil", description: Text("Tap to add"))
                    }
                    .sheet(isPresented: $showingAddTaskView) {
                        AddTaskView()
                            .presentationDetents([.medium])
                    }
                }
            }
            .task {
                try? await lnManager.requestAuthorisation()
            }
            .toolbar {
                if !tasks.isEmpty {
                    ToolbarItem {
                        EditButton()
                    }
                    
                    ToolbarItem {
                        Button("\(Image(systemName: "plus"))") {
                            showingAddTaskView.toggle()
                        }
                        .sheet(isPresented: $showingAddTaskView) {
                            AddTaskView()
                                .presentationDetents([.medium])
                        }
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            // find task in our query
            let task = tasks[offset]

            modelContext.delete(task)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    return ContentView()
        .environment(LocalNotifManager())
        .modelContainer(container)
}
