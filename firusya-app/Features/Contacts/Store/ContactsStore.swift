//
//  ContactsStore.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI

@Observable final class ContactsStore {
    private(set) var contacts: [Contact]
    
    init(contacts: [Contact] = Contact.mock) {
        self.contacts = contacts
    }
    
    func loadContacts() async {
        // todo repository
        
        contacts = Contact.mock
    }
    
    func addContact(displayName: String, subtitle:  String?) {
        let normalizedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedSubtitle = subtitle?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard normalizedName.isEmpty == false else { return }
        
        let contact = Contact(id: UUID().uuidString, displayName: normalizedName, subtitle: normalizedSubtitle)
        
        contacts.append(contact)
    }
    
    func contact(by id: String) -> Contact? {
        contacts.first{ $0.id == id }
    }
}
