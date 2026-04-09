//
//  PersistenceFlowTests.swift
//  firusya-appTests
//
//  Created by Codex on 10.04.2026.
//

import SwiftData
import Testing
@testable import firusya_app

@MainActor
struct PersistenceFlowTests {

    @Test
    func contactsRepositoryReturnsPersistedContacts() throws {
        let container = makeContainer()
        let repository = ContactsRepository(modelContext: container.mainContext)
        let viewModel = AddContactViewModel()

        viewModel.form.displayName = "  Alice  "
        viewModel.form.subtitle = "  teammate  "

        let contact = try viewModel.save(using: repository)

        #expect(contact.displayName == "Alice")
        #expect(contact.subtitle == "teammate")

        let contacts = try repository.fetchContacts()
        #expect(contacts.count == 1)
        #expect(contacts.first?.id == contact.id)
        #expect(try repository.fetchContact(id: contact.id)?.displayName == "Alice")
    }

    @Test
    func chatsRepositoryReturnsExistingChatBeforeCreatingAnother() throws {
        let container = makeContainer()
        let context = container.mainContext
        let repository = ChatsRepository(modelContext: context)
        let viewModel = AddChatViewModel()
        let contact = Contact(displayName: "Alice", subtitle: nil)
        let existingChat = Chat(contact: contact)

        context.insert(contact)
        context.insert(existingChat)
        try context.save()

        let resolvedChat = try viewModel.openChat(for: contact, using: repository)

        #expect(resolvedChat.id == existingChat.id)

        let chats = try repository.fetchChats()
        #expect(chats.count == 1)
        #expect(try repository.fetchChat(id: existingChat.id)?.id == existingChat.id)
    }

    @Test
    func messagesRepositorySendsAndFetchesMessages() throws {
        let container = makeContainer()
        let context = container.mainContext
        let repository = MessagesRepository(modelContext: context, pageSize: 2)
        let viewModel = ChatViewModel()
        let contact = Contact(displayName: "Alice", subtitle: nil)
        let chat = Chat(contact: contact)

        context.insert(contact)
        context.insert(chat)
        context.insert(
            Message(
                chat: chat,
                text: "First",
                direction: .incoming,
                deliveryState: .read,
                createdAt: Date(timeIntervalSince1970: 1)
            )
        )
        context.insert(
            Message(
                chat: chat,
                text: "Second",
                direction: .incoming,
                deliveryState: .read,
                createdAt: Date(timeIntervalSince1970: 2)
            )
        )
        context.insert(
            Message(
                chat: chat,
                text: "Third",
                direction: .incoming,
                deliveryState: .read,
                createdAt: Date(timeIntervalSince1970: 3)
            )
        )
        try context.save()

        try viewModel.loadInitialMessages(for: chat, using: repository)

        #expect(viewModel.messages.map(\.text) == ["Second", "Third"])
        #expect(viewModel.hasMoreHistory)

        let didLoadOlderMessages = try viewModel.loadOlderMessagesIfNeeded(
            for: chat,
            triggerMessageID: viewModel.messages.first!.id,
            using: repository
        )

        #expect(didLoadOlderMessages)
        #expect(viewModel.messages.map(\.text) == ["First", "Second", "Third"])
        #expect(viewModel.hasMoreHistory == false)

        viewModel.draftText = "  Hello there  "

        try viewModel.sendMessage(in: chat, using: repository)

        let latestMessages = try repository.fetchLatestMessages(in: chat)
        #expect(latestMessages.count == 2)
        #expect(latestMessages.last?.text == "Hello there")
        #expect(viewModel.draftText.isEmpty)
        #expect(viewModel.messages.last?.text == "Hello there")
    }
}

private extension PersistenceFlowTests {
    func makeContainer() -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: AppModel.schema,
            isStoredInMemoryOnly: true
        )

        return try! ModelContainer(for: AppModel.schema, configurations: [configuration])
    }
}
