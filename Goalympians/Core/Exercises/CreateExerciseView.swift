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
    @State private var targetMuscle: ExercisesViewModel.CategoryOption = ExercisesViewModel.CategoryOption.noCategory
    @State private var equipment: ExercisesViewModel.EquipmentOption = ExercisesViewModel.EquipmentOption.noEquipment
    @State private var customEquipment: String = ""
    
    var body: some View {
        Form {
            TextField("Exercise Name", text: $name)
            TextField("Exercise Description", text: $desc, axis: .vertical)
            
            Picker("Primary Muscle", selection: $targetMuscle) {
                ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { muscle in
                    Text(muscle.rawValue)
                }
            }
            
            Picker("Type of Exercise", selection: $setType) {
                ForEach(SetType.allCases, id: \.self) { set_type in
                    Text(set_type.rawValue)
                }
            }
            
            Picker("Equipment Used", selection: $equipment) {
                ForEach(ExercisesViewModel.EquipmentOption.allCases, id: \.self) { equipment in
                    Text(equipment.rawValue)
                }
            }
            if (equipment == ExercisesViewModel.EquipmentOption.customEquipment) {
                TextField("Custom Equipment Name", text: $customEquipment)
            }
            
        }
        .navigationTitle("Create Exercise")
        Button("Save New Exercise") {
            Task {
                let savedEquipment = equipment != ExercisesViewModel.EquipmentOption.customEquipment ? equipment.rawValue : customEquipment
                
                try await ExerciseManager.shared.uploadExercise(exercise: APIExercise(
                    id: UUID().uuidString,
                    name: name,
                    bodyPart: "unknown_part",
                    equipment: savedEquipment,
                    target: targetMuscle.rawValue,
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
