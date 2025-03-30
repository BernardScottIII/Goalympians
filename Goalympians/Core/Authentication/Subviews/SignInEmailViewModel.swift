//
//  SignInEmailViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/30/25.
//

import Foundation

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email/password found")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email/password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
