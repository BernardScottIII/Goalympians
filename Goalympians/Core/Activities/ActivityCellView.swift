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
    ActivityCellView(exercise: APIExercise(id: UUID().uuidString, name: "Sample Exercise", bodyPart: "Head", equipment: "Keyboard and Mosue", target: "Brain", secondaryMuscles: ["Forehead", "Fingers", "Eyes"], instructions: ["Sit down at the keyboard", "start typing", "nothing works", "cry"], gifUrl: "google.com"))
//        id: 0,
//        name: "Sample Exercise",
//        type: "An example exercise for testing purposes",
//        muscle: "Brain",
//        equipment: "Computer",
//        difficulty: "beginner",
//        instructions: "Sitting down and writing code all day.",
//        userId: UUID().uuidString))
}
