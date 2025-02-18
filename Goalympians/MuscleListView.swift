//
//  MuscleListView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import SwiftUI
import SwiftData

struct MuscleListView: View {
    
    @EnvironmentObject private var routerManager: NavigationRouter
    @Environment(\.modelContext) var modelContext
    @Query var muscles: [Muscle]
    var exercise: Exercise
    
    var body: some View {
        List {
            ForEach(muscles) {muscle in
                NavigationLink(value: Route.muscleDetailView(exercise: exercise, muscle: muscle)) {
                    Text(muscle.name)
                }
            }
        }
        .navigationTitle("Muscles")
        .navigationDestination(for: Route.self) { $0 }
        .environmentObject(routerManager)
    }
}

#Preview {
    MuscleListView(exercise: Exercise(
        name: "Bench Press",
        desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
        target_muscles: [muscles[0], muscles[1], muscles[2]]
    ))
}
