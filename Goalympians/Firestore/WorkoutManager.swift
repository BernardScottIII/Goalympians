//
//  WorkoutManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation
import FirebaseFirestore

struct DBWorkoutArray: Codable {
    let workouts: [DBWorkout]
    let total, skip, limit: Int
}

struct DBWorkout: Identifiable, Codable {
    let id: String
    let userId: String
    var name: String
    var description: String
    var date: Date
}

final class WorkoutManager {
    static let shared = WorkoutManager()
    private init() {}
    
    private let workoutCollection: CollectionReference = Firestore.firestore().collection("workouts")
    
    private func workoutDocument(workoutId: String) -> DocumentReference {
        workoutCollection.document(workoutId)
    }
    
    private func workoutActivityDocument(workoutId: String, activityId: String) -> DocumentReference {
        workoutActivityCollection(workoutId: workoutId).document(activityId)
    }
    
    private func workoutActivityCollection(workoutId: String) -> CollectionReference {
        workoutDocument(workoutId: workoutId).collection("activities")
    }
    
    func createNewWorkout(workout: DBWorkout) async throws {
        try workoutDocument(workoutId: workout.id).setData(from: workout, merge: false)
    }
    
    func getWorkout(workoutId: String) async throws -> DBWorkout {
        try await workoutDocument(workoutId: workoutId).getDocument(as: DBWorkout.self)
    }
    
    func getAllWorkouts() async throws -> [DBWorkout] {
        try await workoutCollection.getDocument(as: DBWorkout.self)
    }
    
    func updateWorkout(workout: DBWorkout) async throws {
        try workoutDocument(workoutId: workout.id).setData(from: workout, merge: true)
    }
    
    func addWorkoutActivity(workoutId: String, exerciseId: Int) async throws {
        let document = workoutActivityCollection(workoutId: workoutId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            DBActivity.CodingKeys.id.rawValue: documentId,
            DBActivity.CodingKeys.exerciseId.rawValue: exerciseId,
            DBActivity.CodingKeys.setType.rawValue: "resistance_set"
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeWorkoutActivity(workoutId: String, activityId: String) async throws {
        try await workoutActivityDocument(workoutId: workoutId, activityId: activityId).delete()
    }
    
    func getAllWorkoutActivities(workoutId: String) async throws -> [DBActivity] {
        try await workoutActivityCollection(workoutId: workoutId).getDocument(as: DBActivity.self)
    }
}


