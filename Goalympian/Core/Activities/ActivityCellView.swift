//
//  ActivityCellView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI

struct ActivityCellView: View {
    
    let exercise: APIExercise
    
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            
        }
    }
}

#Preview {
    ActivityCellView(exercise: APIExercise(
        id: UUID().uuidString,
        name: "Sample Exercise",
        equipment: "Keyboard and Mouse",
        target: .noCategory,
        secondaryMuscles: ["Forehead", "Fingers", "Eyes"],
        instructions: ["Sit down at the keyboard", "start typing", "nothing works", "cry"],
        gifUrl: "google.com",
        uuid: "SampleUserID",
        setType: .resistanceSet
    ))
}
