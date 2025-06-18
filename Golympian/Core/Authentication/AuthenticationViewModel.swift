//
//  AuthenticationViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/31/25.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        // If google user already exists, don't create new user
        // User creation will re-run profile initialization code and cause
        // unexpected behavior.
        do {
            _ = try await UserManager.shared.getUser(userId: authDataResult.uid)
        } catch {
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.createNewUser(user: user)
        }
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}
