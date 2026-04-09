//
//  LoginView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI
import SwiftData

struct ChatNavHost: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.chatsPath) {
            ChatsView()
                .navigationDestination(for: ChatsRoute.self) { route in
                    switch route {
                    case .chat(chat: let chat):
                        ChatView(chat: chat)
                        
                    case .chatInfo(chat: let chat):
                        Text("Chat info \(chat.contact.displayName)")
                    }
                }
        }
    }
}

#Preview {
    ChatNavHost()
        .environment(Router())
        .modelContainer(AppModel.makePreviewContainer())
}
