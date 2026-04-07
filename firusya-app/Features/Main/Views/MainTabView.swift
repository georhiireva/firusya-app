//
//  MainTabView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI

struct MainTabView : View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            ChatNavHost()
                .tabItem {
                    Label {
                        Text("main.chats.tab")
                    } icon: {
                        Image(systemName: "message")
                    }
                }
                .tag(AppTab.chats)
            
            CallsNavHost()
                .tabItem {
                    Label {
                        Text("main.calls.tab")
                    } icon: {
                        Image(systemName: "phone")
                    }
                }
                .tag(AppTab.calls)
            
            ContactsNavHost()
                .tabItem {
                    Label {
                        Text("main.contacts.tab")
                    } icon: {
                        Image(systemName: "person.2")
                    }
                }
                .tag(AppTab.contacts)
            
            SettingsNavHost()
                .tabItem {
                    Label {
                        Text("main.settings.tab")
                    } icon: {
                        Image(systemName: "gear")
                    }
                }
                .tag(AppTab.contacts)
        }
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .newChat:
                AddChatView()
            case .addContact:
                AddContactView()
            }
        }
    }
}

#Preview {
    let router = Router()
    let appState = AppState(
        session: .loggedIn(User(id: "1", name: "Alex")),
        router: router
    )
    
    MainTabView()
        .environment(appState)
        .environment(router)
        .environment(\.locale, .init(identifier: "ru"))
}
