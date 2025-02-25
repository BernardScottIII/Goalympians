//
//  ResistanceExerciseSetView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/24/25.
//

import SwiftUI

struct ResistanceExerciseSetView: View {
    
    @Bindable var exerciseSet: ExerciseSet
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    var body: some View {
        HStack {
            TextField("Repetitions", value: $exerciseSet.repetitions, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
            TextField("Weight", value: $exerciseSet.weight, formatter: numberFormatter)
                .keyboardType(.decimalPad)
        }
    }
}

#Preview {
    ResistanceExerciseSetView(exerciseSet: ExerciseSet(exercise: Exercise(), workout: Workout()))
}
