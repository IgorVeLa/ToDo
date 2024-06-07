//
//  ToDoApp.swift
//  ToDo
//
//  Created by Igor L on 02/05/2024.
//

import SwiftUI
import SwiftData
@main    struct ToDoApp: App {
    let container: ModelContainer
    let context: ModelContext
    @State var lnManager = LocalNotifManager()
    
    init() {
        do {
            container = try ModelContainer(for: ToDoTask.self)
            context = ModelContext(container)
            context.autosaveEnabled = false
        } catch {
            fatalError("Failed to create ModelContainer for tasks.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: context)
                .environment(lnManager)
        }
        .modelContainer(container)
    }
}
