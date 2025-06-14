//
//  ActivitySetView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/8/25.
//

import SwiftUI
import FirebaseFirestore

struct DEPRICATEDActivitySetView: View {
    
    @StateObject private var viewModel: DEPRICATEDActivitySetViewModel
    @EnvironmentObject private var activityViewModel: ActivityViewModel
    
    let workoutDataService: WorkoutManagerProtocol
    let workoutId: String
    let activityId: String
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        workoutId: String,
        activityId: String
    ) {
        _viewModel = StateObject(wrappedValue: DEPRICATEDActivitySetViewModel(workoutDataService: workoutDataService))
        self.workoutId = workoutId
        self.activityId = activityId
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        Group {
            if viewModel.sets.isEmpty {
                Text("Record set with plus button.")
            }
            else {
                ForEach(viewModel.sets, id:\.activitySet.id) { entry in
                    if entry.activitySet is DBResistanceSet {
                        ResistanceSetView(
                            workoutDataService: workoutDataService,
                            resistanceSet: entry.activitySet,
                            workoutId: workoutId,
                            activity: entry.workoutActivity,
                            activitySetViewModel: viewModel
                        )
                    } else if entry.activitySet is DBRunSet {
                        RunSetView(
                            workoutId: workoutId,
                            activity: entry.workoutActivity,
                            runSet: entry.activitySet,
                            workoutDataService: workoutDataService,
                            activitySetViewModel: viewModel
                        )
                    } else if entry.activitySet is DBSwimSet {
                        SwimSetView(
                            workoutId: workoutId,
                            activity: entry.workoutActivity,
                            swimSet: entry.activitySet,
                            workoutDataService: workoutDataService,
                            activitySetViewModel: viewModel
                        )
                    }
                }
            }
        }
        .onAppear {
            viewModel.getActivitySets(workoutId: workoutId, activityId: activityId)
        }
//        .onChange(of: activityViewModel.updatedActivityId) { oldValue, newValue in
//            if newValue == activityId {
//                viewModel.getActivitySets(workoutId: workoutId, activityId: activityId)
//            }
//        }
    }
}

#Preview {
    @Previewable var workoutCollection = Firestore.firestore().collection("workouts")
    NavigationStack {
        Form {
            DEPRICATEDActivitySetView(workoutDataService: ProdWorkoutManager(workoutCollection: workoutCollection), workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D", activityId: "GzTwAOOgE40xBv6bFZ9Z")
        }
    }
}
