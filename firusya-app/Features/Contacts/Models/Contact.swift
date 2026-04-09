//
//  Contact.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI
import SwiftData

@Model
final class Contact: Identifiable, Hashable {
    @Attribute(.unique)
    var id: String
    var displayName: String
    var subtitle: String?
    @Attribute(.externalStorage)
    var avatar: Data?
    
    init(id: String, displayName: String, subtitle: String?, avatar: Data? = nil) {
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
        ContactSeed(id: "contact-1", displayName: "Oleg Johnson", subtitle: nil),
        ContactSeed(id: "contact-2", displayName: "Kulib Doppers", subtitle: "Занят"),
        ContactSeed(id: "contact-3", displayName: "Margo Vans", subtitle: "На связи"),
    ]
}

struct ContactSeed: Sendable {
    let id: String
    let displayName: String
    let subtitle: String?
}
