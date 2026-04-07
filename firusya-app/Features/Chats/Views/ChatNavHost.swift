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
                    case .chat(chatId: let chatId):
                        ChatView(chatId: chatId, currentUserId: "1", chatTitle: "Firusya")
                        
                    case .chatInfo(chatId: let chatId):
                        Text("Chat info \(chatId)")
                    }
                }
        }
    }
}

#Preview {
    ChatNavHost()
        .environment(Router())
        .modelContainer(ChatNavHostPreview.makeContainer())
}

private enum ChatNavHostPreview {
    static func makeContainer() -> ModelContainer {
        let schema = Schema([
            Message.self,
            Contact.self,
            Chat.self,
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            let context = container.mainContext

            let contact = Contact(
                id: "preview-contact",
                displayName: "Firusya",
                subtitle: "online"
            )
            let chat = Chat(
                id: "preview-chat",
                contact: contact,
                peerId: contact.id,
                title: contact.displayName,
                lastMessageText: "Preview message",
                lastMessageAt: Date()
            )

            context.insert(contact)
            context.insert(chat)

            return container
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
    }
}
