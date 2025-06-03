//
//  RunSetView.swift
//  Goalympians
//
//  Created by Bernard Scott on 5/30/25.
//

import SwiftUI
import FirebaseFirestore

struct RunSetView: View {
    @State private var distance: Double? = nil
    @State private var elevation: Double? = nil
    @State private var duration: Double? = nil
    @StateObject private var viewModel: RunSetViewModel
    
    let workoutId: String
    let activity: DBActivity
    let runSet: DBActivitySet
    let workoutDataService: WorkoutManagerProtocol
    @ObservedObject var activitySetViewModel: ActivitySetViewModel
    
    init(
        workoutId: String,
        activity: DBActivity,
        runSet: DBActivitySet,
        workoutDataService: WorkoutManagerProtocol,
        activitySetViewModel: ActivitySetViewModel
    ) {
        self.workoutId = workoutId
        self.activity = activity
        self.runSet = runSet
        self.workoutDataService = workoutDataService
        self.activitySetViewModel = activitySetViewModel
        _viewModel = StateObject(wrappedValue: RunSetViewModel(workoutDataService: workoutDataService))
    }
    
    var body: some View {
        HStack {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
            TextField("Distance", value: $distance, format: .number)
                .keyboardType(.decimalPad)
            
            Spacer()
            
            Image(systemName: "barometer")
            TextField("Elevation", value: $elevation, format: .number)
                .keyboardType(.decimalPad)
            
            Spacer()
            
            Image(systemName: "stopwatch.fill")
            TextField("Duration", value: $duration, format: .number)
                .keyboardType(.decimalPad)
            
            Spacer()
            
            Button("", systemImage: "trash") {
                Task {
                    try await viewModel.removeActivitySet(workoutId: workoutId, activityId: activity.id, setId: runSet.id)
                    activitySetViewModel.getActivitySets(workoutId: workoutId, activityId: activity.id)
                }
            }
        }
    }
}

#Preview {
    @Previewable var workoutDataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        Form {
            RunSetView(
                workoutId: UUID().uuidString,
                activity: DBActivity(
                    id: UUID().uuidString,
                    exerciseId: UUID().uuidString,
                    setType: .runSet,
                    workoutIndex: -1
                ),
                runSet: DBRunSet(
                    id: UUID().uuidString,
                    distance: 0.0,
                    elevation: 0.0,
                    duration: 0.0
                ),
                workoutDataService: workoutDataService,
                activitySetViewModel: ActivitySetViewModel(
                    workoutDataService: workoutDataService
                )
            )
        }
    }
}
