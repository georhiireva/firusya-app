//
//  ContactProfileViewModel.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import SwiftUI

@Observable final class ContactProfileViewModel {
    var contact: Contact?

    func loadContact(id: UUID, using repository: ContactsRepository) throws {
        contact = try repository.fetchContact(id: id)
    }
}
