//
//  MoodSyncApp.swift
//  MoodSync
//
//  Created by Gihan Nemindra on 11/20/24.
//

import SwiftUI

@main
struct MoodSyncApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
