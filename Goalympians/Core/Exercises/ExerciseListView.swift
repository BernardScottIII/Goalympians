//
//  DBExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/22/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct ExerciseListView: View {
    @Environment(\.dismiss) private var dismiss
//    @Environment(\.modelContext) private var modelContext
//    @SwiftData.Query private var exercises: [DevExercise]
    
    var viewModel: ExercisesViewModel
    var workoutId: String
    
    var body: some View {
        List(viewModel.exercises, id: \.id) { exercise in
            Text(exercise.name)
                .contextMenu {
                    Button("Add to Workout") {
                        viewModel.addWorkoutActivity(workoutId: workoutId, exerciseId: exercise.id!)
                        dismiss()
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(
            viewModel: ExercisesViewModel(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))),
            workoutId: ""
        )
            .modelContainer(for: DevExercise.self)
    }
}
