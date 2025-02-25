//
//  WorkoutExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/24/25.
//

import SwiftUI

struct WorkoutExerciseView: View {
    
    @Bindable var workout: Workout
    @Bindable var exercise: Exercise
    @EnvironmentObject private var routerManager: NavigationRouter
    
    var body: some View {
        ForEach(workout.sets) { set in
            if set.exercise == exercise {
                switch (exercise.set_type) {
                case .resistance:
                    ResistanceExerciseSetView(exerciseSet: set)
                case .run:
                    Text("Running Exercise")
                case .swim:
                    Text("Swimming Exercise")
                }
            }
        }
        HStack {
            Spacer()
            Button("Add Set") {
                workout.sets.append(ExerciseSet(exercise: exercise, workout: workout))
            }
        }
    }
}

#Preview {
    WorkoutExerciseView(workout: Workout(), exercise: Exercise())
}
