//
//  ToDoApp.swift
//  ToDo
//
//  Created by Igor L on 02/05/2024.
//

import SwiftUI
import SwiftData

@main
struct ToDoApp: App {
    let container: ModelContainer
    @State var lnManager = LocalNotifManager()
    
    init() {
        do {
            container = try ModelContainer(for: ToDoTask.self)
        } catch {
            fatalError("Failed to create ModelContainer for tasks.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .environment(lnManager)
        }
        //.modelContainer(for: ToDoTask.self)
        .modelContainer(container)
    }
}
