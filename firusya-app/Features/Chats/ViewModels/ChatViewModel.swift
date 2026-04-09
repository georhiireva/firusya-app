//
//  ChatViewModel.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import SwiftUI

enum ChatMessageListUpdate: Equatable {
    case none
    case initialLoad(bottomMessageID: UUID)
    case appendedMessage(bottomMessageID: UUID)
    case prependedHistory(anchorMessageID: UUID)
}

@Observable final class ChatViewModel {
    var draftText: String = ""
    var messages: [Message] = []
    var hasMoreHistory: Bool = true
    var isLoadingHistory: Bool = false
    var pendingListUpdate: ChatMessageListUpdate = .none

    var trimmedDraftText: String {
        draftText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canSend: Bool {
        trimmedDraftText.isEmpty == false
    }

    func loadInitialMessages(for chat: Chat, using repository: MessagesRepository) throws {
        let latestMessages = try repository.fetchLatestMessages(in: chat)
        messages = latestMessages
        hasMoreHistory = latestMessages.count == repository.pageSize

        if let bottomMessageID = latestMessages.last?.id {
            pendingListUpdate = .initialLoad(bottomMessageID: bottomMessageID)
        } else {
            pendingListUpdate = .none
        }
    }

    @discardableResult
    func loadOlderMessagesIfNeeded(
        for chat: Chat,
        triggerMessageID: UUID,
        using repository: MessagesRepository
    ) throws -> Bool {
        guard hasMoreHistory, isLoadingHistory == false else { return false }
        guard triggerMessageID == messages.first?.id else { return false }
        guard let oldestLoadedMessage = messages.first else {
            hasMoreHistory = false
            return false
        }

        isLoadingHistory = true
        defer { isLoadingHistory = false }

        let olderMessages = try repository.fetchOlderMessages(
            in: chat,
            before: oldestLoadedMessage.createdAt
        )

        guard olderMessages.isEmpty == false else {
            hasMoreHistory = false
            return false
        }

        messages.insert(contentsOf: olderMessages, at: 0)
        hasMoreHistory = olderMessages.count == repository.pageSize
        pendingListUpdate = .prependedHistory(anchorMessageID: oldestLoadedMessage.id)

        return true
    }

    func sendMessage(in chat: Chat, using repository: MessagesRepository) throws {
        guard canSend else { return }

        let message = try repository.sendMessage(
            text: trimmedDraftText,
            in: chat
        )
        messages.append(message)
        pendingListUpdate = .appendedMessage(bottomMessageID: message.id)
        draftText = ""
    }

    func consumePendingListUpdate() -> ChatMessageListUpdate {
        let update = pendingListUpdate
        pendingListUpdate = .none
        return update
    }
}
