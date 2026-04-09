//
//  AddContactViewModel.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI

enum AddContactError: Error {
    case emptyDisplayName
}

@Observable final class AddContactViewModel {
    var form = NewContactForm()
    
    var normalizedDisplayName: String {
        form.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var normalizedSubtitle: String {
        form.subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var optionalNormalizedSubtitle: String? {
        let subtitle = normalizedSubtitle
        return subtitle.isEmpty ? nil : subtitle
    }
    
    var canSave: Bool {
        normalizedDisplayName.isEmpty == false
    }

    func save(using repository: ContactsRepository) throws -> Contact {
        guard canSave else {
            throw AddContactError.emptyDisplayName
        }

        return try repository.createContact(
            displayName: normalizedDisplayName,
            subtitle: optionalNormalizedSubtitle
        )
    }
}
