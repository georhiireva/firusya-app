//
//  RootView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI
import SwiftData

struct RootView: View {
    
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Group {
            switch appState.appPhase {
            case .launching:
                ProgressView()
                
            case .ready:
                switch appState.session {
                case .loggedOut:
                    LoginView()
                case .loggedIn:
                    MainTabView()
                }
            }
        }
        .task {
            await appState.bootStrap(using: modelContext)
        }
    }
}
