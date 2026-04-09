//
//  AppState.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 06.03.2026.
//
import Foundation
import SwiftData

@Observable final class AppState {
    var session: SessionState
    var router: Router
    var appPhase: AppPhase
    
    private var hasBootstrapped = false
    
    init(
        session: SessionState = .loggedOut,
        router: Router = Router(),
        appPhase: AppPhase = .launching
    ) {
        self.session = session
        self.router = router
        self.appPhase = appPhase
    }
    
    func bootStrap(using modelContext: ModelContext) async {
        guard hasBootstrapped == false else { return }
        hasBootstrapped = true
        
        do {
            try AppModel.seedIfNeeded(in: modelContext)
        } catch {
            assertionFailure("Failed to bootstrap app data: \(error)")
        }

        appPhase = .ready
    }
    
    func login(as user: User) {
        session = .loggedIn(user)
        router.reset()
    }
    
    func logout() {
        session = .loggedOut
        router.reset()
    }
}


enum AppPhase: Hashable {
    case launching
    case ready
}

enum SessionState: Hashable {
    case loggedOut
    case loggedIn(User)
}
