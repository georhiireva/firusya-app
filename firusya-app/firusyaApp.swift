//
//  firusya_appApp.swift
//  firusya-app
//
//  Created by Рева Георгий Александрович on 02.04.2026.
//

import SwiftUI
import SwiftData

@main
struct firusyaApp: App {
    @State private var appState = AppState()
    @State private var contactsStore = ContactsStore()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Message.self, Contact.self, Chat.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(appState.router)
                .environment(contactsStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
