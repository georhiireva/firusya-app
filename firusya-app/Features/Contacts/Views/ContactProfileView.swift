//
//  ContactProfileView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI
import SwiftData

struct ContactProfileView: View {
    
    let contactId: String
    @Query private var contacts: [Contact]
    
    var body: some View {
        Group {
            if let contact = contacts.first(where: { $0.id == contactId }) {
                content(for: contact)
            } else {
                ContentUnavailableView("Contact not found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
    }
}

private extension ContactProfileView {
    func content(for contact: Contact) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 72))
            
            Text("Contact profile")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Contact id: \(contactId)")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Profile")
    }
}


#Preview {
    ContactProfileView(contactId: "contact-1")
        .environment(ContactsStore())
}
