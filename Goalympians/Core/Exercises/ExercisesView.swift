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
//    @Query private var devExercises: [DevExercise]
    @StateObject private var viewModel: ExercisesViewModel
    
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
        List {
            ForEach(0..<100, id: \.self) { _ in
                Text("Exercise")
            }
//            ForEach(devExercises) { exercise in
////            ForEach(viewModel.exercises) { exercise in
//                Text(exercise.name)
//                    .contextMenu {
//                        Button("Add to Workout") {
//                            viewModel.addWorkoutActivity(workoutId: workoutId, exerciseId: exercise.id!)
//                            dismiss()
//                        }
//                    }
//            }
        }
        .navigationTitle("Exercises")
        .onAppear {
//            viewModel.downloadProductsAndUploadToFirebase()
            viewModel.getExercises()
        }
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
//                    ForEach(ExercisesViewModel.FilterOption.allCases, id: \.self) { option in
//                        Button(option.rawValue) {
//                            Task {
//                                try? await viewModel.filterSelectedOption(option: option)
//                            }
//                        }
//                    }
//                }
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
//                    ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { option in
//                        Button(option.rawValue) {
//                            Task {
//                                try? await viewModel.categorySelected(category: option)
//                            }
//                        }
//                    }
//                }
//            }
////            ToolbarItem(placement: .topBarTrailing) {
////                NavigationLink("Create New Exercise") {
////                    CreateExerciseView()
////                }
////            }
//        }
//        NavigationLink("Create New Exercise") {
//            CreateExerciseView()
//        }
        Button("Add Exercises to Database") {
            viewModel.exercises.forEach { exercise in
                addExercise(exercise: exercise)
            }
            print("All saved successfully!")
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
