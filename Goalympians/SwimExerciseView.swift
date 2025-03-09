//
//  SwimExerciseView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/9/25.
//

import SwiftUI

struct SwimExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var workout: Workout
    var exercise: Exercise
    var swimSets: [SwimSet]
    
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            Button("", systemImage: "trash") {
                removeSwimExercise(exercise: exercise)
            }
            Button("", systemImage: "plus") {
                modelContext.insert(SwimSet(workout: workout, exercise: exercise, laps: 0.0, dist: 0.0, startTime: .distantPast, endTime: .distantFuture))
            }
        }
        .buttonStyle(.plain)
        ForEach(swimSets) {swimSet in
            if swimSet.exercise == exercise {
                SwimSetView(swimSet: swimSet)
            }
        }
        .onDelete(perform: removeSwimSet)
    }
    
    func addSet() {
        let newSet = SwimSet(workout: workout, exercise: exercise, laps: 0.0, dist: 0.0, startTime: .distantPast, endTime: .distantFuture)
        modelContext.insert(newSet)
    }
    
    func removeSwimExercise(exercise: Exercise) {
        swimSets.forEach { swimSet in
            if swimSet.exercise == exercise {
                modelContext.delete(swimSet)
            }
        }
        workout.exercises.remove(at: workout.exercises.firstIndex(of: exercise)!)
    }
    
    func removeSwimSet(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(swimSets[index])
        }
    }
}

#Preview {
    @Previewable @State var swimSets = [SwimSet(workout: Workout(), exercise: Exercise(name: "Example", desc: "Sample desc", setType: SetType.resistanceSet), laps: 0.0, dist: 0.0, startTime: .distantPast, endTime: .distantFuture)]
    SwimExerciseView(workout: swimSets.first!.workout, exercise: swimSets.first!.exercise, swimSets: swimSets)
}
