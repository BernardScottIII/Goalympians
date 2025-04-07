//
//  WorkoutViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation

@MainActor
final class WorkoutViewModel: ObservableObject {
    
    @Published private(set) var workouts: [DBWorkout] = []
    
    func getAllWorkouts() async throws {
        self.workouts = try await WorkoutManager.shared.getAllWorkouts()
    }
    
    
}
