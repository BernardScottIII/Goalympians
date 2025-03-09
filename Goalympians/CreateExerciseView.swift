//
//  CreateExercise.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData

struct CreateExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var setType: SetType = SetType.resistanceSet
    
    var body: some View {
        Form {
            TextField("Exercise Name", text: $name)
            TextField("Exercise Description", text: $desc, axis: .vertical)
            
            Picker("Type of Exercise", selection: $setType) {
                ForEach(SetType.allCases, id: \.self) { set_type in
                    Text(set_type.rawValue)
                }
            }
        }
        .navigationTitle("Create Exercise")
        Button("Create New Exercise") {
            modelContext.insert(Exercise(name: name, desc: desc, setType: setType))
            dismiss()
        }
    }
}

#Preview {
    CreateExerciseView()
}
