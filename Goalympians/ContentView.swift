//
//  ContentView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Query(sort: [SortDescriptor(\Workout.intensity, order: .reverse), SortDescriptor(\Workout.name)]) var workouts: [Workout]
    @Environment(\.modelContext) var modelContext
    @StateObject private var routerManager = NavigationRouter()
    
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
                Button("Add Workout", systemImage: "plus", action: addWorkout)
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
}

#Preview {
    ContentView()
}
