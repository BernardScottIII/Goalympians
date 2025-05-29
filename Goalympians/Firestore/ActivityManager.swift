//
//  ActivityManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import Foundation
import FirebaseFirestore

protocol DBActivitySet: Codable {
    var id: String { get }
}

struct DBResistanceSet: DBActivitySet, Codable {
    let id: String
    let weight: Double
    let repetitions: Int
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.weight, forKey: .weight)
        try container.encode(self.repetitions, forKey: .repetitions)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case weight = "weight"
        case repetitions = "repetitions"
    }
    
    init(id: String, weight: Double, repetitions: Int) {
        self.id = id
        self.weight = weight
        self.repetitions = repetitions
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.repetitions = try container.decode(Int.self, forKey: .repetitions)
    }
}

struct DBRunSet: DBActivitySet, Codable {
    let id: String
    let distance: Double
    let elevation: Double
    let duration: Double
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.distance, forKey: .distance)
        try container.encode(self.elevation, forKey: .elevation)
        try container.encode(self.duration, forKey: .duration)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case distance = "distance"
        case elevation = "elevation"
        case duration = "duration"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.elevation = try container.decode(Double.self, forKey: .elevation)
        self.duration = try container.decode(Double.self, forKey: .duration)
    }
    
    init(id: String, distance: Double, elevation: Double, duration: Double) {
        self.id = id
        self.distance = distance
        self.elevation = elevation
        self.duration = duration
    }
}

struct DBSwimSet: DBActivitySet, Codable {
    let id: String
    let distance: Double
    let laps: Int
    let duration: Double
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.distance, forKey: .distance)
        try container.encode(self.laps, forKey: .laps)
        try container.encode(self.duration, forKey: .duration)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case distance = "distance"
        case laps = "laps"
        case duration = "duration"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.laps = try container.decode(Int.self, forKey: .laps)
        self.duration = try container.decode(Double.self, forKey: .duration)
    }
    
    init(id: String, distance: Double, laps: Int, duration: Double) {
        self.id = id
        self.distance = distance
        self.laps = laps
        self.duration = duration
    }
}

enum SetType: String, Codable, CaseIterable {
    case resistanceSet = "resistance_set"
    case runSet = "run_set"
    case swimSet = "swim_set"
    
    var prettyString: String {
        switch self {
        case .resistanceSet: return "Resistance Exercise"
        case .runSet: return "Walk/Jog/Run"
        case .swimSet: return "Swimming"
        }
    }
}

struct DBActivityList: Codable {
    let activities: [DBActivity]
    let total, skip, limit: Int
}

struct DBActivity: Identifiable, Codable {
    let id: String
    let exerciseId: String
    let setType: SetType
    let workoutIndex: Int
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.exerciseId, forKey: .exerciseId)
        try container.encode(self.setType, forKey: .setType)
        try container.encode(self.workoutIndex, forKey: .workoutIndex)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case exerciseId = "exercise_id"
        case setType = "set_type"
        case workoutIndex = "workout_index"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.exerciseId = try container.decode(String.self, forKey: .exerciseId)
        self.setType = try container.decode(SetType.self, forKey: .setType)
        self.workoutIndex = try container.decode(Int.self, forKey: .workoutIndex)
    }
    
    init(
        id: String,
        exerciseId: String,
        setType: SetType,
        workoutIndex: Int
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.setType = setType
        self.workoutIndex = workoutIndex
    }
}

final class ActivityManager {
    static let shared = ActivityManager()
    private init() {}
    
    private let activityCollection = Firestore.firestore().collection("activities")
}
