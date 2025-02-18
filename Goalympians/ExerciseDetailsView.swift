//
//  ExerciseDetailsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import SwiftUI

struct ExerciseDetailsView: View {
    
    var exercise: Exercise
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            Text(exercise.name)
            Text(exercise.desc)
            
            Section("Target Muscles") {
                ForEach(exercise.target_muscles) {muscle in
                    Text(muscle.name)
                }
                .onDelete(perform: removeMuscles)
            }
        }
    }
    
    func removeMuscles(_ indexSet: IndexSet) {
        for index in indexSet {
            exercise.target_muscles.remove(at: index)
        }
    }
}

#Preview {
    ExerciseDetailsView(
        exercise: Exercise(
        name: "Bench Press",
        desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
        target_muscles: [muscles[0], muscles[1], muscles[2]]
    ))
}
