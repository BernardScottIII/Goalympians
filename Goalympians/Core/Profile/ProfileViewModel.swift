//
//  ProfileViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/31/25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func toggleDarkMode() {
        guard let user else { return }
        let currentValue = user.usingDarkMode ?? false
        Task {
            try await UserManager.shared.updateUserDarkMode(userId: user.userId, usingDarkMode: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
}
