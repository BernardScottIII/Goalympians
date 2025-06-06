//
//  WorkoutActivityOrderView.swift
//  Goalympian
//
//  Created by Bernard Scott on 6/6/25.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutActivityOrderView: View {
    @State private var editMode = EditMode.active
    
    @ObservedObject var activityViewModel: ActivityViewModel
    let workoutId: String
    
    var body: some View {
        List {
            ForEach(activityViewModel.activities, id: \.workoutActivity.id) { entry in
                // Try making everything it's own section
                Text(entry.exercise.name)
            }
            .onMove(perform: moveActivity)
        }
        .environment(\.editMode, $editMode)
    }
    
    private func moveActivity(from indexSet: IndexSet, to destination: Int) {
        Task {
            try await activityViewModel.moveActivity(workoutId: workoutId, fromOffsets: indexSet, toOffset: destination)
        }
    }
}

#Preview {
    @Previewable let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    WorkoutActivityOrderView(activityViewModel: ActivityViewModel(dataService: dataService), workoutId: "")
}
