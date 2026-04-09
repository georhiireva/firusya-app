//
//  ContactProfileView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI
import SwiftData

struct ContactProfileView: View {
    
    let contactId: UUID
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ContactProfileViewModel()
    
    var body: some View {
        Group {
            if let contact = viewModel.contact {
                content(for: contact)
            } else {
                ContentUnavailableView("Contact not found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
        .task(id: contactId) {
            loadContact()
        }
    }
}

private extension ContactProfileView {
    func loadContact() {
        let repository = ContactsRepository(modelContext: modelContext)

        do {
            try viewModel.loadContact(id: contactId, using: repository)
        } catch {
            assertionFailure("Failed to fetch contact: \(error)")
        }
    }

    func content(for contact: Contact) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.secondary)
            
            Text(contact.displayName)
                .font(.title2)
                .fontWeight(.semibold)
            
            if let subtitle = contact.subtitle, subtitle.isEmpty == false {
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }

            Text("Contact id: \(contact.id)")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Profile")
    }
}


#Preview {
    NavigationStack {
        ContactProfileView(contactId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!)
    }
    .modelContainer(AppModel.makePreviewContainer())
}
