//
//  ContactsRepository.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import Foundation
import SwiftData

@MainActor
struct ContactsRepository {
    let modelContext: ModelContext

    func fetchContacts() throws -> [Contact] {
        try modelContext.fetch(
            FetchDescriptor<Contact>(
                sortBy: [SortDescriptor(\.displayName)]
            )
        )
    }

    func fetchContact(id: UUID) throws -> Contact? {
        var descriptor = FetchDescriptor<Contact>(
            predicate: #Predicate<Contact> { contact in
                contact.id == id
            }
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
    }

    @discardableResult
    func createContact(displayName: String, subtitle: String?) throws -> Contact {
        let contact = Contact(
            displayName: displayName,
            subtitle: subtitle
        )

        modelContext.insert(contact)
        try modelContext.save()

        return contact
    }
}
