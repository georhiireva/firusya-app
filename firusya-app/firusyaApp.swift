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
    private let sharedModelContainer = AppModel.makeSharedContainer()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(appState.router)
        }
        .modelContainer(sharedModelContainer)
    }
}
