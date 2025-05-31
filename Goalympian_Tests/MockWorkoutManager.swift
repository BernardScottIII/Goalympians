//
//  MockWorkoutManager.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/21/25.
//

import Foundation
@testable import Goalympian

final class MockWorkoutManager: WorkoutManagerProtocol {
    func addWorkoutActivity(workoutId: String, exercise: APIExercise) async throws {
        
    }
    
    func removeWorkoutActivity(workoutId: String, activityId: String) async throws {
        
    }
    
    func getAllWorkoutActivities(workoutId: String) async throws -> [Goalympian.DBActivity] {
        guard let result = activities[workoutId] else {
            throw MockWorkoutManagerError.invalidWorkoutId("WorkoutId not found.")
        }
        return result
    }
    
    func addWorkoutActivitySet(workoutId: String, activityId: String) async throws {
        
    }
    
    func removeWorkoutActivitySet(workoutId: String, activityId: String, activitySetId: String) async throws {
        
    }
    
    func getAllActivitySets(workoutId: String, activityId: String) async throws -> [any Goalympian.DBActivitySet] {
        guard let result = activitySets["\(workoutId)_\(activityId)"] else {
            throw MockWorkoutManagerError.invalidWorkoutId("WorkoutId or ActivityId not found.")
        }
        return result
    }
    
    func getWorkoutActivity(workoutId: String, activityId: String) async throws -> Goalympian.DBActivity {
        guard let workoutActivities = activities[workoutId] else {
            throw MockWorkoutManagerError.invalidWorkoutId("WorkoutId not found.")
        }
        var result: DBActivity = DBActivity(id: "", exerciseId: "", setType: .resistanceSet, workoutIndex: -1)
        for workoutActivity in workoutActivities {
            if workoutActivity.id == activityId {
                result = workoutActivity
            }
        }
        return result
    }
    
    func updateActivitySet(workoutId: String, activity: Goalympian.DBActivity, set: any Goalympian.DBActivitySet) async throws {
        
    }
    
    func getActivitySet(workoutId: String, activity: Goalympian.DBActivity, setId: String) async throws -> any Goalympian.DBActivitySet {
        guard let workoutActivitySets = activitySets["\(workoutId)_\(activity.id)"] else {
            throw MockWorkoutManagerError.invalidWorkoutId("WorkoutId or ActivityId not found.")
        }
        var result = DBResistanceSet(id: "", weight: 0.0, repetitions: 0)
        for activitySet in workoutActivitySets {
            if activitySet.id == setId {
                result = activitySet as! DBResistanceSet
            }
        }
        return result
    }
    
    private var workouts: [DBWorkout] = []
    private var activities: [String: [DBActivity]] = [:]
    private var activitySets: [String: [DBActivitySet]] = [:]
    
    private enum MockWorkoutManagerError: Error {
        case invalidWorkoutId(String)
    }
    
    init() {
        let date = ISO8601DateFormatter().date(from:"2016-04-14T10:44:00+0000")!
        
        workouts = [
            DBWorkout(id: "workout1", userId: "user1", name: "Workout 1", description: "First Workout", date: date),
            DBWorkout(id: "workout2", userId: "user2", name: "Workout 2", description: "Second Workout", date: date),
            DBWorkout(id: "workout3", userId: "user3", name: "Workout 3", description: "Third Workout", date: date),
            DBWorkout(id: "workout4", userId: "user4", name: "Workout 4", description: "Fourth Workout", date: date),
            DBWorkout(id: "workout5", userId: "user5", name: "Workout 5", description: "Fifth Workout", date: date),
        ]
        activities = [
            "workout1": [
                DBActivity(id: "1", exerciseId: "0001", setType: .resistanceSet, workoutIndex: 0),
                DBActivity(id: "2", exerciseId: "0002", setType: .resistanceSet, workoutIndex: 1),
                DBActivity(id: "3", exerciseId: "0003", setType: .resistanceSet, workoutIndex: 2),
                DBActivity(id: "4", exerciseId: "0006", setType: .resistanceSet, workoutIndex: 3),
                DBActivity(id: "5", exerciseId: "0007", setType: .resistanceSet, workoutIndex: 4),
            ],
            "workout2": [
                DBActivity(id: "1", exerciseId: "0013", setType: .resistanceSet, workoutIndex: 0),
                DBActivity(id: "2", exerciseId: "0014", setType: .resistanceSet, workoutIndex: 1),
                DBActivity(id: "3", exerciseId: "0015", setType: .resistanceSet, workoutIndex: 2),
                DBActivity(id: "4", exerciseId: "0016", setType: .resistanceSet, workoutIndex: 3),
                DBActivity(id: "5", exerciseId: "0017", setType: .resistanceSet, workoutIndex: 4),
            ],
            "workout3": [
                DBActivity(id: "1", exerciseId: "0023", setType: .resistanceSet, workoutIndex: 0),
                DBActivity(id: "2", exerciseId: "0024", setType: .resistanceSet, workoutIndex: 1),
                DBActivity(id: "3", exerciseId: "0015", setType: .resistanceSet, workoutIndex: 2),
                DBActivity(id: "4", exerciseId: "0026", setType: .resistanceSet, workoutIndex: 3),
                DBActivity(id: "5", exerciseId: "0027", setType: .resistanceSet, workoutIndex: 4),
            ],
            "workout4": [
                DBActivity(id: "1", exerciseId: "0032", setType: .resistanceSet, workoutIndex: 0),
                DBActivity(id: "2", exerciseId: "0033", setType: .resistanceSet, workoutIndex: 1),
                DBActivity(id: "3", exerciseId: "0034", setType: .resistanceSet, workoutIndex: 2),
                DBActivity(id: "4", exerciseId: "0035", setType: .resistanceSet, workoutIndex: 3),
                DBActivity(id: "5", exerciseId: "0036", setType: .resistanceSet, workoutIndex: 4),
            ],
            "workout5": [
                DBActivity(id: "1", exerciseId: "0041", setType: .resistanceSet, workoutIndex: 0),
                DBActivity(id: "2", exerciseId: "0042", setType: .resistanceSet, workoutIndex: 1),
                DBActivity(id: "3", exerciseId: "0043", setType: .resistanceSet, workoutIndex: 2),
                DBActivity(id: "4", exerciseId: "0044", setType: .resistanceSet, workoutIndex: 3),
                DBActivity(id: "5", exerciseId: "0045", setType: .resistanceSet, workoutIndex: 4),
            ],
        ]
        activitySets = [
            "workout1_1": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout1_2": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout1_3": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout1_4": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout1_5": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout2_1": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout2_2": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout2_3": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout2_4": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout2_5": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout3_1": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout3_2": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout3_3": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout3_4": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout3_5": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout4_1": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout4_2": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout4_3": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout4_4": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout4_5": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout5_1": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout5_2": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout5_3": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout5_4": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
            "workout5_5": [
                DBResistanceSet(id: "1", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "2", weight: 0.0, repetitions: 0),
                DBResistanceSet(id: "3", weight: 0.0, repetitions: 0),
            ],
        ]
    }
    
    func createNewWorkout(workout: Goalympian.DBWorkout) async throws {
        
    }
    
    func getWorkout(workoutId: String) async throws -> Goalympian.DBWorkout {
        for workout in workouts {
            if workout.id == workoutId {
                return workout
            }
        }
        throw MockWorkoutManagerError.invalidWorkoutId("WorkoutId not found.")
    }
    
    func getAllWorkouts() async throws -> [Goalympian.DBWorkout] {
        return workouts
    }
    
    func updateWorkout(workout: Goalympian.DBWorkout) async throws {
        for (index, storedWorkout) in workouts.enumerated() {
            if storedWorkout.id == workout.id {
                workouts[index] = workout
                return
            }
        }
        throw MockWorkoutManagerError.invalidWorkoutId("WorkoutId not found.")
    }
}
