//
//  SwimSetView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/7/25.
//

import SwiftUI

struct SwimSetView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var swimSet: SwimSet
    
    var body: some View {
        HStack {
            TextField("laps", value: $swimSet.laps, format: .number.precision(.significantDigits(2)))
            TextField("distance", value: $swimSet.dist, format: .number)
        }
    }
}

#Preview {
    SwimSetView(swimSet: SwimSet(workout: Workout(), exercise: Exercise(name: "Swimming", desc: "A swim in the lake", setType: SetType.swimSet), laps: 0.0, dist: 0.0, startTime: .distantPast, endTime: .distantFuture))
}
