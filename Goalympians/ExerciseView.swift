//
//  ExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import SwiftUI

struct ExerciseView: View {
    
    let exercise: Exercise
    
    var body: some View {
        Text(exercise.name)
    }
}

#Preview {
    ExerciseView(exercise: Exercise(
        name: "Bench Press",
        desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
        target_muscles: [muscles[0], muscles[1], muscles[2]]
    ))
}
