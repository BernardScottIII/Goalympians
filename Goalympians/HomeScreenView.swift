//
//  HomeScreenView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import SwiftUI
import SwiftData

struct HomeScreenView: View {
    
    @Query var workouts: [Workout]
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            ForEach(workouts) { workout in
                NavigationLink(value: workout) {
                    Text(workout.name)
                }
            }
            .onDelete(perform: deleteWorkouts)
        }
        .navigationTitle("Workouts")
        .navigationDestination(for: Workout.self) { workout in
            EditWorkoutView(workout: workout)
        }
//        .navigationBarBackButtonHidden(true)
        .toolbar {
            Button("Add Workout", systemImage: "plus", action: addWorkout)
            Button("Home") {path = NavigationPath()}
        }
    }
    
    func deleteWorkouts(_ indexSet: IndexSet) {
        for index in indexSet {
            let workout = workouts[index]
            modelContext.delete(workout)
        }
    }
    
    func addWorkout() {
        let workout = Workout()
        modelContext.insert(workout)
        path.append(workout)
    }
}

#Preview {
//    @Previewable @State var path = NavigationPath()
//    HomeScreenView(path: $path)
}
