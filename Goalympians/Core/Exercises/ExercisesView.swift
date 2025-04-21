//
//  ExercisesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI

struct ExercisesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ExercisesViewModel()
    
    var workoutId: String
    
    var body: some View {
        List {
            ForEach(viewModel.exercises) { exercise in
                Text(exercise.name)
                    .contextMenu {
                        Button("Add to Workout") {
                            viewModel.addWorkoutActivity(workoutId: workoutId, exerciseId: exercise.id!)
                            dismiss()
                        }
                    }
            }
        }
        .navigationTitle("Exercises")
        .task {
            try? await viewModel.getAllExercises()
        }
//        .onAppear {
//            viewModel.downloadProductsAndUploadToFirebase()
//        }
        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Menu("Filter: None") {
//                    
//                }
//            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Create New Exercise") {
                    CreateExerciseView()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesView(workoutId: "SampleId")
    }
}
