//
//  ActivitiesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

struct ActivityView: View {
    
    @StateObject private var viewModel = ActivityViewModel()
    @State private var refreshHelper: Int = 0
    
    var workoutId: String
    
    var body: some View {
        List {
            if viewModel.activities.isEmpty {
                Text("No Exercises in Workout")
            } else {
                ForEach(viewModel.activities, id: \.workoutActivity.id.self) { entry in
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
                    
                    ActivitySetView(refreshHelper: $refreshHelper, workoutId: workoutId, activityId: entry.workoutActivity.id)
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
        ActivityView(workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D")
    }
}
