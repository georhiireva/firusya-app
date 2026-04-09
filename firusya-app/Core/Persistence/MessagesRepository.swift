//
//  MessagesRepository.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import Foundation
import SwiftData

@MainActor
struct MessagesRepository {
    let modelContext: ModelContext
    let pageSize: Int

    init(modelContext: ModelContext, pageSize: Int = 30) {
        self.modelContext = modelContext
        self.pageSize = pageSize
    }

    func fetchLatestMessages(in chat: Chat) throws -> [Message] {
        let chatID = chat.id

        var descriptor = FetchDescriptor<Message>(
            predicate: #Predicate<Message> { message in
                message.chat.id == chatID
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = pageSize

        return Array(try modelContext.fetch(descriptor).reversed())
    }

    func fetchOlderMessages(in chat: Chat, before date: Date) throws -> [Message] {
        let chatID = chat.id

        var descriptor = FetchDescriptor<Message>(
            predicate: #Predicate<Message> { message in
                message.chat.id == chatID && message.createdAt < date
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = pageSize

        return Array(try modelContext.fetch(descriptor).reversed())
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
        chat.lastMessageText = message.text
        chat.lastMessageAt = message.createdAt
        try modelContext.save()

        return message
    }
}
