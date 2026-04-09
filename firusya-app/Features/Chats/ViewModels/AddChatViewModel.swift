//
//  AddChatViewModel.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import SwiftUI

@Observable final class AddChatViewModel {
    func openChat(for contact: Contact, using repository: ChatsRepository) throws -> Chat {
        try repository.openOrCreateChat(for: contact).chat
    }
}
