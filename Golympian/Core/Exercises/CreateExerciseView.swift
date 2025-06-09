//
//  CreateExercise.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import FirebaseFirestore

struct CreateExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var instructions: [String] = [""]
    @State private var numInstructions: Int = 1
    @State private var setType: SetType = SetType.resistanceSet
    @State private var targetMuscle: CategoryOption = CategoryOption.noCategory
    @State private var equipment: EquipmentOption = EquipmentOption.noEquipment
    @State private var customEquipment: String = ""
    @State private var instructionCountAlert: Bool = false
    @State private var duplicateExerciseAlert: Bool = false
    @State private var missingNameAlert: Bool = false
    @FocusState private var keyboardFocused: Bool
    
    @ObservedObject var viewModel: ExercisesViewModel
    
    var body: some View {
        Form {
            Section("Information") {
                TextField("Exercise Name", text: $name)
                    .focused($keyboardFocused)
                    .textInputAutocapitalization(.words)
                
                Picker("Primary Muscle", selection: $targetMuscle) {
                    ForEach(CategoryOption.allCases, id: \.self) { muscle in
                        Text(muscle.prettyString)
                    }
                }
                
                Picker("Type of Exercise", selection: $setType) {
                    ForEach(SetType.allCases, id: \.self) { set_type in
                        Text(set_type.prettyString)
                    }
                }
                
                Picker("Equipment Used", selection: $equipment) {
                    ForEach(EquipmentOption.allCases, id: \.self) { equipment in
                        Text(equipment.prettyString)
                    }
                }
                if (equipment == EquipmentOption.customEquipment) {
                    TextField("Custom Equipment Name", text: $customEquipment)
                        .textInputAutocapitalization(.words)
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
                        .textInputAutocapitalization(.sentences)
                }
            }
            
        }
        .onAppear {
            viewModel.getExercises()
            keyboardFocused = true
        }
        .navigationTitle("Create Exercise")
        .alert(
            "Error Creating Exercise",
            isPresented: $missingNameAlert
        ) {
            Button("Okay", action: {})
        } message: {
            Text("Exercises must have a name to be saved. Please enter a unique name.")
        }
        .alert(
            "Error Creating Exercise",
            isPresented: $duplicateExerciseAlert
        ) {
            Button("Okay", action: {})
        } message: {
            Text("Exercise with this name already exists, try a new name.")
        }
        
        BottomActionButton(label: "Save New Exercise", action: saveExercise)
    }
    
    private func saveExercise() {
        var exerciseNames: [String] = []
        viewModel.exercises.forEach { exercise in
            exerciseNames.append(exercise.name)
        }
        
        duplicateExerciseAlert = exerciseNames.contains(name)
        missingNameAlert = name == ""
        
        if !duplicateExerciseAlert && !missingNameAlert {
            Task {
                let savedEquipment = equipment != EquipmentOption.customEquipment ? equipment.rawValue : customEquipment
                
                try await ExerciseManager.shared.uploadExercise(exercise: APIExercise(
                    id: UUID().uuidString,
                    name: name,
                    equipment: savedEquipment,
                    target: targetMuscle,
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
    @Previewable let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    CreateExerciseView(viewModel: ExercisesViewModel(dataService: dataService))
}
