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
    
    var body: some View {
        List(contacts) { contact in
            contactRow(for: contact)
        }
    }
}

private extension AddChatView {
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
}
