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
            Text("List won't render without this")
            ForEach(viewModel.activities, id: \.workoutActivity.id.self) { entry in
                HStack {
                    ActivityCellView(exercise: entry.exercise)
                    
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
        .navigationTitle("Activities")
        .onAppear {
            viewModel.getActivities(workoutId: workoutId)
        }
    }
}

#Preview {
    NavigationStack {
        ActivityView(workoutId: "SampleId")
    }
}
