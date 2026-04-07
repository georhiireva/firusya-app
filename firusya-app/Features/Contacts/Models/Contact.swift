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
    static let mock: [Contact] = [
        Contact(id: "id-1", displayName: "Oleg Johnson", subtitle: nil),
        Contact(id: "id-2", displayName: "Kulib Doppers", subtitle: "Занят"),
        Contact(id: "id-3", displayName: "Margo Vans", subtitle: "На связи"),
        
    ]
}
