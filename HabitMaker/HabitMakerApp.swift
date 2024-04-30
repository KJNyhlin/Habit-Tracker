//
//  HabitMakerApp.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-04-30.
//

import SwiftUI

@main
struct HabitMakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
