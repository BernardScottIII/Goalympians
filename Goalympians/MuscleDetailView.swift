//
//  MuscleDetailView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import SwiftUI

struct MuscleDetailView: View {
    
    @Bindable var exercise: Exercise
    var muscle: Muscle
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var routeManager: NavigationRouter
    
    var body: some View {
        Text(muscle.name)
        Spacer()
        Button("Add Muscle to Exercise") {
            exercise.target_muscles.append(muscle)
            routeManager.pop()
            routeManager.pop()
        }
    }
}

#Preview {
    MuscleDetailView(exercise: Exercise(
        name: "Bench Press",
        desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
        target_muscles: [muscles[0], muscles[1], muscles[2]]
    ),
    muscle: Muscle(name: "Example"))
}
