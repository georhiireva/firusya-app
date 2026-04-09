//
//  ChatsRepository.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import Foundation
import SwiftData

enum ChatLookupResult {
    case existing(Chat)
    case created(Chat)

    var chat: Chat {
        switch self {
        case .existing(let chat), .created(let chat):
            return chat
        }
    }
}

@MainActor
struct ChatsRepository {
    let modelContext: ModelContext

    func openOrCreateChat(for contact: Contact) throws -> ChatLookupResult {
        if let chat = try existingChat(for: contact) {
            return .existing(chat)
        }

        let chat = Chat(contact: contact)
        modelContext.insert(chat)
        try modelContext.save()

        return .created(chat)
    }

    @discardableResult
    func sendMessage(
        text: String,
        in chat: Chat,
        direction: MessageDirection = .outgoing,
        deliveryState: MessageDeliveryState = .sending
    ) throws -> Message {
        let message = Message(
            chat: chat,
            text: text,
            direction: direction,
            deliveryState: deliveryState
        )

        modelContext.insert(message)
        try modelContext.save()

        return message
    }
}

private extension ChatsRepository {
    func existingChat(for contact: Contact) throws -> Chat? {
        let contactID = contact.id
        var descriptor = FetchDescriptor<Chat>(
            predicate: #Predicate<Chat> { chat in
                chat.contact.id == contactID
            }
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
    }
}
