//
//  Route.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import Foundation
import SwiftUI

enum Route: Hashable, View {
    case editWorkoutView(workout: Workout)
    case exerciseListView(workout: Workout)
    case exerciseDetailsView(exercise: Exercise)
    case editExerciseView(workout: Workout, exercise: Exercise)
    case muscleListView(exercise: Exercise)
    case muscleDetailView(exercise: Exercise, muscle: Muscle)
    
    var body: some View {
        switch self {
        case .editWorkoutView(let workout):
            EditWorkoutView(workout: workout)
        case .exerciseListView(let workout):
            ExerciseListView(workout: workout)
        case .exerciseDetailsView(let exercise):
            ExerciseDetailsView(exercise: exercise)
        case .editExerciseView(let workout, let exercise):
            EditExerciseView(workout: workout, exercise: exercise)
        case .muscleListView(let exercise):
            MuscleListView(exercise: exercise)
        case .muscleDetailView(let exercise, let muscle):
            MuscleDetailView(exercise: exercise, muscle: muscle)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.editWorkoutView(let lhsItem), .editWorkoutView(let rhsItem)):
            return lhsItem.id == rhsItem.id
        case (.exerciseListView, .exerciseListView):
            return true
        case (.exerciseDetailsView(let lhsExercise), .exerciseDetailsView(let rhsExercise)):
            return lhsExercise.id == rhsExercise.id
        case (.editExerciseView(let lhsWorkout, let lhsExercise), .editExerciseView(let rhsWorkout, let rhsExercise)):
            return lhsExercise.id == rhsExercise.id && lhsWorkout.id == rhsWorkout.id
        case (.muscleListView(let lhsItem), .muscleListView(let rhsItem)):
            return lhsItem.id == rhsItem.id
        case (.muscleDetailView(let lhsExercise, let lhsMuscle), .muscleDetailView(let rhsExercise, let rhsMuscle)):
            return lhsExercise.id == rhsExercise.id && lhsMuscle.name == rhsMuscle.name
        default:
            return false
        }
    }
}
