//
//  LoginView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI

struct CallsNavHost: View {
    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.callsPath) {
            CallsView()
                .navigationTitle("Calls")
                .navigationDestination(for: CallsRoute.self) { route in
                    switch route {
                    case .callDetails(let callId):
                        Text(
                            String(
                                format: String(localized: "Call details %@"),
                                locale: Locale.current,
                                callId
                            )
                        )
                    }
                }
        }
    }
}
