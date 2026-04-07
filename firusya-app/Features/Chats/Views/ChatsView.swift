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
    @Environment(\.modelContext) private var context
    @Query private var allChats: [Chat]

    
    var body: some View {
        
        List(allChats) { chat in
            Button {
                navigateToChat(with: chat)
            } label: {
                chatRow(for: chat)
            }
            .buttonStyle(.plain)
            
        }
        .navigationBarTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navigateToNewChat()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
            }
        }
        
    }
    
    func navigateToChat(with chat: Chat) {
        router.openChat(chat.id.uuidString)
    }
    
    func navigateToNewChat() {
        router.presentNewChat()
    }
}


private extension ChatsView {
    func chatRow(for chat: Chat) -> some View {
        HStack(alignment: .top) {
            if let data = chat.contact?.avatar {
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
                Text(chat.contact?.displayName ?? "Unknown contact")
                    .foregroundStyle(.primary)
                    .font(.headline)
                Text(chat.lastMessageText ?? "No message")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(Color(.green))
                .font(.system(size: 16))
            
            Text("22:15")
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    NavigationStack {
        ChatsView()
            .environment(Router())
    }
}
