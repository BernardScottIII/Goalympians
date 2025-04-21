//
//  ExerciseDetailsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/5/25.
//

import SwiftUI

struct ExerciseDetailsView: View {
    
    let exercise: APIExercise
    
    var body: some View {
        List {
            Text(exercise.name)
            ForEach(exercise.instructions, id: \.self) { instruction in
                Text(instruction)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailsView(exercise: APIExercise(
            id: UUID().uuidString,
            name: "Sample Exercise",
            bodyPart: "Head",
            equipment: "Keyboard and Mouse",
            target: "Brain",
            secondaryMuscles: ["Forehead", "Fingers", "eyes"],
            instructions: ["Sit down at keyboard", "start typing", "nothing works", "cry"],
            gifUrl: "google.com"))
    }
}
