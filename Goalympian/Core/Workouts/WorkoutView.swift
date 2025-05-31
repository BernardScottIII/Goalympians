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
    
    @StateObject private var viewModel: WorkoutViewModel
    
    let workoutDataService: WorkoutManagerProtocol
    
    init(
        workoutDataService: WorkoutManagerProtocol
    ) {
        self.workoutDataService = workoutDataService
        _viewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                NavigationLink(workout.name, value: workout)
            }
        }
        .navigationDestination(for: DBWorkout.self) { workout in
            EditWorkoutView(
                workout: viewModel.binding(for: workout.id)!,
                workoutDataService: viewModel.workoutDataService)
        }
        .navigationTitle("Workouts")
        .task {
            try? await viewModel.getAllWorkouts()
        }
        .toolbar {
            NavigationLink("Add Workout") {
                CreateWorkoutView(workoutDataService: viewModel.workoutDataService)
            }
        }
    }
}

#Preview {
    let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    let viewModel = WorkoutViewModel(workoutDataService: dataService)
    NavigationStack {
        WorkoutView(workoutDataService: dataService)
    }
}
