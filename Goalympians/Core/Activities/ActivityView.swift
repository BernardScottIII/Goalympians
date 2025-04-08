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
    
    var workoutId: String
    
    var body: some View {
        List {
            if viewModel.activities.isEmpty {
                Text("No Exercises in Workout")
            } else {
                ForEach(viewModel.activities, id: \.workoutActivity.id.self) { entry in
                    HStack {
                        Text(entry.exercise.name)
                        
                        Spacer()
                        
                        Button("", systemImage: "plus") {
                            // Unimplemented Button
                        }
                        .buttonStyle(.plain)
                        Button("", systemImage: "trash") {
                            viewModel.removeFromWorkout(workoutId: workoutId, activityId: entry.workoutActivity.id)
                        }
                        .buttonStyle(.plain)
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
        ActivityView(workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D")
    }
}
