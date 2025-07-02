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
    @Published var exerciseCountsWithName: [(exerciseName: String, count: Int)] = []
    private var exerciseCountsUniqueNames: Set<String> = []
    
    func getInsights() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let insights: [WorkoutInsight] = try await UserManager.shared.getCurrMonthUserWorkoutInsight(userId: authDataResult.uid)
        guard let firstInsight = insights.first else {
            return
        }
        try await labelExerciseCounts(firstInsight.exerciseOccurrenceCounts)
        self.workoutInsight = firstInsight
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
            
            if let index = exerciseCountsWithName.firstIndex(where: {$0.exerciseName == exerciseName}) {
                let updatedTuple = (exerciseName: exerciseName, count: count)
                exerciseCountsWithName[index] = updatedTuple
            } else {
                exerciseCountsWithName.append((exerciseName: exerciseName, count: count))
            }
        }
        exerciseCountsWithName.sort(by: {$0.count > $1.count})
    }
}
