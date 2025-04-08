//
//  WorkoutView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ActivityViewModel()
    
    @Bindable var workout: Workout
    var workoutId: String
    var userId: String
    
    var body: some View {
        VStack{
            Form {
                TextField("name", text: $workout.name)
                TextField("desc", text: $workout.desc, axis: .vertical)
                DatePicker("date", selection: $workout.date)

                Section("Exercises") {
                    ActivityView(workoutId: workoutId)
                }
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            NavigationLink("Add Exercise") {
                ExercisesView(workoutId: workoutId)
            }
        }
        
        Button("Save Changes") {
            Task {
                try await WorkoutManager.shared.updateWorkout(workout: DBWorkout(id: workoutId, userId: userId, name: workout.name, description: workout.desc, date: workout.date))
                /// I think this is fine because it's not forcing the main thread to wait, and instead will be called when
                /// the WorkoutManager is finished updating the workout
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditWorkoutView(workout: Workout(name: "Example Workout", date: Date.now, desc: "This is a sample workout", intensity: 2, exercises: []), workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D", userId: "yf3B3l48yKbzgRWVbzKH3JyMKLz2")
    }
}
