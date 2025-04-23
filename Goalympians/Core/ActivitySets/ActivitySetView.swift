//
//  ActivitySetView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/8/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ActivitySetViewModel: ObservableObject {
    @Published private(set) var sets: [(activitySet: DBActivitySet, workoutActivity: DBActivity)] = []
    let workoutDataService: WorkoutManagerProtocol
    
    init(workoutDataService: WorkoutManagerProtocol) {
        self.workoutDataService = workoutDataService
    }
    
    func getActivitySets(workoutId: String, activityId: String) {
        Task {
            let activitySets = try await workoutDataService.getAllActivitySets(workoutId: workoutId, activityId: activityId)
            
            var localArray: [(activitySet: DBActivitySet, workoutActivity: DBActivity)] = []
            for set in activitySets {
                if let activity = try? await  workoutDataService.getWorkoutActivity(workoutId: workoutId, activityId: activityId) {
                    localArray.append((set, activity))
                }
            }
            
            self.sets = localArray
        }
    }
}

struct ActivitySetView: View {
    
    @StateObject private var viewModel: ActivitySetViewModel
    let workoutDataService: WorkoutManagerProtocol
    
    @Binding var refreshHelper: Int
    let workoutId: String
    let activityId: String
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        refreshHelper: Binding<Int>,
        workoutId: String,
        activityId: String
    ) {
        _viewModel = StateObject(wrappedValue: ActivitySetViewModel(workoutDataService: workoutDataService))
        _refreshHelper = refreshHelper
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
                        ResistanceSetView(workoutDataService: workoutDataService, resistanceSet: entry.activitySet, workoutId: workoutId, activity: entry.workoutActivity, refreshHelper: $refreshHelper)
                    } else if entry.activitySet is DBRunSet {
                        Text("Run Set!")
                    } else if entry.activitySet is DBSwimSet {
                        Text("Swim Set!")
                    }
                }
                .id(refreshHelper)
            }
        }
        .id(refreshHelper)
        .onAppear {
            viewModel.getActivitySets(workoutId: workoutId, activityId: activityId)
        }
    }
}

#Preview {
    @Previewable @State var refreshHelper = UUID().hashValue
    NavigationStack {
        Form {
            ActivitySetView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), refreshHelper: .constant(0), workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D", activityId: "GzTwAOOgE40xBv6bFZ9Z")
        }
    }
}
