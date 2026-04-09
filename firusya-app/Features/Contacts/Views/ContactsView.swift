//
//  ContactsView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI
import SwiftData

struct ContactsView: View {
    
    @Environment(Router.self) private var router
    @Query(sort: \Contact.displayName) private var contacts: [Contact]
    
    var body: some View {
        List(contacts) { contact in
            Button {
                router.openContact(contact.id)
            } label: {
                contactRow(for: contact)
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Contacts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.presentAddContact()
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

private extension ContactsView {
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
    NavigationStack {
        ContactsView()
            .environment(\.locale, .init(identifier: "ru"))
            .environment(Router())
    }
    .modelContainer(AppModel.makePreviewContainer())
}
