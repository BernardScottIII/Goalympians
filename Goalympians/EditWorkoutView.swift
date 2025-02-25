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
            
            ForEach(workout.exercises) {exercise in
                Section(exercise.set_type.rawValue) {
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Button("", systemImage: "info.circle") {
                            routerManager.push(to: Route.exerciseDetailsView(exercise: exercise))
                        }
                        .buttonStyle(.plain)
                        Button("", systemImage: "trash") {
                            removeExercise(exercise: exercise)
                            workout.sets.forEach { set in
                                if set.exercise == exercise {
                                    workout.sets.remove(at: workout.sets.lastIndex(of: set)!)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    WorkoutExerciseView(workout: workout, exercise: exercise)
                }
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
    
    func removeExercise(exercise: Exercise) {
        workout.exercises.remove(at: workout.exercises.lastIndex(of: exercise)!)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, configurations: config)
        let example = Workout(name: "Example Workout", desc: "This is a sample workout created for the purposes of testing persistent data")
        return EditWorkoutView(workout: example)
            .modelContainer(container)
            .environmentObject(NavigationRouter())
    } catch {
        fatalError("Failed to create model")
    }
}
