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
    @State var lnManager = LocalNotifManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(lnManager)
        }
        .modelContainer(for: ToDoTask.self)
    }
}
