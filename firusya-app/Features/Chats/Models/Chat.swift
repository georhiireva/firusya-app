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
    var lastMessageText: String?
    var lastMessageAt: Date?
    
    init(
        id: UUID = UUID(),
        contact: Contact,
        createdAt: Date = Date(),
        lastMessageText: String? = nil,
        lastMessageAt: Date? = nil
    ) {
        self.id = id
        self.contact = contact
        self.createdAt = createdAt
        self.lastMessageText = lastMessageText
        self.lastMessageAt = lastMessageAt
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
}
