//
//  Message.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 16.03.2026.
//
import Foundation
import SwiftData

@Model
final class Message {
    @Attribute(.unique)
    var id: UUID
    var chat: Chat
    var text: String
    var createdAt: Date
    var direction: MessageDirection
    var deliveryState: MessageDeliveryState

    init(
        chat: Chat,
        text: String,
        direction: MessageDirection,
        deliveryState: MessageDeliveryState,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.chat = chat
        self.text = text
        self.createdAt = createdAt
        self.direction = direction
        self.deliveryState = deliveryState
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
