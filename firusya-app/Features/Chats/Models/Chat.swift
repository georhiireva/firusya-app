//
//  Chat.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 15.03.2026.
//
import Foundation
import SwiftData

@Model
final class Chat: Identifiable, Hashable {
    @Attribute(.unique)
    var id: UUID
    var contact: Contact
    @Relationship(deleteRule: .cascade)
    var messages: [Message] = []

    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        contact: Contact,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.contact = contact
        self.createdAt = createdAt
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
}

extension Chat {
    var latestMessage: Message? {
        messages.max(by: { $0.createdAt < $1.createdAt })
    }
}
