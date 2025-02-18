//
//  Exercise.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var desc: String
    var target_muscles: [Muscle]
    
    init(id: UUID = UUID(), name: String = "", desc: String = "", target_muscles: [Muscle] = []) {
        self.id = id
        self.name = name
        self.desc = desc
        self.target_muscles = target_muscles
    }
}

@Model
class Muscle: Hashable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

protocol ExerciseSet: Identifiable, Hashable {
    var id: UUID { get }
    var exercise: Exercise { get }
    var workout: Workout { get }
    
//    init(id: UUID, exercise: Exercise, workout: Workout)
}

struct ResistanceSet: ExerciseSet {
    var id: UUID
    var exercise: Exercise
    var workout: Workout
    var weight: Decimal
    var repetitions: Int
    var time: Decimal?
    
    init(id: UUID = UUID(), exercise: Exercise = Exercise(), workout: Workout = Workout(), weight: Decimal = 0.0, repetitions: Int = 0, time: Decimal? = nil) {
        self.id = id
        self.exercise = exercise
        self.workout = workout
        self.weight = weight
        self.repetitions = repetitions
        self.time = time
    }
}

struct RunSet: ExerciseSet {
    var id: UUID
    var exercise: Exercise
    var workout: Workout
    var elevation: Decimal
    var time: Decimal
    var distance: Decimal
}

struct SwimSet: ExerciseSet {
    var id: UUID
    var exercise: Exercise
    var workout: Workout
    var distance: Decimal
    var time: Decimal
}

let muscles: [Muscle] = [
    Muscle(name: "Pectoralis Major"),
    Muscle(name: "Anterior Deltoid"),
    Muscle(name: "Tricep"),
    Muscle(name: "Glutes"),
    Muscle(name: "Hamstring"),
    Muscle(name: "Quadriceps"),
    Muscle(name: "Erector Spinae"),
    Muscle(name: "Calves"),
    Muscle(name: "Adductors"),
    Muscle(name: "Abdominals")
]

//let exercises: [Exercise] = [
//    Exercise(
//        name: "Bench Press",
//        desc: "Lay flat on a bench, take the bar in your hands, lift bar off of bench, bring towards chest until contact, extend away from chest as far as possible. Repeat until fatigued.",
//        target_muscles: [muscles[0], muscles[1], muscles[2]]
//    ),
//    Exercise(
//        name: "Deadlift",
//        desc: "Place barbell on ground, add desired weight to each side of barbell, pick up barbell and stand straight up, drop barbell. Repeat until fatigued.",
//        target_muscles: [muscles[3], muscles[4], muscles[5], muscles[6]]
//    ),
//    Exercise(
//        name: "Squat",
//        desc: "Approach squat rack with barbell, load desired weight onto each side of barbell, go under barbell and meet barbell wtih shoulders, stand up to unrack barbell, back up and squat down until legs make right angle, stand up, move forward, set bar back down. Repeat until fatigued.",
//     target_muscles: [muscles[3], muscles[4], muscles[5], muscles[7], muscles[8], muscles[9]])
//]
