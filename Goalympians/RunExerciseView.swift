//
//  RunExerciseView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/9/25.
//

import SwiftUI

struct RunExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var workout: Workout
    var exercise: Exercise
    var runSets: [RunSet]
    
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            Button("", systemImage: "trash") {
                removeRunExercise(exercise: exercise)
            }
            Button("", systemImage: "plus") {
                modelContext.insert(RunSet(workout: workout, exercise: exercise, dist: 0.0, startTime: .distantPast, endTime: .distantFuture, elevationChange: 0.0))
            }
        }
        .buttonStyle(.plain)
        ForEach(runSets) {runSet in
            if runSet.exercise == exercise {
                RunSetView(runSet: runSet)
            }
        }
        .onDelete(perform: removeRunSet)
    }
    
    func addSet() {
        let newSet = RunSet(workout: workout, exercise: exercise, dist: 0.0, startTime: .distantPast, endTime: .distantFuture, elevationChange: 0.0)
        modelContext.insert(newSet)
    }
    
    func removeRunExercise(exercise: Exercise) {
        runSets.forEach { runSet in
            if runSet.exercise == exercise {
                modelContext.delete(runSet)
            }
        }
        workout.exercises.remove(at: workout.exercises.firstIndex(of: exercise)!)
    }
    
    func removeRunSet(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(runSets[index])
        }
    }
}

#Preview {
    @Previewable @State var runSets = [RunSet(workout: Workout(), exercise: Exercise(name: "Example", desc: "Sample desc", setType: SetType.resistanceSet), dist: 0.0, startTime: .distantPast, endTime: .distantFuture, elevationChange: 0.0)]
    RunExerciseView(workout: runSets.first!.workout, exercise: runSets.first!.exercise, runSets: runSets)
}
