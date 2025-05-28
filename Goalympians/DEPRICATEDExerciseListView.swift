//
//  ExerciseListView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData

struct DEPRICATEDExerciseListView: View {
    @Query var exercises: [Exercise]
    @Bindable var workout: Workout
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(Array(exercises.enumerated()), id: \.element.name) { index, exercise in
                Button(exercise.name) {
                    addExercise(index: index)
                }
            }
        }
        .navigationTitle("Exercises")
        .toolbar {
            NavigationLink {
                CreateExerciseView()
            } label: {
                Text("Create Exercise")
            }
        }
    }
    
    func addExercise(index: Int) {
        let exercise = exercises[index]
        switch exercise.setType {
        case .resistanceSet:
            modelContext.insert(ResistanceSet(workout: workout, exercise: exercise, weight: 0.0, repetitions: 0))
        case .runSet:
            modelContext.insert(RunSet(workout: workout, exercise: exercise, dist: 0.0, startTime: .distantPast, endTime: .distantFuture, elevationChange: 0.0))
        case .swimSet:
            modelContext.insert(SwimSet(workout: workout, exercise: exercise, laps: 0.0, dist: 0.0, startTime: .distantPast, endTime: .distantFuture))
        }
        workout.exercises.append(exercise)
        dismiss()
    }
}

#Preview {
    DEPRICATEDExerciseListView(workout: Workout())
}
