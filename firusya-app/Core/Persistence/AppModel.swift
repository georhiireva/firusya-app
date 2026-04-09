//
//  AppModel.swift
//  firusya-app
//
//  Created by Codex on 09.04.2026.
//

import Foundation
import SwiftData

enum AppModel {
    static let schema = Schema([
        Message.self,
        Contact.self,
        Chat.self,
    ])

    static func makeSharedContainer() -> ModelContainer {
        makeContainer(isStoredInMemoryOnly: false)
    }

    static func makePreviewContainer() -> ModelContainer {
        let container = makeContainer(isStoredInMemoryOnly: true)
        do {
            try seedPreviewData(in: container.mainContext)
        } catch {
            fatalError("Could not seed preview ModelContainer: \(error)")
        }
        return container
    }

    static func seedIfNeeded(in context: ModelContext) throws {
        var descriptor = FetchDescriptor<Contact>()
        descriptor.fetchLimit = 1

        guard try context.fetch(descriptor).isEmpty else { return }

        for seed in Contact.seedData {
            context.insert(
                Contact(
                    id: seed.id,
                    displayName: seed.displayName,
                    subtitle: seed.subtitle
                )
            )
        }

        try context.save()
    }
}

private extension AppModel {
    static func makeContainer(isStoredInMemoryOnly: Bool) -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    static func seedPreviewData(in context: ModelContext) throws {
        try seedIfNeeded(in: context)

        let contacts = try context.fetch(FetchDescriptor<Contact>(sortBy: [SortDescriptor(\.displayName)]))
        guard let primaryContact = contacts.first else { return }

        let chat = Chat(
            id: "preview-chat",
            contact: primaryContact,
            peerId: primaryContact.id,
            title: primaryContact.displayName,
            lastMessageText: "Preview message",
            lastMessageAt: Date()
        )

        context.insert(chat)
        context.insert(
            Message(
                chatId: chat.id.uuidString,
                senderPeerId: primaryContact.id,
                recipientPeerId: "1",
                text: "Preview message",
                direction: .incoming,
                deliveryState: .read
            )
        )

        try context.save()
    }
}
