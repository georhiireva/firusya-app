//
//  ContacrsViewModel.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI

@Observable final class ContactsViewModel {
    var searchText: String = ""
    
    func onContactTapped(_ contact: Contact, using router: Router) {
        router.openContact(contact.id)
    }
    
    func onAddTapped(using router: Router) {
        router.presentAddContact()
    }
}
