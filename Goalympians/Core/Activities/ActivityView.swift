//
//  ActivitiesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

struct ActivityView: View {
    
    @StateObject private var viewModel: ActivityViewModel
    @State private var refreshHelper: Int
    let workoutDataService: WorkoutManagerProtocol
    
    var workoutId: String
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        workoutId: String
    ) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
        self.refreshHelper = 0
        self.workoutId = workoutId
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        List {
            if viewModel.activities.isEmpty {
                Text("No Exercises in Workout")
            } else {
                ForEach(viewModel.activities, id: \.workoutActivity.id.self) { entry in
                    Section {
                        HStack {
                            ActivityCellView(exercise: entry.exercise)
                            
                            Button("", systemImage: "plus") {
                                viewModel.addActivitySet(workoutId: workoutId, activityId: entry.workoutActivity.id)
                                refreshHelper = UUID().hashValue
                            }
                            .buttonStyle(.plain)
                            Button("", systemImage: "trash") {
                                viewModel.removeFromWorkout(workoutId: workoutId, activityId: entry.workoutActivity.id)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        ActivitySetView(workoutDataService: workoutDataService, refreshHelper: $refreshHelper, workoutId: workoutId, activityId: entry.workoutActivity.id)
                    }
                    }
            }
        }
        .onAppear {
            viewModel.getActivities(workoutId: workoutId)
        }
    }
}

#Preview {
    NavigationStack {
        ActivityView(
            workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")),
            workoutId: "1"
        )
    }
}
