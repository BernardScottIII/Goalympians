//
//  ActivitiesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

struct ActivityView: View {
    
    @State private var removeActivityAlert: Bool = false
    @State private var targetActivityId: String? = nil
    
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
                            
                            Spacer()
                            
                            Button("", systemImage: "plus") {
                                if viewModel.activities.count < 10 {
                                    viewModel.addEmptyActivitySet(workoutId: workoutId, activity: entry.workoutActivity)
                                    viewModel.getAllActivities(workoutId: workoutId)
                                }
                            }
                            Button("", systemImage: "trash") {
                                removeActivityAlert = true
                                targetActivityId = entry.workoutActivity.id
                            }
                        }
                        .buttonStyle(.plain)
                        
                        ActivitySetsView(
                            viewModel: viewModel,
                            workoutId: workoutId,
                            activity: viewModel.binding(for: entry.workoutActivity.id)!
                        )
                    }
                }
            }
        }
        .onAppear {
            viewModel.getAllActivities(workoutId: workoutId)
        }
        .alert("Remove Exercise?", isPresented: $removeActivityAlert) {
            Button("Cancel", role: .cancel) {
                targetActivityId = nil
            }
            Button("Remove", role: .destructive) {
                viewModel.removeFromWorkout(workoutId: workoutId, activityId: targetActivityId!)
            }
        } message: {
            Text("Removing exercise will remove all sets recorded for exercise. Are you sure you want to continue?")
        }
    }
    
    private func removeActivitySet(activity: DBActivity) {
        guard let lastSet = activity.activitySets.last else { return }
        viewModel.removeActivitySet(workoutId: workoutId, activityId: activity.id, set: lastSet)
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
