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

    func fetchChats() throws -> [Chat] {
        try modelContext.fetch(
            FetchDescriptor<Chat>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
        )
    }

    func fetchChat(id: UUID) throws -> Chat? {
        var descriptor = FetchDescriptor<Chat>(
            predicate: #Predicate<Chat> { chat in
                chat.id == id
            }
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
    }

    func openOrCreateChat(for contact: Contact) throws -> ChatLookupResult {
        if let chat = try existingChat(for: contact) {
            return .existing(chat)
        }

        let chat = Chat(contact: contact)
        modelContext.insert(chat)
        try modelContext.save()

        return .created(chat)
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
