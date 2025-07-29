//
//  ExploreViewModel.swift
//  Golympians
//
//  Created by Bernard Scott on 7/24/25.
//

import Foundation

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published private(set) var profiles: [Profile] = []
    
    func getProfiles() async throws {
        var retreivedProfiles = try await ProfileManager.shared.getAllProfiles()
        let myUserId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let myUsername = try await UserManager.shared.getUser(userId: myUserId).username
        if let myProfileIndex = retreivedProfiles.firstIndex(where: { $0.username == myUsername}) {
            retreivedProfiles.remove(at: myProfileIndex)
        }
        self.profiles = retreivedProfiles
    }
}
