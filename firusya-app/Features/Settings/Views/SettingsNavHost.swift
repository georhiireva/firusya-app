//
//  LoginView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI

struct SettingsNavHost: View {
    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.settingsPath) {
            SettingsView()
                .navigationTitle("Settings")
                .navigationDestination(for: SettingsRoute.self) { route in
                    switch route {
                    case .profile:
                        Text("Profile")
                    case .devises:
                        Text("Devices")
                    case .security:
                        Text("Security")
                    }
                }
        }
    }
}
