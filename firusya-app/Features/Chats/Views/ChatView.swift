import SwiftUI
import SwiftData

struct ChatView: View {
    let chatId: String
    let currentUserId: String
    let chatTitle: String
    
    @State private var text: String = ""
    
    @Query private var messages: [Message]
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    init(chatId: String, currentUserId: String, chatTitle: String, text: String) {
        self.chatId = chatId
        self.currentUserId = currentUserId
        self.chatTitle = chatTitle
        self.text = text
        
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
            divider
            inputBar
        }
        .navigationTitle(chatTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(chatBackground.ignoresSafeArea())
//        .task {
//            do {
//                try viewModel.loadMessages(for: chatId, using: modelContext)
//            } catch {
//                // Handle error appropriately
//                print("Failed to load messages: \(error)")
//            }
//        }
    }
}

private extension ChatView {
    var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Array(messages.enumerated()), id:\.element.id) { index, message in
                        
                        MessageRowView(
                            message: message
                        )
                        .id(message.id)
                        .padding(.horizontal, 8)
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
        .padding(.bottom, 10)
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
    
    var divider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.06))
            .frame(height: 0.5)
    }
    
    var inputBar: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Button {
                
            } label: {
                Image(systemName: "paperclip")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
                    .frame(width: 32, height: 32)
            }
            
            HStack(alignment: .bottom, spacing: 8) {
                TextField("Message", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)
                    .lineLimit(2...5)
                
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Button {
                        // voice action
                    } label: {
                        Image(systemName: "mic.fill")
                            .font(Font.system(size: 18))
                            .foregroundStyle(.gray)
                    }
                } else {
                    Button {
                        let message = Message(
                            chatId: chatId,
                            senderPeerId: "sender",
                            recipientPeerId: "receiver",
                            text: text,
                            direction: .outgoing,
                            deliveryState: .sending
                        )
                        modelContext.insert(message)
                        print("save message!")
                        text = ""
                        //viewModel.addMessage(message, using: modelContext)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(Font.system(size: 28))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(24) // Optional: Round the corners of the input bar
    }
    
    var chatBackground: some View {
        LinearGradient(
            colors: [
                Color(.systemGray6),
                Color(.systemTeal).opacity(0.08)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    NavigationStack {
        ChatView(chatId: "id-1", currentUserId: "1", chatTitle: "Firusya", text: "text")
    }
}
