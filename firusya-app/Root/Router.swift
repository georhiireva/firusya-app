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
    var presentedFullScreen: AppFullScreen?
    
    func reset() {
        selectedTab = .chats
        chatsPath = NavigationPath()
        contactsPath = NavigationPath()
        callsPath = NavigationPath()
        settingsPath = NavigationPath()
        presentedSheet = nil as AppSheet?
        presentedFullScreen = nil as AppFullScreen?
    }
    
    func openChat(_ chatId: String) {
        selectedTab = .chats
        chatsPath.append(ChatsRoute.chat(chatId: chatId))
    }
    
    func openChatInfo(_ chatId: String) {
        chatsPath.append(ChatsRoute.chatInfo(chatId: chatId))
    }
    
    func openContact(_ contactId: String) {
        selectedTab = .contacts
        contactsPath.append(ContactsRoute.contactProfile(contactId: contactId))
    }
    
    func openProfile() {
        selectedTab = .settings
        settingsPath.append(SettingsRoute.profile)
    }
    
    func presentNewChat() {
        presentedSheet = .newChat
    }
    
    func presentAddContact() {
        presentedSheet = .addContact
    }
    
    func presentIncomingCall(peerId: String) {
        presentedFullScreen = .incomingCall(peerId: peerId)
    }
    
    func presentActiveCall(peerId: String) {
        presentedFullScreen = .activeCall(peerId: peerId)
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func dismissFullScreen() {
        presentedFullScreen = nil
    }
}

enum AppTab: Hashable {
    case chats
    case contacts
    case calls
    case settings
}

enum ChatsRoute: Hashable {
    case chat(chatId: String)
    case chatInfo(chatId: String)
}

enum ContactsRoute: Hashable {
    case contactProfile(contactId: String)
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

enum AppFullScreen: Identifiable, Hashable {
    case incomingCall(peerId: String)
    case activeCall(peerId: String)
    
    var id: String {
        switch self {
        case .incomingCall(let peerId):
            return "incomingCall-\(peerId)"
        case .activeCall(let peerId):
            return "activeCall-\(peerId)"
        }
    }
}
