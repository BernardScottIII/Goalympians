//
//  WorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct WorkoutView: View {
    
    @StateObject var viewModel: WorkoutViewModel
//    let workoutDataService: WorkoutManagerProtocol
    
//    init(workoutDataService: WorkoutManagerProtocol) {
//        _viewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
//        self.workoutDataService = workoutDataService
//    }
    
    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
//                NavigationLink(workout.name) {
//                    EditWorkoutView(
//                        workoutDataService: viewModel.workoutDataService,
//                        workout: Workout(name: workout.name, date: workout.date, desc: workout.description, intensity: 2, exercises: []),
//                        workoutId: workout.id,
//                        userId: workout.userId
//                    )
//                }
                NavigationLink(workout.name, value: workout)
            }
        }
        .navigationDestination(for: DBWorkout.self, destination: { workout in
            EditWorkoutView(
                workoutDataService: viewModel.workoutDataService,
                workout: Workout(name: workout.name, date: workout.date, desc: workout.description, intensity: 2, exercises: []),
                workoutId: workout.id,
                userId: workout.userId)
        })
        .navigationTitle("Workouts")
        .task {
            try? await viewModel.getAllWorkouts()
        }
        .toolbar {
//            Button("Add Workout", action: addWorkout)
            NavigationLink("Add Workout") {
//                EditWorkoutView()
                CreateWorkoutView(workoutDataService: viewModel.workoutDataService)
            }
        }
    }
}

#Preview {
    let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    let viewModel = WorkoutViewModel(workoutDataService: dataService)
    NavigationStack {
        WorkoutView(viewModel: viewModel)
    }
}
