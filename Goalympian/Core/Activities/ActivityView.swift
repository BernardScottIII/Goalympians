//
//  ActivitiesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

struct ActivityView: View {
    
    @ObservedObject var viewModel: ActivityViewModel
    let workoutDataService: WorkoutManagerProtocol
    let workoutId: String
    
    init(
        viewModel: ActivityViewModel,
        workoutDataService: WorkoutManagerProtocol,
        workoutId: String
    ) {
        self.viewModel = viewModel
        self.workoutId = workoutId
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        List {
            if viewModel.activities.isEmpty {
                Section {
                    Text("No Exercises in Workout")
                }
            } else {
                ForEach(viewModel.activities, id: \.workoutActivity.id) { entry in
                    Section {
                        HStack {
                            Text(entry.exercise.name)
                                .truncationMode(.tail)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button("", systemImage: "plus") {
                                viewModel.addActivitySet(workoutId: workoutId, activityId: entry.workoutActivity.id)
                                viewModel.updatedActivityId = entry.workoutActivity.id
                            }
                            
                            Button("", systemImage: "trash") {
                                viewModel.removeFromWorkout(workoutId: workoutId, activityId: entry.workoutActivity.id)
                                Task {
                                    try await viewModel.getActivities(workoutId: workoutId)
                                }
                            }
                        }
                        
                        ActivitySetView(workoutDataService: workoutDataService, workoutId: workoutId, activityId: entry.workoutActivity.id)
                            .environmentObject(viewModel)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.getActivities(workoutId: workoutId)
            }
        }
    }
}

#Preview {
    @Previewable let workoutDataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        ActivityView(
            viewModel: ActivityViewModel(dataService: workoutDataService), workoutDataService: workoutDataService,
            workoutId: "1"
        )
    }
}
