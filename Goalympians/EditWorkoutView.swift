//
//  EditWorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/13/25.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Bindable var workout: Workout
    @EnvironmentObject private var routerManager: NavigationRouter
    @Environment(\.modelContext) var modelContext
    // Insert @Query with filter that only selects sets with matching workout
    // Should I do matching exercise && workout in here, or evaluate matching
    // exercise in the ForEach loop?
    
    var body: some View {
        Form {
            TextField("Name", text: $workout.name)
            TextField("Description", text: $workout.desc, axis: .vertical)
            DatePicker("Date", selection: $workout.date)
            
            Section ("Intensity") {
                Picker("Intensity", selection: $workout.intensity) {
                    Text("Low").tag(1)
                    Text("Moderate").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            Text("Exercises")
            
            ForEach(workout.exercises) {exercise in
                Section(exercise.name) {
                    
                }
            }
            
            Section ("Exercises") {
                ForEach(workout.exercises) {exercise in
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Button("", systemImage: "info.circle") {
                            routerManager.push(to: Route.exerciseDetailsView(exercise: exercise))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onDelete(perform: removeExercises)
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Add Exercise", systemImage: "plus", action: addExercises)
        }
        .environmentObject(routerManager)
    }
    
    func addExercises() {
        routerManager.push(to: Route.exerciseListView(workout: workout))
    }
    
    func removeExercises(_ indexSet: IndexSet) {
        for index in indexSet {
            workout.exercises.remove(at: index)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, configurations: config)
        let example = Workout(name: "Example Workout", desc: "This is a sample workout created for the purposes of testing persistent data")
        return EditWorkoutView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model")
    }
}
