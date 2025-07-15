//
//  ActivityViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutActivity: Identifiable {
    var activity: DBActivity
    var exercise: APIExercise
    
    var id: String { activity.id }
}

@MainActor
final class ActivityViewModel: ObservableObject {
    @Published var activities: [WorkoutActivity] = []
    
    let dataService: WorkoutManagerProtocol
    
    init(dataService: WorkoutManagerProtocol) {
        self.dataService = dataService
    }
    
    func getAllActivities(workoutId: String) {
        Task {
            let workoutActivities = try await dataService.getAllWorkoutActivities(workoutId: workoutId)
            
            var localArray: [WorkoutActivity] = []
            for workoutActivity in workoutActivities {
                if let exercise = try? await ExerciseManager.shared.getExercise(exerciseId: String(workoutActivity.exerciseId)) {
                    localArray.append(WorkoutActivity(activity: workoutActivity, exercise: exercise))
                }
            }
            
            self.activities = localArray
        }
    }
    
    func binding(for activityId: String) -> Binding<DBActivity>? {
        guard let index = activities.firstIndex(where: {$0.activity.id == activityId }) else {
            return nil
        }
        
        return Binding(
            get: {self.activities[index].activity},
            set: {self.activities[index] = WorkoutActivity(activity: $0, exercise: self.activities[index].exercise)}
        )
    }
    
    func removeFromWorkout(workoutId: String, activityId: String) {
        Task {
            try await dataService.removeWorkoutActivity(workoutId: workoutId, activityId: activityId)
            getAllActivities(workoutId: workoutId)
        }
    }
    
    func updateActivity(workoutId: String, activity: DBActivity) {
        Task {
            try await dataService.updateWorkoutActivity(workoutId: workoutId, activity: activity)
        }
    }
    
    func moveActivity(workoutId: String, fromOffsets source: IndexSet, toOffset destination: Int) async throws {
        var modifiedActivities = activities
        modifiedActivities.move(fromOffsets: source, toOffset: destination)
        
        for (idx, entry) in modifiedActivities.enumerated() {
            let oldActivity = entry.activity
            let newActivity = DBActivity(id: oldActivity.id, exerciseId: oldActivity.exerciseId, setType: oldActivity.setType, workoutIndex: idx, activitySets: oldActivity.activitySets)
            modifiedActivities[idx] = WorkoutActivity(activity: newActivity, exercise: entry.exercise)
        }
        
        let batch = Firestore.firestore().batch()
        for entry in modifiedActivities {
            let id = entry.activity.id
            let doc = Firestore.firestore().collection("workouts").document(workoutId).collection("activities").document(id)
            batch.updateData([DBActivity.CodingKeys.workoutIndex.rawValue: entry.activity.workoutIndex], forDocument: doc)
        }
        
        do {
            
            try await batch.commit()
            getAllActivities(workoutId: workoutId)
        } catch {
            print("Error updating indices: \(error.localizedDescription)")
        }
    }
    
    func addEmptyActivitySet(workoutId: String, activity: DBActivity) {
        Task {
            try await dataService.addEmptyActivitySet(workoutId: workoutId, activity: activity)
        }
    }
    
    func addActivitySet(workoutId: String, activityId: String, set: [String:Any]) async throws {
        try await dataService.addActivitySet(workoutId: workoutId, activityId: activityId, set: set)
    }
    
    func removeActivitySet(workoutId: String, activityId: String, set: [String:Any]) {
        Task {
            try await dataService.removeActivitySet(workoutId: workoutId, activityId: activityId, set: set)
        }
    }
}
