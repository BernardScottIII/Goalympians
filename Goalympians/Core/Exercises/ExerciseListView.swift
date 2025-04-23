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
    @Environment(\.modelContext) private var modelContext
    @SwiftData.Query private var exercises: [DevExercise]
    
    var viewModel: ExercisesViewModel
    var workoutId: String
    
    var body: some View {
        List(exercises, id: \.id) { exercise in
            Text(exercise.name)
                .contextMenu {
                    Button("Add to Workout") {
                        viewModel.addWorkoutActivity(workoutId: workoutId, exerciseId: exercise.id!)
                        dismiss()
                    }
                }
        }
    }
    
    init(
        sort: SortDescriptor<DevExercise>,
        targetMuscle: String,
        searchString: String,
        viewModel: ExercisesViewModel,
        workoutId: String) {
            _exercises = Query(
                filter: #Predicate {
                    if searchString.isEmpty {
                        if targetMuscle == "Any Muscle" {
                            return true
                        } else {
                            return $0.target == targetMuscle
                        }
                    } else {
                        if targetMuscle == "Any Muscle" {
                            return $0.name.localizedStandardContains(searchString)
                        } else {
                            return $0.name.localizedStandardContains(searchString) && $0.target == targetMuscle
                        }
                    }
                },
                sort: [sort])
        self.viewModel = viewModel
        self.workoutId = workoutId
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(
            sort: SortDescriptor(\DevExercise.name),
            targetMuscle: "Any Muscle",
            searchString: "",
            viewModel: ExercisesViewModel(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))),
            workoutId: "")
            .modelContainer(for: DevExercise.self)
    }
}
