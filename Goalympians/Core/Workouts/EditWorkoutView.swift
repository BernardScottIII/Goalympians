//
//  WorkoutView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import FirebaseFirestore

struct EditWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    // We're sharing this VM, when we don't really want to... we want our parent-level plus button to call
    // a function in that child view's unique vm and do something
//    @StateObject private var activitySetViewModel: ActivitySetViewModel
    private var workoutDataService: WorkoutManagerProtocol
    
    @Bindable var workout: Workout
    var workoutId: String
    var userId: String
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        workout: Workout,
        workoutId: String,
        userId: String
    ) {
        self.workoutId = workoutId
        self.workout = workout
        self.userId = userId
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        VStack{
            Form {
                TextField("name", text: $workout.name)
                TextField("desc", text: $workout.desc, axis: .vertical)
                DatePicker("date", selection: $workout.date)
                
                ActivityView(workoutDataService: workoutDataService, workoutId: workoutId)
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            NavigationLink("Add Exercise") {
                ExercisesView(workoutDataService: workoutDataService, workoutId: workoutId)
            }
        }
        
        Button("Save Changes") {
            Task {
                try await workoutDataService.updateWorkout(workout: DBWorkout(id: workoutId, userId: userId, name: workout.name, description: workout.desc, date: workout.date))
                /// I think this is fine because it's not forcing the main thread to wait, and instead will be called when
                /// the WorkoutManager is finished updating the workout
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditWorkoutView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), workout: Workout(name: "Example Workout", date: Date.now, desc: "This is a sample workout", intensity: 2, exercises: []), workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D", userId: "yf3B3l48yKbzgRWVbzKH3JyMKLz2")
    }
}
