//
//  WorkoutView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var resistanceSets: [ResistanceSet]
    @Query private var runSets: [RunSet]
    @Query private var swimSets: [SwimSet]
    
    @Bindable var workout: Workout
    
    var body: some View {
        Form {
            TextField("name", text: $workout.name)
            TextField("desc", text: $workout.desc, axis: .vertical)
            DatePicker("date", selection: $workout.date)
            
            ForEach(Array(workout.exercises.enumerated()), id: \.element) { index, exercise in
                Section {
                    switch exercise.setType {
                    case .resistanceSet:
                        ResistanceExerciseView(workout: workout, exercise: exercise, resistanceSets: resistanceSets)
                    case .runSet:
                        RunExerciseView(workout: workout, exercise: exercise, runSets: runSets)
                    case .swimSet:
                        SwimExerciseView(workout: workout, exercise: exercise, swimSets: swimSets)
                    }
                }
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink(destination: ExerciseListView(workout: workout)) {
                Text("Add Exercise")
            }
        }
    }
    
    init(workout: Workout) {
        self.workout = workout
        
        let localWorkoutID = workout.id
        _resistanceSets = Query(filter: #Predicate<ResistanceSet> {
            $0.workout.id == localWorkoutID
        })
        _runSets = Query(filter: #Predicate<RunSet> {
            $0.workout.id == localWorkoutID
        })
        _swimSets = Query(filter: #Predicate<SwimSet> {
            $0.workout.id == localWorkoutID
        })
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, configurations: config)
        let workout = Workout(name: "First session", date: .now, desc: "A description", intensity: 2)
        return EditWorkoutView(workout: workout)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
