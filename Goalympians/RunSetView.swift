//
//  RunSetView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/7/25.
//

import SwiftUI

struct RunSetView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var runSet: RunSet
    
    var body: some View {
        HStack {
            TextField("distance", value: $runSet.dist, format: .number.precision(.significantDigits(2)))
            TextField("elevation", value: $runSet.elevationChange, format: .number)
        }
    }
}

#Preview {
    RunSetView(runSet: RunSet(workout: Workout(), exercise: Exercise(name: "Running Exercise", desc: "A sample run", setType: SetType.runSet), dist: 0.0, startTime: .distantPast, endTime: .distantFuture, elevationChange: 0.0))
}
