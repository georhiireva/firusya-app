//
//  LoginView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI

struct ChatNavHost: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.chatsPath) {
            ChatsView()
                .navigationDestination(for: ChatsRoute.self) { route in
                    switch route {
                    case .chat(chatId: let chatId):
                        ChatView(chatId: chatId, currentUserId: "1", chatTitle: "Firusya", text: "12")
                        
                    case .chatInfo(chatId: let chatId):
                        Text("Chat info \(chatId)")
                    }
                }
        }
    }
}
