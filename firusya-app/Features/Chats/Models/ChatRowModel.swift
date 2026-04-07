//
//  ChatRowModel.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 13.03.2026.
//
import SwiftUI

struct ChatRowModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let lastMessage: String
    let timeText: String
    let unreadCount: Int
    
    init(title: String, lastMessage: String, timeText: String, unreadCount: Int) {
        self.id = UUID()
        self.title = title
        self.lastMessage = lastMessage
        self.timeText = timeText
        self.unreadCount = unreadCount
    }
}

extension ChatRowModel {
    static let mock: [ChatRowModel] = [
        .init(title: "Firusya", lastMessage: "Зайчик, ты как?", timeText: "12 апреля", unreadCount: 2),
        .init(title: "Firusya", lastMessage: "Зайчик, ты как?", timeText: "12 апреля", unreadCount: 2),
        .init(title: "Firusya", lastMessage: "Зайчик, ты как?", timeText: "12 апреля", unreadCount: 2),
        .init(title: "Firusya", lastMessage: "Зайчик, ты как?", timeText: "12 апреля", unreadCount: 2),
    ]
}
