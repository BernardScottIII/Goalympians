//
//  ExercisesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct ExercisesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ExercisesViewModel
    @State private var targetMuscle = "Any Muscle"
    @State private var searchText = ""
    @State private var selectedExerciseId: String?
    
    let workoutDataService: WorkoutManagerProtocol
    var workoutId: String
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        workoutId: String
    ) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataService: workoutDataService))
        self.workoutDataService = workoutDataService
        self.workoutId = workoutId
    }
    
    var body: some View {
        List(viewModel.exercises, id: \.id) { exercise in
            HStack {
                Text(exercise.name)
                
                Spacer()
                
                Button("", systemImage: "plus") {
                    viewModel.addWorkoutActivity(workoutId: workoutId, exerciseId: exercise.id!)
                    dismiss()
                }
                
                // "It's good enough"
                ZStack(alignment: .trailing) {
                    NavigationLink {
                        ExerciseDetailsView(exercise: exercise)
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.blue)
                    }
                    .scaledToFit()
                }
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Exercises")
        .searchable(text: $searchText)
        .onAppear {
            viewModel.getExercises()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")", systemImage: "arrow.up.arrow.down") {
                    ForEach(ExercisesViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.filterSelectedOption(option: option)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")", systemImage: "figure.strengthtraining.traditional") {
                    ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(category: option)
                            }
                        }
                    }
                }
            }
        }
        NavigationLink("Create New Exercise") {
            CreateExerciseView()
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), workoutId: "SampleId")
    }
}
