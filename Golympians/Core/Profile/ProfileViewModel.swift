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
    @Published private(set) var isFollowing: Bool? = nil
    
    func loadMyProfile() async throws {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let username = try await UserManager.shared.getUser(userId: userId).username
        self.myProfile = try await loadProfile(username: username)
    }
    
    func loadProfile(username: String) async throws -> Profile {
        try await ProfileManager.shared.getProfile(username: username)
    }
    
    func addFollower(_ followRecipient: Profile, followedBy followInitiater: Profile?) {
        Task {
            if let followInitiater = followInitiater {
                try await ProfileManager.shared.addFollower(followRecipient, followedBy: followInitiater)
                self.isFollowing = true
            }
        }
    }
    
    func removeFollower(_ followRecipient: Profile, notFollowedBy followInitiater: Profile?) {
        Task {
            if let followInitiater = followInitiater {
                try await ProfileManager.shared.removeFollower(followRecipient, notFollowedBy: followInitiater)
                self.isFollowing = false
            }
        }
    }
    
    func checkIsFollowing(for profile: Profile) {
        if let myUsername = myProfile?.username {
            self.isFollowing = profile.followers.contains(myUsername)
        } else {
            self.isFollowing = nil
        }
    }
    
    func getFollowerCount(for username: String) async throws -> Int {
        try await ProfileManager.shared.getProfile(username: username).followers.count
    }
    
    func getFollowingCount(for username: String) async throws -> Int {
        try await ProfileManager.shared.getProfile(username: username).following.count
    }
}
