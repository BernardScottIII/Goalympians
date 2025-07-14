//
//  WorkoutViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

//import Foundation
import SwiftUI

@MainActor
final class WorkoutViewModel: ObservableObject {
    
    @Published private(set) var workouts: [DBWorkout] = []
    @Published private(set) var newWorkout: DBWorkout? = nil
    let workoutDataService: WorkoutManagerProtocol
    
    init(
        workoutDataService: WorkoutManagerProtocol
    ) {
        self.workoutDataService = workoutDataService
    }
    
    func getAllWorkouts() async throws {
        self.workouts = try await workoutDataService.getAllWorkouts()
    }
    
    func binding(for workoutId: String) -> Binding<DBWorkout>? {
        guard let index = workouts.firstIndex(where: {$0.id == workoutId }) else {
            return nil
        }
        
        return Binding(
            get: {self.workouts[index]},
            set: {self.workouts[index] = $0}
        )
    }
    
    func removeWorkout(workoutId: String) async throws {
        try await workoutDataService.removeWorkout(workoutId: workoutId)
    }
    
    func createWorkout(name: String, description: String, date: Date) async throws {
        self.newWorkout = try DBWorkout(
            id: UUID().uuidString,
            userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
            name: name,
            description: description,
            date: date
        )
        try await workoutDataService.createNewWorkout(workout: newWorkout!)
    }
    
    func clearNewWorkout() {
        newWorkout = nil
    }
}
