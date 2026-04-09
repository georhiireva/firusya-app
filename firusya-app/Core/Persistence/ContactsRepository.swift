//
//  ContactsRepository.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import SwiftData

@MainActor
struct ContactsRepository {
    let modelContext: ModelContext

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
