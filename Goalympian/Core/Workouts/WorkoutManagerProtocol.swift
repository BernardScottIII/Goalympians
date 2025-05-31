//
//  WorkoutManagerProtocol.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/21/25.
//

protocol WorkoutManagerProtocol {
    func createNewWorkout(workout: DBWorkout) async throws
    
    func getWorkout(workoutId: String) async throws -> DBWorkout
    
    func getAllWorkouts() async throws -> [DBWorkout]
    
    func updateWorkout(workout: DBWorkout) async throws
    
    func addWorkoutActivity(workoutId: String, exercise: APIExercise) async throws
    
    func removeWorkoutActivity(workoutId: String, activityId: String) async throws
    
    func getAllWorkoutActivities(workoutId: String) async throws -> [DBActivity]
    
    // MARK: ActivitySet Protocol
    func addWorkoutActivitySet(workoutId: String, activityId: String) async throws
    
    func removeWorkoutActivitySet(workoutId: String, activityId: String, activitySetId: String) async throws
    
    func getAllActivitySets(workoutId: String, activityId: String) async throws -> [DBActivitySet]
    
    func getWorkoutActivity(workoutId: String, activityId: String) async throws -> DBActivity
    
    func updateActivitySet(workoutId: String, activity: DBActivity, set: DBActivitySet) async throws
    
    func getActivitySet(workoutId: String, activity: DBActivity, setId: String) async throws -> DBActivitySet
}
