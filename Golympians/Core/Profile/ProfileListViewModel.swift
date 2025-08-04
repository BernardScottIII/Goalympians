//
//  ProfileListViewModel.swift
//  Golympians
//
//  Created by Bernard Scott on 8/4/25.
//

import Foundation

@MainActor
final class ProfileListViewModel: ObservableObject {
    @Published private(set) var profiles: [Profile] = []
    
    func fetchProfiles(usernames: [String]) async throws {
        var downloadedProfiles:[Profile] = []
        for username in usernames {
            let profile = try await ProfileManager.shared.getProfile(username: username)
            downloadedProfiles.append(profile)
        }
        self.profiles = downloadedProfiles
    }
}
