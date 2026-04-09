//
//  ChatsView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI
import SwiftData

struct ChatsView: View {
    
    @Environment(Router.self) private var router
    @Query(sort: \Chat.createdAt, order: .reverse) private var chats: [Chat]

    
    var body: some View {
        
        List(sortedChats) { chat in
            Button {
                router.openChat(chat)
            } label: {
                chatRow(for: chat)
            }
            .buttonStyle(.plain)
            
        }
        .navigationBarTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.presentNewChat()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
            }
        }
    
    }
}

private extension ChatsView {
    var sortedChats: [Chat] {
        chats.sorted { lhs, rhs in
            let lhsDate = lhs.lastMessageAt ?? lhs.createdAt
            let rhsDate = rhs.lastMessageAt ?? rhs.createdAt

            if lhsDate == rhsDate {
                return lhs.createdAt > rhs.createdAt
            }

            return lhsDate > rhsDate
        }
    }
}

private extension ChatsView {
    func chatRow(for chat: Chat) -> some View {
        return HStack(alignment: .top) {
            if let data = chat.contact.avatar {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
            }
            
            
            VStack(alignment: .leading) {
                Text(chat.contact.displayName)
                    .foregroundStyle(.primary)
                    .font(.headline)
                Text(chat.lastMessageText ?? "No messages yet")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(Color(.green))
                .font(.system(size: 16))
            
            if let lastMessageAt = chat.lastMessageAt {
                Text(lastMessageAt, style: .time)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatsView()
            .environment(Router())
    }
    .modelContainer(AppModel.makePreviewContainer())
}
