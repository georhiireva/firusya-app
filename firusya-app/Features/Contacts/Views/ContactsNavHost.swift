//
//  LoginView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI

struct ContactsNavHost: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.contactsPath) {
            ContactsView()
                .navigationDestination(for: ContactsRoute.self) { route in
                    switch route {
                    case .contactProfile(contactId: let contactId):
                        ContactProfileView(contactId: contactId)
                    }
                }
        }
    }
}
