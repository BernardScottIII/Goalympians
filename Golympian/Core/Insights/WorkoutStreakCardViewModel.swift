//
//  WorkoutStreakCardViewModel.swift
//  Golympian
//
//  Created by Bernard Scott on 6/30/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class WorkoutStreakCardViewModel: ObservableObject {
    @Published private(set) var userCurrentStreak: Int = -1
    @Published private(set) var userStreakThreshold: Int = -1
    @Published private(set) var userValidDays: [String:Bool] = [:]
    
    func getUserStreakData() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        if let currentStreak = user.streakData[DBUser.StreakDataKeys.currentStreak.rawValue] {
            self.userCurrentStreak = currentStreak
        }
        if let streakThreshold = user.streakData[DBUser.StreakDataKeys.streakThreshold.rawValue] {
            self.userStreakThreshold = streakThreshold
        }
        for key in DBUser.StreakValidDayKeys.allCases {
            if let downloadedVal = user.streakValidDays[key.rawValue] {
                self.userValidDays[key.rawValue] = downloadedVal
            }
        }
    }
}
