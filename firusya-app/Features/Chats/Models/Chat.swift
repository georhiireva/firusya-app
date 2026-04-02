//
//  Chat.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 15.03.2026.
//
import SwiftUI
import SwiftData

@Model
final class Chat: Identifiable, Hashable {
    @Attribute(.unique)
    var id: UUID
    @Relationship
    var contact: Contact?
    
    var peerId: String
    var title: String
    var createdAt: Date
    var updatedAt: Date
    
    var lastMessageText: String?
    var lastMessageAt: Date?
    var unreadCount: Int
    
    init(
        id: String,
        contact: Contact?,
        peerId: String,
        title: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastMessageText: String? = nil,
        lastMessageAt: Date? = nil,
        unreadCount: Int = 0
    ) {
        self.id = UUID()
        self.contact = contact
        self.peerId = peerId
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastMessageText = lastMessageText
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
}
