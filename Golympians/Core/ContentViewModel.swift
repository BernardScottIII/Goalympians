//
//  ContentViewModel.swift
//  Golympians
//
//  Created by Bernard Scott on 7/23/25.
//

import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var profileIncomplete: Bool = true
    
    func checkProfile() async throws {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        print(userId)
        let user = try await UserManager.shared.getUser(userId: userId)
        
        print(user.username ?? "NO USERNAME FOUND")
    }
}
