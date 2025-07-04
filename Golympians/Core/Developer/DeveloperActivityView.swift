//
//  DeveloperActivityView.swift
//  Golympian
//
//  Created by Bernard Scott on 7/4/25.
//

import SwiftUI
import FirebaseFirestore

struct DeveloperActivityView: View {
    @StateObject private var activityViewModel: ActivityViewModel
    
    let dataService: WorkoutManagerProtocol
    let workoutId: String
    
    init(
        dataService: WorkoutManagerProtocol,
        workoutId: String
    ) {
        self.dataService = dataService
        self.workoutId = workoutId
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: dataService))
    }
    
    var body: some View {
        Text("WorkoutId: \(workoutId)")
        Text("Number of Sets: \(activityViewModel.activities.count)")
            .task {
                activityViewModel.getAllActivities(workoutId: workoutId)
            }
        ForEach(activityViewModel.activities, id: \.workoutActivity.id) { activity in
            Text("ID: \(activity.workoutActivity.id)")
            Text("Exercise ID: \(activity.workoutActivity.exerciseId)")
            Text("Set Type: \(activity.workoutActivity.setType.rawValue)")
            Text("Workout Index: \(activity.workoutActivity.workoutIndex)")
        }
    }
}

#Preview {
    List {
        DeveloperActivityView(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), workoutId: "")
    }
}
