//
//  ActivityListView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import FirebaseFirestore

struct ResistanceSetView: View {
    
    let resistanceSet: DBActivitySet
    let workoutId: String
    let activity: DBActivity
    let workoutDataService: WorkoutManagerProtocol
    @ObservedObject var activitySetViewModel: ActivitySetViewModel
    
    // Maybe I should move some of these into the ViewModel?
    @State private var weight: Double? = nil
    @State private var repetitions: Int? = nil
    @FocusState private var weightFocused: Bool
    @FocusState private var repetitionsFocused: Bool
    @StateObject private var viewModel: ResistanceSetViewModel
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        resistanceSet: DBActivitySet,
        workoutId: String,
        activity: DBActivity,
        activitySetViewModel: ActivitySetViewModel
    ) {
        self.workoutDataService = workoutDataService
        _viewModel = StateObject(wrappedValue: ResistanceSetViewModel(workoutDataService: workoutDataService))
        self.resistanceSet = resistanceSet
        self.workoutId = workoutId
        self.activity = activity
        self.activitySetViewModel = activitySetViewModel
    }
    
    var body: some View {
        HStack {
            Image(systemName: "scalemass.fill")
            TextField("Weight", value: $weight, format: .number)
                .focused($weightFocused)
                .onChange(of: weightFocused) { oldValue, newValue in
                    if newValue == false {
                        Task {
                            try await viewModel.updateActivitySet(workoutId: workoutId, activity: activity, set: DBResistanceSet(id: resistanceSet.id, weight: weight ?? 0.0, repetitions: repetitions ?? 0))
                        }
                    }
                }
                .onAppear {
                    Task {
                        let snapshot = try await viewModel.getSetMetrics(workoutId: workoutId, activity: activity, setId: resistanceSet.id)
                        weight = snapshot.weight
                        repetitions = snapshot.repetitions
                    }
                }
            Spacer()
            Image(systemName: "pencil.and.list.clipboard")
            TextField("Repetitions", value: $repetitions, format: .number)
                .focused($repetitionsFocused)
                .onChange(of: repetitionsFocused) { oldValue, newValue in
                    if newValue == false {
                        Task {
                            try await viewModel.updateActivitySet(workoutId: workoutId, activity: activity, set: DBResistanceSet(id: resistanceSet.id, weight: weight ?? 0.0, repetitions: repetitions ?? 0))
                        }
                    }
                }
            Button("", systemImage: "trash") {
                Task {
                    try await viewModel.removeActivitySet(workoutId: workoutId, activityId: activity.id, setId: resistanceSet.id)
                    activitySetViewModel.getActivitySets(workoutId: workoutId, activityId: activity.id)
                }
            }
        }
    }
}

private func previewFunc() {}

#Preview {
    NavigationStack {
        Form {
            ResistanceSetView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), resistanceSet: DBResistanceSet(id: "iP1wvEqnL3YdoTGDlvyv", weight: 0.0, repetitions: 0), workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D", activity: DBActivity(id: "GzTwAOOgE40xBv6bFZ9Z", exerciseId: UUID().uuidString, setType: .resistanceSet, workoutIndex: 0), activitySetViewModel: ActivitySetViewModel(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))))
        }
    }
}
