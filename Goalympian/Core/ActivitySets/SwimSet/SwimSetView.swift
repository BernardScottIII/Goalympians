//
//  SwimSetView.swift
//  Goalympians
//
//  Created by Bernard Scott on 5/30/25.
//

import SwiftUI
import FirebaseFirestore

struct SwimSetView: View {
    
    @State private var distance: Double? = nil
    @State private var laps: Int? = nil
    @State private var duration: Double? = nil
    @StateObject private var viewModel: SwimSetViewModel
    
    let workoutId: String
    let activity: DBActivity
    let swimSet: DBActivitySet
    let workoutDataService: WorkoutManagerProtocol
    @ObservedObject var activitySetViewModel: ActivitySetViewModel
    
    init(
        workoutId: String,
        activity: DBActivity,
        swimSet: DBActivitySet,
        workoutDataService: WorkoutManagerProtocol,
        activitySetViewModel: ActivitySetViewModel
    ) {
        _viewModel = StateObject(wrappedValue: SwimSetViewModel(workoutDataService: workoutDataService))
        self.workoutId = workoutId
        self.activity = activity
        self.swimSet = swimSet
        self.workoutDataService = workoutDataService
        self.activitySetViewModel = activitySetViewModel
    }
    
    var body: some View {
        HStack {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
            TextField("Distance", value: $distance, format: .number)
            
            Spacer()
            
            Image(systemName: "point.forward.to.point.capsulepath")
            TextField("Laps", value: $laps, format: .number)
            
            Spacer()
            
            Image(systemName: "stopwatch.fill")
            TextField("Duration", value: $duration, format: .number)
            
            Spacer()
            
            Button("", systemImage: "trash") {
                Task {
                    try await viewModel.removeActivitySet(workoutId: workoutId, activityId: activity.id, setId: swimSet.id)
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
            SwimSetView(
                workoutId: UUID().uuidString,
                activity: DBActivity(
                    id: UUID().uuidString,
                    exerciseId: UUID().uuidString,
                    setType: .swimSet,
                    workoutIndex: -1
                ),
                swimSet: DBSwimSet(
                    id: UUID().uuidString,
                    distance: 0.0,
                    laps: 0,
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
