//
//  WorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutView: View {
    
    @StateObject private var viewModel: WorkoutViewModel
    @State private var removalCandidateWorkout: DBWorkout?
    @State private var removeWorkoutAlert: Bool = false
    @State private var editMode = EditMode.inactive
    
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
            .onDelete { indexSet in
                removeWorkoutAlert = true
                for index in indexSet {
                    removalCandidateWorkout = viewModel.workouts[index]
                }
            }
            .deleteDisabled(!self.editMode.isEditing)
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
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Add Workout") {
                    CreateWorkoutView(workoutDataService: viewModel.workoutDataService)
                }
            }
        }
        .alert(
            "Remove Workout",
            isPresented: $removeWorkoutAlert
        ) {
            Button("Remove Workout", role: .destructive, action: removeWorkout)
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Are you sure you want to remove this workout? Removing it will delete all sets and exercises recorded in this workout.")
        }
        .environment(\.editMode, $editMode)
    }
    
    private func removeWorkout() {
        guard let removalCandidateWorkout else {
            return
        }
        
        Task {
            try await viewModel.removeWorkout(workoutId: removalCandidateWorkout.id)
            try await viewModel.getAllWorkouts()
        }
    }
}

#Preview {
    let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        WorkoutView(workoutDataService: dataService)
    }
}
