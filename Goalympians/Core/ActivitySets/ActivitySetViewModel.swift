//
//  ActivitySetViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 5/27/25.
//
import Foundation

@MainActor
final class ActivitySetViewModel: ObservableObject {
    @Published private(set) var sets: [(activitySet: DBActivitySet, workoutActivity: DBActivity)] = []
    let workoutDataService: WorkoutManagerProtocol
    
    init(workoutDataService: WorkoutManagerProtocol) {
        self.workoutDataService = workoutDataService
    }
    
    func getActivitySets(workoutId: String, activityId: String) {
        Task {
            let activitySets = try await workoutDataService.getAllActivitySets(workoutId: workoutId, activityId: activityId)
            
            var localArray: [(activitySet: DBActivitySet, workoutActivity: DBActivity)] = []
            for set in activitySets {
                if let activity = try? await  workoutDataService.getWorkoutActivity(workoutId: workoutId, activityId: activityId) {
                    localArray.append((set, activity))
                }
            }
            
            self.sets = localArray
        }
    }
}
