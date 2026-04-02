import SwiftUI
import SwiftData

struct ChatView: View {
    let chatId: String
    let currentUserId: String
    let chatTitle: String

    @State private var text: String = ""

    @Query private var messages: [Message]

    @Environment(\.modelContext) private var modelContext: ModelContext

    init(chatId: String, currentUserId: String, chatTitle: String) {
        self.chatId = chatId
        self.currentUserId = currentUserId
        self.chatTitle = chatTitle

        _messages = Query(
            filter: #Predicate<Message> {
                $0.chatId == chatId
            },
            sort: \.createdAt,
            order: .forward
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            messageList
            inputBar
        }
        .navigationTitle(chatTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.blue)
            }

            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(chatTitle)
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
    var messageList: some View {
        ScrollViewReader { proxy in
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
                scrollToBottom(proxy: proxy, animated: false)
            }
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy, animated: true)
            }
        }
    }

    func scrollToBottom(proxy: ScrollViewProxy, animated: Bool) {
        guard let lastId = messages.last?.id else { return }

        if animated {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(lastId, anchor: .bottom)
        }
    }

    var inputBar: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Button {
                // attachment
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.blue)
            }

            HStack(alignment: .bottom, spacing: 8) {
                TextField("Message", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...5)

                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.secondary)
                } else {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(Color.blue)
                    }
                }
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

    func sendMessage() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let message = Message(
            chatId: chatId,
            senderPeerId: currentUserId,
            recipientPeerId: "receiver",
            text: trimmedText,
            direction: .outgoing,
            deliveryState: .sending
        )
        modelContext.insert(message)
        text = ""
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
    NavigationStack {
        ChatView(chatId: "id-1", currentUserId: "1", chatTitle: "Firusya")
    }
}
