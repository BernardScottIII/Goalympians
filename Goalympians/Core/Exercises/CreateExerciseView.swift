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
    @State private var muscle: String = ""
    @State private var equipment: String = ""
    @State private var difficulty: Int = 1
    
    var body: some View {
        Form {
            TextField("Exercise Name", text: $name)
            TextField("Exercise Description", text: $desc, axis: .vertical)
            
            Picker("Type of Exercise", selection: $setType) {
                ForEach(SetType.allCases, id: \.self) { set_type in
                    Text(set_type.rawValue)
                }
            }
            
            TextField("Muscle Type", text: $muscle)
            TextField("Equipment Used", text: $equipment)
            TextField("Difficulty", value: $difficulty, format: .number)
            
        }
        .navigationTitle("Create Exercise")
        Button("Create New Exercise") {
            Task {
                try await ExerciseManager.shared.uploadExercise(exercise: APIExercise(id: UUID().uuidString, name: name, bodyPart: "unknown_part", equipment: equipment, target: muscle, secondaryMuscles: ["No secondary muscles"], instructions: ["no given instructions"], gifUrl: "no url"))
            }
            dismiss()
        }
    }
}

#Preview {
    CreateExerciseView()
}
