//
//  ChatsViewModel.swift
//  firusya-app
//
//  Created by Codex on 10.04.2026.
//

import SwiftUI

@Observable final class ChatsViewModel {
    func onChatTapped(_ chat: Chat, using router: Router) {
        router.openChat(chat)
    }

    func onComposeTapped(using router: Router) {
        router.presentNewChat()
    }
}
