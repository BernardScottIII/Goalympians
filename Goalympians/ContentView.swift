//
//  ContentView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var workouts: [Workout]
    @Environment(\.modelContext) private var modelContext
    @State private var path: [Workout] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                    }
                }
                .onDelete(perform: deleteWorkout)
            }
            .navigationTitle("Goalympians")
            .navigationDestination(for: Workout.self) { workout in
                EditWorkoutView(workout: workout)
            }
            .toolbar {
                Button("Add Workout", action: addWorkout)
            }
        }
    }
    
    func addWorkout() {
        let newWorkout = Workout()
        modelContext.insert(newWorkout)
        path = [newWorkout]
    }
    
    func deleteWorkout(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(workouts[index])
        }
    }
}

#Preview {
    ContentView()
}
