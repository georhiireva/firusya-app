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
    @State private var viewModel = AddChatViewModel()
    
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
        let repository = ChatsRepository(modelContext: modelContext)

        do {
            let chat = try viewModel.openChat(for: contact, using: repository)
            router.dismissSheet()
            router.openChat(chat)
        } catch {
            assertionFailure("Failed to save new chat: \(error)")
        }
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
