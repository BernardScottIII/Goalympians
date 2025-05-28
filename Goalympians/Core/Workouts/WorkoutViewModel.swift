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
    @State var workoutNavigationPath: [NavigationPath] = []
    let workoutDataService: WorkoutManagerProtocol
    
    init(workoutDataService: WorkoutManagerProtocol) {
        self.workoutDataService = workoutDataService
    }
    
    func getAllWorkouts() async throws {
        self.workouts = try await workoutDataService.getAllWorkouts()
    }
    
    
}
