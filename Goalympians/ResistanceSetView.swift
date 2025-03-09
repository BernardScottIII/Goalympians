//
//  ActivityListView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI

struct ResistanceSetView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var resistanceSet: ResistanceSet
    
    var body: some View {
        HStack {
            TextField("weight", value: $resistanceSet.weight, format: .number.precision(.significantDigits(2)))
            TextField("repetitions", value: $resistanceSet.repetitions, format: .number)
        }
    }
}

#Preview {
    ResistanceSetView(resistanceSet: ResistanceSet(workout: Workout(), exercise: Exercise(name: "Example", desc: "Sample desc", setType: SetType.resistanceSet), weight: 0.0, repetitions: 0))
}
