//
//  ContentView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Query(sort: [SortDescriptor(\Workout.date, order: .reverse), SortDescriptor(\Workout.name)]) var workouts: [Workout]
    @Environment(\.modelContext) var modelContext
    @StateObject private var routerManager = NavigationRouter()
    
    @Query var exercises: [Exercise]
    
    var body: some View {
        NavigationStack(path: $routerManager.routes) {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(value: Route.editWorkoutView(workout: workout)) {
                        Text(workout.name)
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .navigationDestination(for: Route.self) { $0 }
            .toolbar {
                Button("Add Workout", action: addWorkout)
//                Button("Add Exercises", action: addExercises)
            }
        }
        .environmentObject(routerManager)
    }
    
    func deleteWorkouts(_ indexSet: IndexSet) {
        for index in indexSet {
            let workout = workouts[index]
            modelContext.delete(workout)
        }
    }
    
    func addWorkout() {
        let workout = Workout()
        modelContext.insert(workout)
        routerManager.push(to: Route.editWorkoutView(workout: workout))
    }
    
    func addExercises() {
        let exercises: [Exercise] = [
            Exercise(
                name: "Bench Press",
                desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
                target_muscles: [muscles[0], muscles[1], muscles[2]],
                set_type: ExerciseSetType.resistance
            ),
            Exercise(
                name: "Deadlift",
                desc: "Place barbell on ground, add desired weight to each side of barbell, pick up barbell and stand straight up, drop barbell. Repeat until fatigued.",
                target_muscles: [muscles[3], muscles[4], muscles[5], muscles[6]],
                set_type: ExerciseSetType.resistance
            ),
            Exercise(
                name: "Squat",
                desc: "Approach squat rack with barbell, load desired weight onto each side of barbell, go under barbell and meet barbell wtih shoulders, stand up to unrack barbell, back up and squat down until legs make right angle, stand up, move forward, set bar back down. Repeat until fatigued.",
             target_muscles: [muscles[3], muscles[4], muscles[5], muscles[7], muscles[8], muscles[9]],
                set_type: ExerciseSetType.resistance)
        ]
        for exercise in exercises {
            print(exercise)
            modelContext.insert(exercise)
        }
    }
}

#Preview {
    ContentView()
}
