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
    @StateObject private var activityViewModel: ActivityViewModel
    @State private var userId: String = ""
    
    @Binding var workout: DBWorkout
    var workoutDataService: WorkoutManagerProtocol
    
    init(
        workout: Binding<DBWorkout>,
        workoutDataService: WorkoutManagerProtocol
    ) {
        self._workout = workout
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        VStack{
            Form {
                TextField("name", text: $workout.name)
                TextField("desc", text: $workout.description, axis: .vertical)
                DatePicker("date", selection: $workout.date)
                
                ActivityView(viewModel: activityViewModel, workoutDataService: workoutDataService, workoutId: workout.id)
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink("Edit Order") {
                    WorkoutActivityOrderView(activityViewModel: activityViewModel, workoutId: workout.id)
                }
            }
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink("Add Exercise") {
                    ExercisesView(activityViewModel: activityViewModel, workoutDataService: workoutDataService, workoutId: workout.id, userIds: [
                        userId,
                        "global"
                    ])
                }
            }
        }
        .onAppear {
            Task {
                self.userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            }
        }
        
        Button("Save Changes") {
            Task {
                try await workoutDataService.updateWorkout(workout: DBWorkout(id: workout.id, userId: workout.userId, name: workout.name, description: workout.description, date: workout.date))
                /// I think this is fine because it's not forcing the main thread to wait, and instead will be called when
                /// the WorkoutManager is finished updating the workout
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @State var workout = DBWorkout(id: UUID().uuidString, userId: UUID().uuidString, name: "Sample", description: "Example", date: .now)
    NavigationStack {
        EditWorkoutView(workout: $workout, workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
    }
}
