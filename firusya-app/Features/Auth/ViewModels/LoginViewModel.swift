//
//  LoginViewModel.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 06.03.2026.
//
import Foundation

@Observable final class LoginViewModel {
    var form = LoginForm()
    
    var normalizedDisplayName: String {
        form.displayName
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var canContinue: Bool {
        let name = normalizedDisplayName
        return name.isEmpty == false && name.count <= 30
    }
    
    func makeUser() -> User {
        User(id: UUID(), name: normalizedDisplayName)
    }
    
    var validationMessage: String? {
        let name = normalizedDisplayName
        
        if name.isEmpty {
            return nil
        }
        
        if name.count > 30 {
            return "Display name must be 30 characters or less"
        }
        
        return nil
    }
}
