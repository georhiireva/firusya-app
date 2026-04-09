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
    func addContactViewModelPersistsTrimmedContact() throws {
        let container = makeContainer()
        let repository = ContactsRepository(modelContext: container.mainContext)
        let viewModel = AddContactViewModel()

        viewModel.form.displayName = "  Alice  "
        viewModel.form.subtitle = "  teammate  "

        let contact = try viewModel.save(using: repository)

        #expect(contact.displayName == "Alice")
        #expect(contact.subtitle == "teammate")

        let contacts = try container.mainContext.fetch(FetchDescriptor<Contact>())
        #expect(contacts.count == 1)
    }

    @Test
    func addChatViewModelReturnsExistingChatBeforeCreatingAnother() throws {
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

        let chats = try context.fetch(FetchDescriptor<Chat>())
        #expect(chats.count == 1)
    }

    @Test
    func chatViewModelSendsTrimmedMessageAndClearsDraft() throws {
        let container = makeContainer()
        let context = container.mainContext
        let repository = ChatsRepository(modelContext: context)
        let viewModel = ChatViewModel()
        let contact = Contact(displayName: "Alice", subtitle: nil)
        let chat = Chat(contact: contact)

        context.insert(contact)
        context.insert(chat)
        try context.save()

        viewModel.draftText = "  Hello there  "

        try viewModel.sendMessage(in: chat, using: repository)

        let messages = try context.fetch(FetchDescriptor<Message>())
        #expect(messages.count == 1)
        #expect(messages.first?.text == "Hello there")
        #expect(viewModel.draftText.isEmpty)
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
