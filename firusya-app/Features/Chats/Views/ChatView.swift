import SwiftUI
import SwiftData

struct ChatView: View {
    let chat: Chat

    @State private var text: String = ""
    @Query private var messages: [Message]

    @Environment(\.modelContext) private var modelContext: ModelContext

    init(chat: Chat) {
        self.chat = chat
        let chatID = chat.id
        _messages = Query(
            filter: #Predicate<Message> {
                $0.chat.id == chatID
            },
            sort: \.createdAt,
            order: .forward
        )
    }

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
    }
}

private extension ChatView {
    func messageList(for chat: Chat) -> some View {
        return ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(messages, id: \.persistentModelID) { message in
                        MessageRowView(message: message)
                            .id(message.id)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .defaultScrollAnchor(.bottom)
            .onAppear {
                scrollToBottom(proxy: proxy, animated: false, messages: messages)
            }
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy, animated: true, messages: messages)
            }
        }
    }

    func scrollToBottom(proxy: ScrollViewProxy, animated: Bool, messages: [Message]) {
        guard let lastId = messages.last?.id else { return }

        if animated {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(lastId, anchor: .bottom)
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
                TextField("Message", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...5)

                Group {
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let message = Message(
            chat: chat,
            text: trimmedText,
            direction: .outgoing,
            deliveryState: .sending
        )
        modelContext.insert(message)

        do {
            try modelContext.save()
            text = ""
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
    @Query private var chats: [Chat]

    var body: some View {
        NavigationStack {
            if let chat = chats.first {
                ChatView(chat: chat)
            }
        }
    }

    init() {
        let previewChatID = AppModel.previewChatID
        _chats = Query(
            filter: #Predicate<Chat> {
                $0.id == previewChatID
            }
        )
    }
}
