//
//  InsightsViewModel.swift
//  Golympian
//
//  Created by Bernard Scott on 6/20/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class InsightsViewModel: ObservableObject {
    @Published private(set) var exercises: [APIExercise] = []
    @Published private(set) var workoutInsight: WorkoutInsight = WorkoutInsight(id: "INVALID UUID", date: .now)
    @Published private(set) var userCurrentStreak: Int = -1
    @Published private(set) var userStreakThreshold: Int = -1
    @Published private(set) var userValidDays: [String:Bool] = [:]
    
    func getInsights() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let insights: [WorkoutInsight] = try await UserManager.shared.getCurrMonthUserWorkoutInsight(userId: authDataResult.uid)
        guard let firstInsight = insights.first else {
            return
        }
        self.workoutInsight = firstInsight
    }
    
    func initUserNewInsight() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.initUserWorkoutInsights(userId: authDataResult.uid)
        }
    }
    
    func addUserInsight(insightName: String, insightData: [String:Any]) {
        Task {
            print("THIS FUNCTION IS DEPRECATED")
            throw CancellationError()
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            try? await UserManager.shared.addUserInsight(userId: authDataResult.uid, insightName: insightName, insightData: insightData)
        }
    }
    
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
