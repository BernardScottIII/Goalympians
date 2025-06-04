//
//  ActivityViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import Foundation

@MainActor
final class ActivityViewModel: ObservableObject {
    @Published private(set) var activities: [(workoutActivity: DBActivity, exercise: APIExercise)] = []
    @Published var updatedActivityId: String = ""
    
    let dataService: WorkoutManagerProtocol
    
    init(dataService: WorkoutManagerProtocol) {
        self.dataService = dataService
    }
    
    func getActivities(workoutId: String) async throws  {
        let workoutActivities = try await dataService.getAllWorkoutActivities(workoutId: workoutId)
        
        var localArray: [(workoutActivity: DBActivity, exercise: APIExercise)] = []
        for workoutActivity in workoutActivities {
            if let exercise = try? await ExerciseManager.shared.getExercise(exerciseId: String(workoutActivity.exerciseId)) {
                localArray.append((workoutActivity, exercise))
            }
        }
        
        self.activities = localArray
    }
    
    func removeFromWorkout(workoutId: String, activityId: String) {
        Task {
            for activitySet in try await dataService.getAllActivitySets(workoutId: workoutId, activityId: activityId) {
                try await dataService.removeWorkoutActivitySet(workoutId: workoutId, activityId: activityId, activitySetId: activitySet.id)
            }
            try await dataService.removeWorkoutActivity(workoutId: workoutId, activityId: activityId)
            try await getActivities(workoutId: workoutId)
        }
    }
    
    func addActivitySet(workoutId: String, activityId: String) {
        Task {
            try await dataService.addWorkoutActivitySet(workoutId: workoutId, activityId: activityId)
        }
    }
}
