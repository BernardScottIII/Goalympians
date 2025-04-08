//
//  ActivityViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import Foundation

@MainActor
final class ActivityViewModel: ObservableObject {
    @Published private(set) var activities: [(workoutActivity: DBActivity, exercise: DBExercise)] = []
    
    func getActivities(workoutId: String) {
        Task {
            let workoutActivities = try await WorkoutManager.shared.getAllWorkoutActivities(workoutId: workoutId)
            
            var localArray: [(workoutActivity: DBActivity, exercise: DBExercise)] = []
            for workoutActivity in workoutActivities {
                if let exercise = try? await ExerciseManager.shared.getExercise(exerciseId: String(workoutActivity.exerciseId)) {
                    localArray.append((workoutActivity, exercise))
                }
            }
            
            self.activities = localArray
        }
    }
    
    func removeFromWorkout(workoutId: String, activityId: String) {
        Task {
            try? await WorkoutManager.shared.removeWorkoutActivity(workoutId: workoutId, activityId: activityId)
            getActivities(workoutId: workoutId)
        }
    }
    
    func addActivitySet(workoutId: String, activityId: String) {
        Task {
            try await WorkoutManager.shared.addWorkoutActivitySet(workoutId: workoutId, activityId: activityId)
        }
    }
}
