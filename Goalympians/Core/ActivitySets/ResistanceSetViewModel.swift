//
//  ResistanceSetViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/12/25.
//
import Foundation

@MainActor
final class ResistanceSetViewModel: ObservableObject {
    private let workoutDataService: WorkoutManagerProtocol
    
    init(workoutDataService: WorkoutManagerProtocol) {
        self.workoutDataService = workoutDataService
    }
    
    func updateActivitySet(workoutId: String, activity: DBActivity, set: DBResistanceSet) async throws {
        let weight = set.weight >= 0 ? set.weight : 0
        let repetitions = set.repetitions >= 0 ? set.repetitions : 0
        let updatedSet = DBResistanceSet(id: set.id, weight: weight, repetitions: repetitions)
        try await workoutDataService.updateActivitySet(workoutId: workoutId, activity: activity, set: updatedSet)
    }
    
    func getSetMetrics(workoutId: String, activity: DBActivity, setId: String) async throws -> DBResistanceSet {
        let snapshot = try await workoutDataService.getActivitySet(workoutId: workoutId, activity: activity, setId: setId) as! DBResistanceSet
        return DBResistanceSet(id: setId, weight: snapshot.weight, repetitions: snapshot.repetitions)
    }
    
    func removeActivitySet(workoutId: String, activityId: String, setId: String) async throws {
        Task {
            try await workoutDataService.removeWorkoutActivitySet(workoutId: workoutId, activityId: activityId, activitySetId: setId)
        }
    }
}
