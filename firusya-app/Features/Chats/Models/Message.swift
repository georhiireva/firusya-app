//
//  Message.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 16.03.2026.
//
import SwiftUI
import SwiftData

@Model
final class Message {
    @Attribute(.unique)
    var id: UUID
    
    var chatId: String
    var senderPeerId: String
    var recipientPeerId: String
    
    var text: String
    var createdAt: Date
    
    var direction: String
    var deliveryState: String
    
    var ackedAt: Date?
    
    init(chatId: String,
         senderPeerId: String,
         recipientPeerId: String,
         text: String,
         direction: MessageDirection,
         deliveryState: MessageDeliveryState) {
        self.id = UUID()
        self.chatId = chatId
        self.senderPeerId = senderPeerId
        self.recipientPeerId = recipientPeerId
        self.text = text
        self.createdAt = Date()
        self.direction = direction.rawValue
        self.deliveryState = deliveryState.rawValue
        self.ackedAt = nil
    }
}

enum MessageDeliveryState: String, Codable {
    case pending
    case sending
    case sent
    case delivered
    case read
    case failed
}

enum MessageDirection: String, Codable {
    case incoming
    case outgoing
}
