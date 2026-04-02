//
//  ChatViewModel.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 22.03.2026.
//
import SwiftUI
import SwiftData
import CoreData

@Observable final class ChatViewModel {
    var messages: [Message] = []
    private let pageSize = 10
    private(set) var currentPage: Int = 0
    private(set) var hasReachedEnd = false
    
    func addMessage(_ message: Message, using modelContext: ModelContext) {
        print("Добавление сообщения")
        modelContext.insert(message)
        do {
            try modelContext.save()
        } catch {
            print("Ошибка!!")
        }
    }
    
// Function to load messages
    func loadMessages(for chatId: String, using modelContext: ModelContext) throws {
        //guard !hasReachedEnd else { return }
        var sq = modelContext.sqliteCommand
        print(sq)
        
        var fetchRequest = FetchDescriptor<Message>(
//            predicate: #Predicate<Message> {
//                $0.chatId == chatId
//            },
            //sortBy: [SortDescriptor(\.createdAt, order: .reverse)],
        )
        
//        fetchRequest.fetchLimit = pageSize
//        fetchRequest.fetchOffset = currentPage * pageSize
//        print("linit = \(fetchRequest.fetchLimit), offset = \(fetchRequest.fetchOffset)")
        do {
            let fetchedMessages = try modelContext.fetch(fetchRequest)
            if fetchedMessages.isEmpty {
                print("Сообщения пустые")
                //hasReachedEnd = true
            } else {
                messages.append(contentsOf: fetchedMessages)
            }
            currentPage += 1
        } catch {
            currentPage -= 1 // Revert the page count on error
            throw error
        }
    }
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
