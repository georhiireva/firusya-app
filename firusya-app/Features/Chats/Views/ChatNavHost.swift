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
                    case .chat(id: let chatID):
                        ChatDestinationView(chatID: chatID)
                        
                    case .chatInfo(id: let chatID):
                        ChatInfoDestinationView(chatID: chatID)
                    }
                }
        }
    }
}

private struct ChatDestinationView: View {
    let chatID: UUID

    @Environment(\.modelContext) private var modelContext
    @State private var chat: Chat?

    var body: some View {
        Group {
            if let chat {
                ChatView(chat: chat)
            } else {
                ContentUnavailableView("Chat not found", systemImage: "bubble.left.and.bubble.right")
            }
        }
        .task(id: chatID) {
            loadChat()
        }
    }
}

private extension ChatDestinationView {
    func loadChat() {
        let repository = ChatsRepository(modelContext: modelContext)

        do {
            chat = try repository.fetchChat(id: chatID)
        } catch {
            assertionFailure("Failed to fetch chat: \(error)")
            chat = nil
        }
    }
}

private struct ChatInfoDestinationView: View {
    let chatID: UUID

    @Environment(\.modelContext) private var modelContext
    @State private var chat: Chat?

    var body: some View {
        Group {
            if let chat {
                Text(
                    String(
                        format: String(localized: "Chat info %@"),
                        locale: Locale.current,
                        chat.contact.displayName
                    )
                )
            } else {
                ContentUnavailableView("Chat not found", systemImage: "info.circle")
            }
        }
        .task(id: chatID) {
            loadChat()
        }
    }
}

private extension ChatInfoDestinationView {
    func loadChat() {
        let repository = ChatsRepository(modelContext: modelContext)

        do {
            chat = try repository.fetchChat(id: chatID)
        } catch {
            assertionFailure("Failed to fetch chat info: \(error)")
            chat = nil
        }
    }
}

#Preview {
    ChatNavHost()
        .environment(Router())
        .modelContainer(AppModel.makePreviewContainer())
}
