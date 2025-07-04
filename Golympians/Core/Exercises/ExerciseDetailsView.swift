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
        HStack{
            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        
        List {
            Section("Instructions") {
                ForEach(exercise.instructions, id: \.self) { instruction in
                    Text(instruction)
                }
            }
            Section("Equipment") {
                if let equipmentValue = EquipmentOption(rawValue: exercise.equipment) {
                    Text(equipmentValue.prettyString)
                } else {
                    Text("Bad Equipment Value, report this issue.")
                }
            }
            Section("Target Muscle") {
                Text(exercise.target.prettyString)
            }
            Section("Secondary Muscles") {
                ForEach(exercise.secondaryMuscles, id: \.self) { muscle in
                    Text(muscle)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NavigationLink("Exercise Details View") {
            ExerciseDetailsView(exercise: APIExercise(
                id: UUID().uuidString,
                name: "Sample Exercise",
                equipment: "Keyboard and Mouse",
                target: .noCategory,
                secondaryMuscles: ["Forehead", "Fingers", "eyes"],
                instructions: ["Sit down at keyboard", "start typing", "nothing works", "cry"],
                gifUrl: "google.com",
                uuid: "SampleUserID",
                setType: .resistanceSet))
        }
    }
}
