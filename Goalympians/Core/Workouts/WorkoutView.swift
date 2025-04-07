//
//  WorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    
    @Binding var path: [Workout]
    
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
            // Maybe implement a listener?
        }
        .toolbar {
//            Button("Add Workout", action: addWorkout)
            NavigationLink("Add Workout") {
//                EditWorkoutView()
                // When I click the button
                // Create workout
                // Navigate to an EditWorkoutView with that workout
                CreateWorkoutView()
            }
        }
    }
    
    func addWorkout() {
        var newWorkout = Workout()
        Task {
            newWorkout = Workout(name: "", date: Date.now, desc: "")
            try await WorkoutManager.shared.createNewWorkout(workout: DBWorkout(
                id: UUID().uuidString,
                userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
                name: "",
                description: "",
                date: Date.now
            ))
            path += [newWorkout]
        }
    }
    
    func deleteWorkout(_ indexSet: IndexSet) {
//        for index in indexSet {
//            modelContext.delete(workouts[index])
//        }
    }
}

#Preview {
    @Previewable @State var path: [Workout] = []
    NavigationStack {
        WorkoutView(path: $path)
    }
}
