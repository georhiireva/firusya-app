//
//  Router.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 06.03.2026.
//
import SwiftUI

@Observable final class Router {
    var selectedTab: AppTab = .chats

    var chatsPath = NavigationPath()
    var contactsPath = NavigationPath()
    var callsPath = NavigationPath()
    var settingsPath = NavigationPath()

    var presentedSheet: AppSheet?

    func reset() {
        selectedTab = .chats
        chatsPath = NavigationPath()
        contactsPath = NavigationPath()
        callsPath = NavigationPath()
        settingsPath = NavigationPath()
        presentedSheet = nil
    }
}

extension Router {
    func openChat(_ chat: Chat) {
        selectedTab = .chats
        chatsPath.append(ChatsRoute.chat(id: chat.id))
    }
    
    func openChatInfo(_ chat: Chat) {
        chatsPath.append(ChatsRoute.chatInfo(id: chat.id))
    }
    
    func openContact(_ contactId: UUID) {
        selectedTab = .contacts
        contactsPath.append(ContactsRoute.contactProfile(contactId: contactId))
    }
    
    func openProfile() {
        selectedTab = .settings
        settingsPath.append(SettingsRoute.profile)
    }
}

extension Router {
    func presentNewChat() {
        presentedSheet = .newChat
    }

    func presentAddContact() {
        presentedSheet = .addContact
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}

enum AppTab: Hashable {
    case chats
    case contacts
    case calls
    case settings
}

enum ChatsRoute: Hashable {
    case chat(id: UUID)
    case chatInfo(id: UUID)
}

enum ContactsRoute: Hashable {
    case contactProfile(contactId: UUID)
}

enum CallsRoute: Hashable {
    case callDetails(callId: String)
}

enum SettingsRoute: Hashable {
    case profile
    case devises
    case security
}

enum AppSheet: Identifiable, Hashable {
    case newChat
    case addContact
    
    var id: String {
        switch self {
        case .newChat:
            return "newChat"
            
        case .addContact:
            return "addContact"
        }
    }
}
