//
//  ActivityCellViewBuilder.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI

struct ActivityCellViewBuilder: View {
    
    let exerciseId: String
    @State private var activity: APIExercise? = nil
    
    var body: some View {
        ZStack {
            if let activity {
//                ActivityCellView()
            }
        }
        .task {
            self.activity = try? await ExerciseManager.shared.getExercise(exerciseId: exerciseId)
        }
    }
}

#Preview {
    ActivityCellViewBuilder(exerciseId: "SampleExerciseId")
}
