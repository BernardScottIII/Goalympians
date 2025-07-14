//
//  EditExerciseView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/14/25.
//

import SwiftUI
import FirebaseFirestore

struct EditExerciseView: View {
    
    @State private var customEquipment: String = ""
    @State private var instructionCountAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var numInstructions: Int
    @State private var equipment: EquipmentOption
    
    @Binding var exercise: APIExercise
    @ObservedObject var viewModel: ExercisesViewModel
    
    init(
        exercise: Binding<APIExercise>,
        viewModel: ExercisesViewModel
    ) {
        _exercise = exercise
        self.viewModel = viewModel
        numInstructions = exercise.instructions.count
        equipment = .noEquipment
        for option in EquipmentOption.allCases {
            if option.rawValue == exercise.equipment.wrappedValue {
                equipment = option
            }
        }
    }
    
    var body: some View {
        Form {
            TextField("Exercise Name", text: $exercise.name)
            
            Picker("Primary Muscle", selection: $exercise.target) {
                ForEach(CategoryOption.allCases, id: \.self) { muscle in
                    Text(muscle.prettyString)
                }
            }
            
            Picker("Equipment Used", selection: $equipment) {
                ForEach(EquipmentOption.allCases, id: \.self) { equipment in
                    Text(equipment.prettyString)
                }
            }
            if (exercise.equipment == EquipmentOption.customEquipment.rawValue) {
                TextField("Custom Equipment Name", text: $customEquipment)
                    .textInputAutocapitalization(.words)
            }
            
            Section("Instructions") {
                HStack {
                    Text("Number of Instructions: \(numInstructions)")
                    Spacer()
                    Button("", systemImage: "plus") {
                        if numInstructions < 10 {
                            numInstructions += 1
                            exercise.instructions.append("")
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
                            exercise.instructions.removeLast()
                        }
                    }
                    
                }
                .buttonStyle(.plain)
                
                ForEach(0..<numInstructions, id:\.self) { step in
                    TextField("Step #\(step+1)", text: $exercise.instructions[step])
                        .textInputAutocapitalization(.sentences)
                }
            }
        }
        .navigationTitle("Edit Exercise")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Save", action: saveExercise)
            }
        }
    }
    
    private func saveExercise() {
        Task {
            try await viewModel.updateExercise(exercise: exercise)
            dismiss()
        }
    }
}

#Preview {
    @Previewable @State var exercise = APIExercise(name: "", equipment: "", target: .abductor, secondaryMuscles: [], instructions: [], gifUrl: "", uuid: "", setType: .resistanceSet)
    @Previewable @StateObject var viewModel = ExercisesViewModel(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
    NavigationStack {
        EditExerciseView(exercise: $exercise, viewModel: viewModel)
    }
}
