//
//  WorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    
    @StateObject private var viewModel = WorkoutViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                NavigationLink(workout.name) {
                    EditWorkoutView(
                        workout: Workout(name: workout.name, date: workout.date, desc: workout.description, intensity: 2, exercises: []),
                        workoutId: workout.id,
                        userId: workout.userId
                    )
                }
            }
        }
        .navigationTitle("Workouts")
        .task {
            try? await viewModel.getAllWorkouts()
        }
        .toolbar {
//            Button("Add Workout", action: addWorkout)
            NavigationLink("Add Workout") {
//                EditWorkoutView()
                CreateWorkoutView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutView()
    }
}
