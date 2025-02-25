//
//  GoalympiansApp.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import SwiftUI
import SwiftData

@main
struct GoalympiansApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, Exercise.self, Muscle.self, ExerciseSet.self])
    }
}
