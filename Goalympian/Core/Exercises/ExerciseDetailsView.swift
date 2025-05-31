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
            Section("Instructions") {
                ForEach(exercise.instructions, id: \.self) { instruction in
                    Text(instruction)
                }
            }
            Section("Equipment") {
                Text(exercise.equipment)
            }
            Section("Target Muscle") {
                Text(exercise.target)
            }
            Section("Secondary Muscles") {
                ForEach(exercise.secondaryMuscles, id: \.self) { muscle in
                    Text(muscle)
                }
            }
        }
        .navigationTitle(exercise.name)
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
            gifUrl: "google.com",
            uuid: "SampleUserID",
            setType: .resistanceSet
        ))
    }
}
