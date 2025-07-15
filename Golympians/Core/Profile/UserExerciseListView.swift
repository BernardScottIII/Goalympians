//
//  DBExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/22/25.
//

import SwiftUI
import FirebaseFirestore

struct UserExerciseListView: View {
    @State private var removeExerciseAlert: Bool = false
    @State private var removalCandidateExercise: APIExercise?
    @State private var editMode = EditMode.inactive
    @State private var searchText = ""
    @StateObject private var workoutViewModel: WorkoutViewModel
    @StateObject private var activityViewModel: ActivityViewModel
    
    @StateObject var viewModel: ExercisesViewModel
    var workoutDataService: WorkoutManagerProtocol
    var userId: String
    
    init(
        viewModel: ExercisesViewModel,
        userId: String,
        workoutDataService: WorkoutManagerProtocol
    ) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataService: workoutDataService))
        _workoutViewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
        self.userId = userId
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        List {
            ForEach(viewModel.exercises.filter{
                searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
            }, id: \.id) { exercise in
                HStack {
                    Text(exercise.name)
                        .truncationMode(.tail)
                        .lineLimit(1)
                    
                    if !self.editMode.isEditing {
                        Spacer()
                        
                        ZStack(alignment: .trailing) {
                            NavigationLink {
                                ExerciseDetailsView(viewModel: viewModel, exercise: viewModel.binding(for: exercise)!)
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.blue)
                            }
                            .scaledToFit()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .onDelete { indexSet in
                removeExerciseAlert = true
                for index in indexSet {
                    removalCandidateExercise = viewModel.exercises[index]
                }
            }
            .deleteDisabled(!self.editMode.isEditing)
        }
        .searchable(text: $searchText)
        .task {
            try? await viewModel.userIdsSelected(userIds: [userId])
        }
        .alert(
            "Remove Custom Exercise",
            isPresented: $removeExerciseAlert
        ) {
            Button("Remove Exercise", role:.destructive, action: removeUserExercise)
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Are you sure you want to delete this exercise? Doing so will remove all sets from every workout of this exercise. This action may take a moment.")
        }
        .withExercisesToolbar(viewModel: viewModel)
        .toolbar {
            EditButton()
        }
        .environment(\.editMode, $editMode)
        
        NavigationLink("Create New Exercise") {
            CreateExerciseView(viewModel: viewModel)
        }
        .padding()
        .background(.purple)
        .clipShape(.buttonBorder)
        .foregroundStyle(.white)
        .fontWeight(.bold)
    }
    
    private func removeUserExercise() {
        guard let removalCandidateExercise else {
            return
        }
        
        Task {
            try await workoutViewModel.getAllWorkouts()
            for workout in workoutViewModel.workouts {
                activityViewModel.getAllActivities(workoutId: workout.id)
                for activity in activityViewModel.activities {
                    if activity.exercise.id! == removalCandidateExercise.id {
                        activityViewModel.removeFromWorkout(workoutId: workout.id, activityId: activity.activity.id)
                    }
                }
            }
            
            try await viewModel.removeUserExercise(exercise: removalCandidateExercise)
            try await viewModel.userIdsSelected(userIds: [userId])
        }
    }
}

#Preview {
    @Previewable let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        UserExerciseListView(viewModel: ExercisesViewModel(dataService: dataService), userId: UUID().uuidString, workoutDataService: dataService)
    }
}
