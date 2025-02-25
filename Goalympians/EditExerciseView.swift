//
//  EditExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import SwiftUI
import SwiftData

struct EditExerciseView: View {
    
    @Bindable var workout: Workout
    @Bindable var exercise: Exercise
    @EnvironmentObject var routerManager: NavigationRouter
    
    var body: some View {
        Form {
            Section("Details"){
                TextField("Name", text: $exercise.name)
                TextField("Description", text: $exercise.desc, axis: .vertical)
            }
            
            Section("Target Muscles") {
                ForEach(exercise.target_muscles) {muscle in
                    Text(muscle.name)
                }
                Button("Add New Muscle") {
                    routerManager.push(to: Route.muscleListView(exercise: exercise))
                }
            }
            
            Section("Exercise Type") {
                Picker("Exercise Type", selection: $exercise.set_type) {
                    Text("Resistance").tag(ExerciseSetType.resistance)
                    Text("Running").tag(ExerciseSetType.run)
                    Text("Swimming").tag(ExerciseSetType.swim)
                }
            }
        }
        Spacer()
        Button("Add Exercise to Workout") {
            workout.exercises.append(exercise)
            workout.sets.append(ExerciseSet(exercise: exercise, workout: workout))
            routerManager.pop()
            routerManager.pop()
        }
    }
}

#Preview {
    EditExerciseView(
        workout: Workout(
            name: "Example Workout",
            desc: "This is a sample workout created for the purposes of testing persistent data"
        ),
        exercise: Exercise(
            name: "Bench Press",
            desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
            target_muscles: [muscles[0], muscles[1], muscles[2]]
        )
    )
}
