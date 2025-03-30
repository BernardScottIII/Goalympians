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
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            Tab("Workouts", systemImage: "dumbbell") {
                NavigationStack(path: $path) {
                    List {
                        ForEach(workouts) { workout in
                            NavigationLink(value: workout) {
                                Text(workout.name)
                            }
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                    .navigationTitle("Workouts")
                    .navigationDestination(for: Workout.self) { workout in
                        EditWorkoutView(workout: workout)
                    }
                    .toolbar {
                        Button("Add Workout", action: addWorkout)
                    }
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line") {
                NavigationStack {
                    Text("Insights Page")
                        .navigationTitle("Insights Page")
                }
            }
            
            Tab("Settings", systemImage: "gear") {
                if !showSignInView {
                    NavigationStack {
                        SettingsView(showSignInView: $showSignInView)
                            .navigationTitle("Settings")
                    }
                }
            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
                }
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
    ContentView(showSignInView: .constant(true))
}
