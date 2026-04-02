//
//  AddContactViewModel.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI

@Observable final class AddContactViewModel {
    var form = NewContactForm()
    
    var normalizedDisplayName: String {
        form.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var normalizedSubtitle: String {
        form.subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var canSave: Bool {
        form.displayName.isEmpty == false
    }
}

