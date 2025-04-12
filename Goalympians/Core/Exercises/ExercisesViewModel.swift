//
//  ExercisesViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ExercisesViewModel: ObservableObject {
    
    @Published private(set) var exercises: [DBExercise] = []
    
    func getAllExercises() async throws {
        self.exercises = try await ExerciseManager.shared.getAllExercises()
    }
    
    func addWorkoutActivity(workoutId: String, exerciseId: Int) {
        Task {
            try await WorkoutManager.shared.addWorkoutActivity(workoutId: workoutId, exerciseId: exerciseId)
        }
    }
}
