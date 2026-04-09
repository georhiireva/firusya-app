//
//  ChatViewModel.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import SwiftUI

@Observable final class ChatViewModel {
    var draftText: String = ""

    var trimmedDraftText: String {
        draftText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canSend: Bool {
        trimmedDraftText.isEmpty == false
    }

    func sendMessage(in chat: Chat, using repository: ChatsRepository) throws {
        guard canSend else { return }

        try repository.sendMessage(
            text: trimmedDraftText,
            in: chat
        )
        draftText = ""
    }
}
