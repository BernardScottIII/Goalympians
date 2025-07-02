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
    @Published private(set) var workoutInsight: WorkoutInsight = WorkoutInsight(id: "INVALID UUID", date: .now)
    @Published var exerciseCountsWithNames: [(exerciseName: String, count: Int)] = []
    
    func getInsights() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let insights: [WorkoutInsight] = try await UserManager.shared.getCurrMonthUserWorkoutInsight(userId: authDataResult.uid)
        guard let firstInsight = insights.first else {
            return
        }
        try await labelExerciseCounts(firstInsight.exerciseOccurrenceCounts)
        self.workoutInsight = firstInsight
    }
    
    func refreshInsights() async throws {
        workoutInsight = WorkoutInsight(id: "INVALID UUID", date: .now)
        exerciseCountsWithNames = []
        try await getInsights()
    }
    
    func initUserNewInsight() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.initUserWorkoutInsights(userId: authDataResult.uid)
        }
    }
    
    func getExerciseName(exerciseId: String) async throws -> String {
        try await ExerciseManager.shared.getExercise(exerciseId: exerciseId).name
    }
    
    func labelExerciseCounts(_ exerciseCounts: [String:Int]) async throws {
        for (exerciseId, count) in exerciseCounts {
            let exerciseName = try await getExerciseName(exerciseId: exerciseId)
            
            if let index = exerciseCountsWithNames.firstIndex(where: {$0.exerciseName == exerciseName}) {
                let updatedTuple = (exerciseName: exerciseName, count: count)
                exerciseCountsWithNames[index] = updatedTuple
            } else {
                exerciseCountsWithNames.append((exerciseName: exerciseName, count: count))
            }
        }
        exerciseCountsWithNames.sort(by: {$0.count > $1.count})
    }
}
