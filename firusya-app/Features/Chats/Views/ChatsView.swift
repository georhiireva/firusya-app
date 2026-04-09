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
    @State private var viewModel = ChatsViewModel()
    @Query(sort: \Chat.createdAt, order: .reverse) private var chats: [Chat]

    
    var body: some View {
        
        List(chats) { chat in
            Button {
                viewModel.onChatTapped(chat, using: router)
            } label: {
                chatRow(for: chat)
            }
            .buttonStyle(.plain)
            
        }
        .navigationBarTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.onComposeTapped(using: router)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
            }
        }
        
    }
}


private extension ChatsView {
    func chatRow(for chat: Chat) -> some View {
        let latestMessage = chat.latestMessage

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
                Text(latestMessage?.text ?? "No messages yet")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(Color(.green))
                .font(.system(size: 16))
            
            if let latestMessage {
                Text(latestMessage.createdAt, style: .time)
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
