//
//  ExerciseSetView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/7/25.
//

import SwiftUI
import SwiftData

struct ResistanceExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var workout: Workout
    var exercise: Exercise
    var resistanceSets: [ResistanceSet]
    
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            Button("", systemImage: "trash") {
                removeResistanceExercise(exercise: exercise)
            }
            Button("", systemImage: "plus") {
                modelContext.insert(ResistanceSet(workout: workout, exercise: exercise, weight: 0.0, repetitions: 0))
            }
        }
        .buttonStyle(.plain)
        ForEach(resistanceSets) {resistanceSet in
            if resistanceSet.exercise == exercise {
                ResistanceSetView(resistanceSet: resistanceSet)
            }
        }
        .onDelete(perform: removeResistanceSet)
    }
    
    func addSet() {
        let newSet = ResistanceSet(workout: workout, exercise: exercise, weight: 0.0, repetitions: 0)
        modelContext.insert(newSet)
    }
    
    func removeResistanceExercise(exercise: Exercise) {
        resistanceSets.forEach { resistanceSet in
            if resistanceSet.exercise == exercise {
                modelContext.delete(resistanceSet)
            }
        }
        workout.exercises.remove(at: workout.exercises.firstIndex(of: exercise)!)
    }
    
    func removeResistanceSet(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(resistanceSets[index])
        }
    }
}

#Preview {
    @Previewable @State var resistanceSets = [ResistanceSet(workout: Workout(), exercise: Exercise(name: "Example", desc: "Sample desc", setType: SetType.resistanceSet), weight: 0.0, repetitions: 0)]
    ResistanceExerciseView(workout: resistanceSets.first!.workout, exercise: resistanceSets.first!.exercise, resistanceSets: resistanceSets)
}
