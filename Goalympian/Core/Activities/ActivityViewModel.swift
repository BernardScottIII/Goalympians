//
//  ActivityViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import Foundation
import FirebaseFirestore

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
    
    func updateActivity(workoutId: String, activity: DBActivity) async throws {
        try await dataService.updateWorkoutActivity(workoutId: workoutId, activity: activity)
    }
    
    func moveActivity(workoutId: String, fromOffsets source: IndexSet, toOffset destination: Int) async throws {
        var modifiedActivities = activities
        modifiedActivities.move(fromOffsets: source, toOffset: destination)
        
        for (idx, entry) in modifiedActivities.enumerated() {
            let oldActivity = entry.workoutActivity
            let newActivity = DBActivity(id: oldActivity.id, exerciseId: oldActivity.exerciseId, setType: oldActivity.setType, workoutIndex: idx)
            modifiedActivities[idx] = (workoutActivity: newActivity, exercise: entry.exercise)
        }
        
        let batch = Firestore.firestore().batch()
        for entry in modifiedActivities {
            let id = entry.workoutActivity.id
            let doc = Firestore.firestore().collection("workouts").document(workoutId).collection("activities").document(id)
            batch.updateData([DBActivity.CodingKeys.workoutIndex.rawValue: entry.workoutActivity.workoutIndex], forDocument: doc)
        }
        
        do {
            
            try await batch.commit()
            try await getActivities(workoutId: workoutId)
        } catch {
            print("Error updating indices: \(error.localizedDescription)")
        }
    }
}
