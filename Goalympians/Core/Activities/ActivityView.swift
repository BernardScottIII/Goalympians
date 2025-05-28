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

    let workoutDataService: WorkoutManagerProtocol
    var workoutId: String
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        workoutId: String
    ) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
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
                ForEach(viewModel.activities, id: \.workoutActivity.id.self) { entry in
                    Section {
                        HStack {
                            Text(entry.exercise.name)
                            
                            Spacer()
                            
                            Button("", systemImage: "plus") {
                                viewModel.addActivitySet(workoutId: workoutId, activityId: entry.workoutActivity.id)
                                viewModel.updatedActivityId = entry.workoutActivity.id
                            }
                            .buttonStyle(.plain)
                            
                            Button("", systemImage: "trash") {
                                viewModel.removeFromWorkout(workoutId: workoutId, activityId: entry.workoutActivity.id)
                                viewModel.getActivities(workoutId: workoutId)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        ActivitySetView(workoutDataService: workoutDataService, workoutId: workoutId, activityId: entry.workoutActivity.id)
                            .environmentObject(viewModel)
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
    @Previewable @State var collection = Firestore.firestore().collection("workouts")
    NavigationStack {
        ActivityView(
            workoutDataService: ProdWorkoutManager(workoutCollection: collection),
            workoutId: "1"
        )
    }
}
