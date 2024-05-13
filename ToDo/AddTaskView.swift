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
    @Environment(\.modelContext) private var modelContext
    @Environment(LocalNotifManager.self) var lnManager
    
    @State private var name = ""
    @State private var desc = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    @State private var showDueDate = false
    @State private var dueDate: Date?
    @State private var dueDateDisplay = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter task name", text: $name)
                
                TextField("Description", text: $desc)
                
                // TODO: add enable notif button when not granted
                VStack(alignment: .leading) {
                    HStack {
                        Text("Due Date")
                        
                        Spacer()
                        
                        if showDueDate {
                            Button("\(Image(systemName: "xmark.circle"))") {
                                dueDate = nil
                                showDueDate = false
                                print("NO SHOW")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        
                        Text((showDueDate ? dueDate?.formatted(.dateTime.day().month().year()) : "")!)
                        Image(systemName: "calendar")
                            .overlay {
                                DatePicker(
                                    "",
                                    selection: $dueDateDisplay,
                                    in: Date.now...,
                                    displayedComponents: [.date]
                                )
                                .blendMode(.destinationOver)
                            }
                            .onChange(of: dueDateDisplay) {
                                if (dueDate != nil) {
                                    dueDate = dueDateDisplay
                                } else {
                                    dueDate = dueDateDisplay
                                    showDueDate = true
                                    print("SHOW")
                                }
                            }
                        
                        Text((showDueDate ? dueDate?.formatted(.dateTime.hour().minute()) : "")!)
                        Image(systemName: "clock")
                            .overlay {
                                DatePicker(
                                    "",
                                    selection: $dueDateDisplay,
                                    in: Date.now...,
                                    displayedComponents: [.hourAndMinute]
                                )
                                .blendMode(.destinationOver)
                            }
                            .onChange(of: dueDateDisplay) {
                                if (dueDate != nil) {
                                    dueDate = dueDateDisplay
                                } else {
                                    dueDate = dueDateDisplay
                                    showDueDate = true
                                    print("SHOW")
                                }
                            }
                        }
                    }
            }
            .navigationTitle("New Task")
            .toolbar {
                Button("Save", action: save)
            }
        }
    }
    
    func save() {
        // add Task object to modelContainer
        let newTask = ToDoTask(name: name, desc: desc, dueDate: dueDate)
        // add optional dates
        if let dueDate {
            Task {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
                let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                          title: name,
                                                          body: desc,
                                                          dateComponents: dateComponents,
                                                          repeats: false)
                await lnManager.schedule(localNotif: localNotification)
            }
        }
        
        modelContext.insert(newTask)
        
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    return AddTaskView()
        .environment(LocalNotifManager())
        .modelContainer(container)
}
