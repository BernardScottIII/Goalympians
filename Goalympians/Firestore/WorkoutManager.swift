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
    
    func addWorkoutActivity(workoutId: String, exerciseId: String) async throws {
        let document = workoutActivityCollection(workoutId: workoutId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            DBActivity.CodingKeys.id.rawValue: documentId,
            DBActivity.CodingKeys.exerciseId.rawValue: exerciseId,
            DBActivity.CodingKeys.setType.rawValue: "resistance_set",
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

// MARK: Activity Set
extension WorkoutManager {
    private func activitySetCollection(workoutId: String, activityId: String) -> CollectionReference {
        workoutActivityDocument(workoutId: workoutId, activityId: activityId).collection("activity_sets")
    }
    
    private func activitySetDocument(workoutId: String, activityId: String, activitySetId: String) -> DocumentReference {
        activitySetCollection(workoutId: workoutId, activityId: activityId).document(activitySetId)
    }
    
    func addWorkoutActivitySet(workoutId: String, activityId: String) async throws {
        let document = activitySetCollection(workoutId: workoutId, activityId: activityId).document()
        let documentId = document.documentID
        let activitySetType = try await workoutActivityDocument(workoutId: workoutId, activityId: activityId).getDocument(as: DBActivity.self).setType
        
        let data: [String:Any] = {
            switch activitySetType {
            case .resistanceSet:
                [
                    DBResistanceSet.CodingKeys.id.rawValue: documentId,
                    DBResistanceSet.CodingKeys.weight.rawValue: 0.0,
                    DBResistanceSet.CodingKeys.repetitions.rawValue: 0
                ]
            case .runSet:
                [
                    DBRunSet.CodingKeys.id.rawValue: documentId,
                    DBRunSet.CodingKeys.distance.rawValue: 0.0,
                    DBRunSet.CodingKeys.elevation.rawValue: 0.0,
                    DBRunSet.CodingKeys.duration.rawValue: 0.0
                ]
            case .swimSet:
                [
                    DBSwimSet.CodingKeys.id.rawValue: documentId,
                    DBSwimSet.CodingKeys.distance.rawValue: 0.0,
                    DBSwimSet.CodingKeys.laps.rawValue: 0,
                    DBSwimSet.CodingKeys.duration.rawValue: 0.0
                ]
            }
        }()
        
        try await document.setData(data, merge: false)
    }
    
    func removeWorkoutActivitySet(workoutId: String, activityId: String, activitySetId: String) async throws {
        try await activitySetDocument(workoutId: workoutId, activityId: activityId, activitySetId: activitySetId).delete()
    }
    
    func getAllActivitySets(workoutId: String, activityId: String) async throws -> [DBActivitySet] {
        let activity = try await workoutActivityDocument(workoutId: workoutId, activityId: activityId).getDocument(as: DBActivity.self)
        
        return switch activity.setType {
        case .resistanceSet:
            try await activitySetCollection(workoutId: workoutId, activityId: activityId).getDocument(as: DBResistanceSet.self)
        case .runSet:
            try await activitySetCollection(workoutId: workoutId, activityId: activityId).getDocument(as: DBRunSet.self)
        case .swimSet:
            try await activitySetCollection(workoutId: workoutId, activityId: activityId).getDocument(as: DBSwimSet.self)
        }
    }
    
    func getWorkoutActivity(workoutId: String, activityId: String) async throws -> DBActivity {
        try await workoutActivityDocument(workoutId: workoutId, activityId: activityId).getDocument(as: DBActivity.self)
    }
    
    func updateActivitySet(workoutId: String, activity: DBActivity, set: DBActivitySet) async throws {
        switch activity.setType {
        case .resistanceSet:
            try activitySetDocument(workoutId: workoutId, activityId: activity.id, activitySetId: set.id).setData(from: set as! DBResistanceSet, merge: true)
        case .runSet:
            try activitySetDocument(workoutId: workoutId, activityId: activity.id, activitySetId: set.id).setData(from: set as! DBRunSet, merge: true)
        case .swimSet:
            try activitySetDocument(workoutId: workoutId, activityId: activity.id, activitySetId: set.id).setData(from: set as! DBSwimSet, merge: true)
        }
    }
    
    func getActivitySet(workoutId: String, activity: DBActivity, setId: String) async throws -> DBActivitySet {
        switch activity.setType {
        case .resistanceSet:
            return try await activitySetDocument(workoutId: workoutId, activityId: activity.id, activitySetId: setId).getDocument(as: DBResistanceSet.self)
        case .runSet:
            return try await activitySetDocument(workoutId: workoutId, activityId: activity.id, activitySetId: setId).getDocument(as: DBRunSet.self)
        case .swimSet:
            return try await activitySetDocument(workoutId: workoutId, activityId: activity.id, activitySetId: setId).getDocument(as: DBSwimSet.self)
        }
        
    }
}


