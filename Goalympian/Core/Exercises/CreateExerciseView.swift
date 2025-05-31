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
    @State private var instructions: [String] = [""]
    @State private var numInstructions: Int = 1
    @State private var setType: SetType = SetType.resistanceSet
    @State private var targetMuscle: ExercisesViewModel.CategoryOption = ExercisesViewModel.CategoryOption.noCategory
    @State private var equipment: ExercisesViewModel.EquipmentOption = ExercisesViewModel.EquipmentOption.noEquipment
    @State private var customEquipment: String = ""
    @State private var instructionCountAlert: Bool = false
    
    var body: some View {
        Form {
            Section("Information") {
                TextField("Exercise Name", text: $name)
                
                Picker("Primary Muscle", selection: $targetMuscle) {
                    ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { muscle in
                        Text(muscle.prettyString)
                    }
                }
                
                Picker("Type of Exercise", selection: $setType) {
                    ForEach(SetType.allCases, id: \.self) { set_type in
                        Text(set_type.prettyString)
                    }
                }
                
                Picker("Equipment Used", selection: $equipment) {
                    ForEach(ExercisesViewModel.EquipmentOption.allCases, id: \.self) { equipment in
                        Text(equipment.prettyString)
                    }
                }
                if (equipment == ExercisesViewModel.EquipmentOption.customEquipment) {
                    TextField("Custom Equipment Name", text: $customEquipment)
                }
            }
            
            Section("Instructions") {
                HStack {
                    Text("Number of Instructions: \(numInstructions)")
                    Spacer()
                    Button("", systemImage: "plus") {
                        if numInstructions < 10 {
                            numInstructions += 1
                            instructions.append("")
                        } else {
                            instructionCountAlert = true
                        }
                    }
                    .alert(
                        "Too Many Instructions",
                        isPresented: $instructionCountAlert
                    ) {
                        Button("Okay", action: {})
                    } message: {
                        Text("Exercises can have a maximum of ten instructions.")
                    }
                    
                    Button("", systemImage: "minus") {
                        if (numInstructions > 1 ) {
                            numInstructions -= 1
                            instructions.removeLast()
                        }
                    }
                    
                }
                .buttonStyle(.plain)
                
                ForEach(0..<numInstructions, id:\.self) { step in
                    TextField("Step #\(step+1)", text: $instructions[step])
                }
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
                    instructions: instructions,
                    gifUrl: "no url",
                    uuid: AuthenticationManager.shared.getAuthenticatedUser().uid,
                    setType: setType
                ))
            }
            dismiss()
        }
    }
}

#Preview {
    CreateExerciseView()
}
