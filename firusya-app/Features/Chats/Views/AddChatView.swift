//
//  AddChatView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 15.03.2026.
//
import SwiftUI
import SwiftData

struct AddChatView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Contact.displayName) private var contacts: [Contact]
    @Query private var chats: [Chat]
    
    var body: some View {
        NavigationStack {
            List(contacts) { contact in
                Button {
                    onContactTapped(contact)
                } label: {
                    contactRow(for: contact)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("New Chat")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        router.dismissSheet()
                    }
                }
            }
        }
    }
}

private extension AddChatView {
    func onContactTapped(_ contact: Contact) {
        if let existingChat = existingChat(for: contact) {
            router.dismissSheet()
            router.openChat(existingChat.id.uuidString)
            return
        }

        let newChat = Chat(
            id: UUID().uuidString,
            contact: contact,
            peerId: contact.id,
            title: contact.displayName
        )

        modelContext.insert(newChat)

        do {
            try modelContext.save()
            router.dismissSheet()
            router.openChat(newChat.id.uuidString)
        } catch {
            assertionFailure("Failed to save new chat: \(error)")
        }
    }

    func existingChat(for contact: Contact) -> Chat? {
        chats.first { $0.contact?.id == contact.id }
    }

    func contactRow(for contact: Contact) -> some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.displayName)
                    .font(.body)
                
                if let subtitle = contact.subtitle, subtitle.isEmpty == false {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AddChatView()
        .environment(Router())
        .modelContainer(AppModel.makePreviewContainer())
}
