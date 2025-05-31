//
//  RunSetViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 5/30/25.
//

import Foundation

@MainActor
final class RunSetViewModel: ObservableObject {
    private let workoutDataService: WorkoutManagerProtocol
    
    init(workoutDataService: WorkoutManagerProtocol) {
        self.workoutDataService = workoutDataService
    }
    
    func updateActivitySet(workoutId: String, activity: DBActivity, set: DBRunSet) async throws {
        try await workoutDataService.updateActivitySet(workoutId: workoutId, activity: activity, set: set)
    }
    
    func getSetMetrics(workoutId: String, activity: DBActivity, setId: String) async throws -> DBRunSet {
        let snapshot = try await workoutDataService.getActivitySet(workoutId: workoutId, activity: activity, setId: setId) as! DBRunSet
        return DBRunSet(
            id: setId,
            distance: snapshot.distance,
            elevation: snapshot.elevation,
            duration: snapshot.duration
        )
    }
    
    func removeActivitySet(workoutId: String, activityId: String, setId: String) async throws {
        Task {
            try await workoutDataService.removeWorkoutActivitySet(workoutId: workoutId, activityId: activityId, activitySetId: setId)
        }
    }
}
