//
//  Contact.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//
import Foundation
import SwiftData

@Model
final class Contact: Identifiable, Hashable {
    @Attribute(.unique)
    var id: UUID
    var displayName: String
    var subtitle: String?
    @Attribute(.externalStorage)
    var avatar: Data?
    @Relationship(deleteRule: .cascade)
    var chats: [Chat] = []
    
    init(id: UUID = UUID(), displayName: String, subtitle: String?, avatar: Data? = nil) {
        self.id = id
        self.displayName = displayName
        self.subtitle = subtitle
        self.avatar = avatar
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}

extension Contact {
    static let seedData: [ContactSeed] = [
        ContactSeed(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, displayName: "Oleg Johnson", subtitle: nil),
        ContactSeed(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, displayName: "Kulib Doppers", subtitle: "Занят"),
        ContactSeed(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, displayName: "Margo Vans", subtitle: "На связи"),
    ]
}

struct ContactSeed: Sendable {
    let id: UUID
    let displayName: String
    let subtitle: String?
}
