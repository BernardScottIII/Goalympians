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
}
