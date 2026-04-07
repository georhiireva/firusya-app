//
//  LoginView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 04.03.2026.
//
import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            headerSection
            formSection
            continueButton
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden(true)
    }
}

private extension LoginView {
    var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "message.circle.fill")
                .font(.system(size: 64))
            
            Text("auth.welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("auth.enter.display_name")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
    
    var formSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("auth.display_name.title")
                .font(.headline)
            
            TextField("auth.your.name.placeholder", text: $viewModel.form.displayName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    var continueButton: some View {
        Button(action: onContinueTapped) {
            Text("Continue")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.canContinue == false)
    }
    
    func onContinueTapped() {
        let user = viewModel.makeUser()
        appState.login(as: user)
    }
}

#Preview {
    LoginView()
        .environment(AppState())
        .environment(\.locale, .init(identifier: "ru"))
}
