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
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ExercisesViewModel
    @State private var sortOrder = SortDescriptor(\DevExercise.name)
    @State private var targetMuscle = "Any Muscle"
    @State private var searchText = ""
    
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
        ExerciseListView(sort: sortOrder, targetMuscle: targetMuscle, searchString: searchText, viewModel: viewModel, workoutId: workoutId)
            .navigationTitle("Exercises")
            .searchable(text: $searchText)
            .onAppear {
                viewModel.getExercises()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
//                    Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
//                        ForEach(ExercisesViewModel.FilterOption.allCases, id: \.self) { option in
//                            Button(option.rawValue) {
//                                Task {
//                                    try? await viewModel.filterSelectedOption(option: option)
//                                }
//                            }
//                        }
//                    }
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name")
                                .tag(SortDescriptor(\DevExercise.name))
                            Text("Body Part")
                                .tag(SortDescriptor(\DevExercise.bodyPart))
                            Text("Equipment")
                                .tag(SortDescriptor(\DevExercise.equipment))
                        }
                        .pickerStyle(.inline)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Target Muscle", systemImage: "figure.strengthtraining.traditional") {
                        Picker("Category", selection: $targetMuscle) {
                            Text("Any Muscle")
                                .tag("Any Muscle")
                            ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { category in
                                Text(category.rawValue)
                                    .tag(category.rawValue)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
//                        ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { option in
//                            Button(option.rawValue) {
//                                Task {
//                                    try? await viewModel.categorySelected(category: option)
//                                }
//                            }
//                        }
//                    }
//                }
            }
        Button("Add Exercises to Database") {
            viewModel.exercises.forEach { exercise in
                addExercise(exercise: exercise)
            }
            print("All saved successfully!")
        }
        NavigationLink("Create New Exercise") {
            CreateExerciseView()
        }
    }
    
    func addExercise(exercise: APIExercise) {
        let storedExercise = DevExercise(
            id: exercise.id,
            name: exercise.name,
            bodyPart: exercise.bodyPart,
            equipment: exercise.equipment,
            target: exercise.target,
            secondaryMuscles: exercise.secondaryMuscles,
            instructions: exercise.instructions,
            gifUrl: exercise.gifUrl
        )
        modelContext.insert(storedExercise)
    }
}

#Preview {
    NavigationStack {
        ExercisesView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), workoutId: "SampleId")
    }
}
