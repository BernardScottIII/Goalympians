//
//  CreateExercise.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData

struct CreateExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var setType: SetType = SetType.resistanceSet
    @State private var targetMuscle: String = ""
    @State private var equipment: String = ""
    @State private var difficulty: Int = 1
    
    var body: some View {
        Form {
            TextField("Exercise Name", text: $name)
            TextField("Exercise Description", text: $desc, axis: .vertical)
            TextField("Primary Muscle", text: $targetMuscle)
            
            Picker("Type of Exercise", selection: $setType) {
                ForEach(SetType.allCases, id: \.self) { set_type in
                    Text(set_type.rawValue)
                }
            }
            
            TextField("Equipment Used", text: $equipment)
            TextField("Difficulty", value: $difficulty, format: .number)
            
        }
        .navigationTitle("Create Exercise")
        Button("Save New Exercise") {
            Task {
                try await ExerciseManager.shared.uploadExercise(exercise: APIExercise(
                    id: UUID().uuidString,
                    name: name,
                    bodyPart: "unknown_part",
                    equipment: equipment,
                    target: targetMuscle,
                    secondaryMuscles: ["No secondary muscles"],
                    instructions: [desc],
                    gifUrl: "no url",
                    uuid: AuthenticationManager.shared.getAuthenticatedUser().uid
                ))
            }
            dismiss()
        }
    }
}

#Preview {
    CreateExerciseView()
}
