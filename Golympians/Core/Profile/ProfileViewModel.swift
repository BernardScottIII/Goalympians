//
//  ProfileViewModel.swift
//  Golympians
//
//  Created by Bernard Scott on 7/24/25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var myProfile: Profile? = nil
    
    func loadMyProfile() async throws {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let username = try await UserManager.shared.getUser(userId: userId).username
        self.myProfile = try await ProfileManager.shared.getProfile(username: username)
    }
    
    func addFollower(_ followRecipient: Profile, followedBy followInitiater: Profile?) {
        Task {
            if let followInitiater = followInitiater {
                try await ProfileManager.shared.addFollower(followRecipient, followedBy: followInitiater)
            }
        }
    }
    
    func removeFollower(_ followRecipient: Profile, notFollowedBy followInitiater: Profile?) {
        Task {
            if let followInitiater = followInitiater {
                try await ProfileManager.shared.removeFollower(followRecipient, notFollowedBy: followInitiater)
            }
        }
    }
}
