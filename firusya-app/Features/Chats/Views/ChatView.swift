import SwiftUI
import SwiftData

struct ChatView: View {
    let chat: Chat

    @State private var viewModel = ChatViewModel()

    @Environment(\.modelContext) private var modelContext: ModelContext

    var body: some View {
        VStack(spacing: 0) {
            messageList(for: chat)
            inputBar(for: chat)
        }
        .navigationTitle(chat.contact.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(chat.contact.displayName)
                        .font(.system(size: 17, weight: .semibold))
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "phone")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.blue)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .background(chatBackground.ignoresSafeArea())
        .task(id: chat.id) {
            loadMessages()
        }
    }
}

private extension ChatView {
    func messageList(for chat: Chat) -> some View {
        return ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 6) {
                    if viewModel.isLoadingHistory {
                        ProgressView()
                            .padding(.vertical, 8)
                    }

                    ForEach(viewModel.messages, id: \.persistentModelID) { message in
                        MessageRowView(message: message)
                            .id(message.id)
                            .padding(.horizontal, 12)
                            .onAppear {
                                loadOlderMessagesIfNeeded(triggeredBy: message)
                            }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .defaultScrollAnchor(.bottom)
            .onChange(of: viewModel.messages.count) { _, _ in
                handleMessageListUpdate(with: proxy)
            }
        }
    }

    func loadMessages() {
        let repository = MessagesRepository(modelContext: modelContext)

        do {
            try viewModel.loadInitialMessages(for: chat, using: repository)
        } catch {
            assertionFailure("Failed to fetch messages: \(error)")
        }
    }

    func loadOlderMessagesIfNeeded(triggeredBy message: Message) {
        let repository = MessagesRepository(modelContext: modelContext)

        do {
            _ = try viewModel.loadOlderMessagesIfNeeded(
                for: chat,
                triggerMessageID: message.id,
                using: repository
            )
        } catch {
            assertionFailure("Failed to fetch older messages: \(error)")
        }
    }

    func handleMessageListUpdate(with proxy: ScrollViewProxy) {
        switch viewModel.consumePendingListUpdate() {
        case .none:
            break

        case .initialLoad(let bottomMessageID):
            scroll(to: bottomMessageID, in: proxy, anchor: .bottom, animated: false)

        case .appendedMessage(let bottomMessageID):
            scroll(to: bottomMessageID, in: proxy, anchor: .bottom, animated: true)

        case .prependedHistory(let anchorMessageID):
            scroll(to: anchorMessageID, in: proxy, anchor: .top, animated: false)
        }
    }

    func scroll(to messageID: UUID, in proxy: ScrollViewProxy, anchor: UnitPoint, animated: Bool) {
        if animated {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(messageID, anchor: anchor)
            }
        } else {
            proxy.scrollTo(messageID, anchor: anchor)
        }
    }

    func inputBar(for chat: Chat) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Button {
                // attachment
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.blue)
            }
            .frame(width: 26, height: 26)

            HStack(alignment: .bottom, spacing: 8) {
                TextField("Message", text: $viewModel.draftText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...5)

                Group {
                    if viewModel.canSend == false {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.secondary)
                    } else {
                        Button {
                            sendMessage(in: chat)
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 26))
                                .foregroundStyle(Color.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 26, height: 26, alignment: .center)
                .contentShape(Rectangle())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(Capsule(style: .continuous))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }

    func sendMessage(in chat: Chat) {
        let repository = MessagesRepository(modelContext: modelContext)

        do {
            try viewModel.sendMessage(in: chat, using: repository)
        } catch {
            assertionFailure("Failed to save message: \(error)")
        }
    }

    var chatBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.79, green: 0.9, blue: 0.98),
                Color(red: 0.88, green: 0.96, blue: 0.93)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    ChatViewPreviewHost()
}

private struct ChatViewPreviewHost: View {
    @Environment(\.modelContext) private var modelContext
    @State private var previewChat: Chat?

    var body: some View {
        NavigationStack {
            if let chat = previewChat {
                ChatView(chat: chat)
            }
        }
        .task {
            loadPreviewChat()
        }
    }
}

private extension ChatViewPreviewHost {
    func loadPreviewChat() {
        let repository = ChatsRepository(modelContext: modelContext)

        do {
            previewChat = try repository.fetchChat(id: AppModel.previewChatID)
        } catch {
            assertionFailure("Failed to fetch preview chat: \(error)")
        }
    }
}
