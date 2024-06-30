//
//  MockContainer.swift
//  ToDoTests
//
//  Created by Igor L on 15/06/2024.
//

import Foundation
import SwiftData
import ToDo

@MainActor
var mockContainer: ModelContainer {
    do {
        let container = try ModelContainer(for: ToDoTask.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}
