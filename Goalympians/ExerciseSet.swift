//
//  Activity.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData



@Model
class ResistanceSet {
    @Relationship
    var workout: Workout
    @Relationship
    var exercise: Exercise
    
    var weight: Double
    var repetitions: Int
    
    init(workout: Workout, exercise: Exercise, weight: Double, repetitions: Int) {
        self.workout = workout
        self.exercise = exercise
        self.weight = weight
        self.repetitions = repetitions
    }
}

@Model
class RunSet {
    @Relationship
    var workout: Workout
    @Relationship
    var exercise: Exercise
    
    var dist: Double
    var startTime: Date
    var endTime: Date
    var elevationChange: Double
    
    init(workout: Workout, exercise: Exercise, dist: Double, startTime: Date, endTime: Date, elevationChange: Double) {
        self.workout = workout
        self.exercise = exercise
        self.dist = dist
        self.startTime = startTime
        self.endTime = endTime
        self.elevationChange = elevationChange
    }
}

@Model
class SwimSet {
    @Relationship
    var workout: Workout
    @Relationship
    var exercise: Exercise
    
    var laps: Double
    var dist: Double
    var startTime: Date
    var endTime: Date
    
    init(workout: Workout, exercise: Exercise, laps: Double, dist: Double, startTime: Date, endTime: Date) {
        self.workout = workout
        self.exercise = exercise
        self.laps = laps
        self.dist = dist
        self.startTime = startTime
        self.endTime = endTime
    }
}
