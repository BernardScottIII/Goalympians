//
//  ExerciseListView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import SwiftUI
import SwiftData

struct ExerciseListView: View {
    
    @EnvironmentObject private var routerManager: NavigationRouter
    @Environment(\.modelContext) var modelContext
    @Query var exercises: [Exercise]
    @Bindable var workout: Workout
    
    var body: some View {
        List {
            ForEach(exercises) {exercise in
                HStack {
                    Text(exercise.name)
                    Spacer()
                    Button("", systemImage: "info.circle") {
                        routerManager.push(to: Route.exerciseDetailsView(exercise: exercise))
                    }
                    .buttonStyle(.plain)
                    Button("", systemImage: "plus") {
                        workout.exercises.append(exercise)
                        routerManager.pop()
                    }
                    .buttonStyle(.plain)
                }
            }
            .onDelete(perform: deleteExercises)
        }
        .navigationTitle("Exercises")
        .navigationDestination(for: Route.self) { $0 }
        .toolbar {
            Button("Create Exercise", systemImage: "plus", action: addCustomExercise)
        }
        .environmentObject(routerManager)
    }
    
    func addCustomExercise() {
        let customExercise = Exercise()
        modelContext.insert(customExercise)
        routerManager.push(to: Route.editExerciseView(workout: workout, exercise: customExercise))
//        let chest = Exercise(
//            name: "Bench Press",
//            desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
//            target_muscles: [muscles[0], muscles[1], muscles[2]]
//        )
//        let deadlift = Exercise(
//            name: "Deadlift",
//            desc: "Place barbell on ground, add desired weight to each side of barbell, pick up barbell and stand straight up, drop barbell. Repeat until fatigued.",
//            target_muscles: [muscles[3], muscles[4], muscles[5], muscles[6]]
//        )
//        let squat = Exercise(
//            name: "Squat",
//            desc: "Approach squat rack with barbell, load desired weight onto each side of barbell, go under barbell and meet barbell wtih shoulders, stand up to unrack barbell, back up and squat down until legs make right angle, stand up, move forward, set bar back down. Repeat until fatigued.",
//         target_muscles: [muscles[3], muscles[4], muscles[5], muscles[7], muscles[8], muscles[9]])
//        
//        modelContext.insert(chest)
//        modelContext.insert(deadlift)
//        modelContext.insert(squat)
    }
    
    func deleteExercises(_ indexSet: IndexSet) {
        for index in indexSet {
            let exercise = exercises[index]
            modelContext.delete(exercise)
            if workout.exercises.contains(exercise) {
                workout.exercises.remove(at: index)
            }
        }
    }
}

#Preview {
//    ExerciseListView(exercise: Exercise(name: "Example Exercise", desc: "This is an example of an exercise which would physically challenge the user.", target_muscles: []))
    ExerciseListView(workout: Workout(name: "Example Workout", desc: "This is a sample workout created for the purposes of testing persistent data"))
        .environmentObject(NavigationRouter())
}
