//
//  UserManager+WorkoutInsights.swift
//  Golympian
//
//  Created by Bernard Scott on 6/21/25.
//

import Foundation
import FirebaseFirestore

struct WorkoutInsight: Codable {
    let id: String
    let date: Date
    let workoutCount: Int
    let totalSets: Int
    let totalWeight: Double
    let totalRepetitions: Int
    let totalRunSetDistance: Double
    let totalRunSetDuration: Double
    let totalSwimSetDistance: Double
    let totalSwimSetDuration: Double
    let totalLaps: Int
    let totalElevation: Double
    let exerciseIdMostWeight: String
    let highestWeight: Double
    let exerciseIdMostActivities: String
    let exerciseOccurrenceCounts: [String: Int]
    let exerciseIdMostLaps: String
    let highestLaps: Int
    let exerciseIdMostDistance: String
    let highestDistance: Double
    let exerciseIdMostElevation: String
    let highestElevation: Double
    let exerciseIdMostDuration: String
    let highestDuration: Double
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "id"
        case date = "date"
        case workoutCount = "workout_count"
        case totalSets = "total_sets"
        case totalWeight = "total_weight"
        case totalRepetitions = "total_repetitions"
        case totalRunSetDistance = "total_run_set_distance"
        case totalRunSetDuration = "total_run_set_duration"
        case totalSwimSetDistance = "total_swim_set_distance"
        case totalSwimSetDuration = "total_swim_set_duration"
        case totalLaps = "total_laps"
        case totalElevation = "total_elevation"
        case exerciseIdMostWeight = "exercise_id_most_weight"
        case highestWeight = "highest_weight"
        case exerciseIdMostActivities = "exercise_id_most_activities"
        case exerciseOccurrenceCounts = "exercise_occurrence_counts"
        case exerciseIdMostLaps = "exercise_id_most_laps"
        case highestLaps = "highest_laps"
        case exerciseIdMostDistance = "exercise_id_most_distance"
        case highestDistance = "highest_distance"
        case exerciseIdMostElevation = "exercise_id_most_elevation"
        case highestElevation = "highest_elevation"
        case exerciseIdMostDuration = "exercise_id_most_duration"
        case highestDuration = "highest_duration"
    }
    
    init(
        id: String,
        date: Date,
        workoutCount: Int = 0,
        totalSets: Int = 0,
        totalWeight: Double = 0.0,
        totalRepetitions: Int = 0,
        totalRunSetDistance: Double = 0.0,
        totalRunSetDuration: Double = 0.0,
        totalSwimSetDistance: Double = 0.0,
        totalSwimSetDuration: Double = 0.0,
        totalLaps: Int = 0,
        totalElevation: Double = 0.0,
        exerciseIdMostWeight: String = "",
        highestWeight: Double = 0.0,
        exerciseIdMostActivities: String = "",
        exerciseOccurrenceCounts: [String : Int] = [:],
        exerciseIdMostLaps: String = "",
        highestLaps: Int = 0,
        exerciseIdMostDistance: String = "",
        highestDistance: Double = 0.0,
        exerciseIdMostElevation: String = "",
        highestElevation: Double = 0.0,
        exerciseIdMostDuration: String = "",
        highestDuration: Double = 0.0
    ) {
        self.id = id
        self.date = date
        self.workoutCount = workoutCount
        self.totalSets = totalSets
        self.totalWeight = totalWeight
        self.totalRepetitions = totalRepetitions
        self.totalRunSetDistance = totalRunSetDistance
        self.totalRunSetDuration = totalRunSetDuration
        self.totalSwimSetDistance = totalSwimSetDistance
        self.totalSwimSetDuration = totalSwimSetDuration
        self.totalLaps = totalLaps
        self.totalElevation = totalElevation
        self.exerciseIdMostWeight = exerciseIdMostWeight
        self.highestWeight = highestWeight
        self.exerciseIdMostActivities = exerciseIdMostActivities
        self.exerciseOccurrenceCounts = exerciseOccurrenceCounts
        self.exerciseIdMostLaps = exerciseIdMostLaps
        self.highestLaps = highestLaps
        self.exerciseIdMostDistance = exerciseIdMostDistance
        self.highestDistance = highestDistance
        self.exerciseIdMostElevation = exerciseIdMostElevation
        self.highestElevation = highestElevation
        self.exerciseIdMostDuration = exerciseIdMostDuration
        self.highestDuration = highestDuration
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.workoutCount = try container.decode(Int.self, forKey: .workoutCount)
        self.totalSets = try container.decode(Int.self, forKey: .totalSets)
        self.totalWeight = try container.decode(Double.self, forKey: .totalWeight)
        self.totalRepetitions = try container.decode(Int.self, forKey: .totalRepetitions)
        self.totalRunSetDistance = try container.decode(Double.self, forKey: .totalRunSetDistance)
        self.totalRunSetDuration = try container.decode(Double.self, forKey: .totalRunSetDuration)
        self.totalSwimSetDistance = try container.decode(Double.self, forKey: .totalSwimSetDistance)
        self.totalSwimSetDuration = try container.decode(Double.self, forKey: .totalSwimSetDuration)
        self.totalLaps = try container.decode(Int.self, forKey: .totalLaps)
        self.totalElevation = try container.decode(Double.self, forKey: .totalElevation)
        self.exerciseIdMostWeight = try container.decode(String.self, forKey: .exerciseIdMostWeight)
        self.highestWeight = try container.decode(Double.self, forKey: .highestWeight)
        self.exerciseIdMostActivities = try container.decode(String.self, forKey: .exerciseIdMostActivities)
        self.exerciseOccurrenceCounts = try container.decode([String : Int].self, forKey: .exerciseOccurrenceCounts)
        self.exerciseIdMostLaps = try container.decode(String.self, forKey: .exerciseIdMostLaps)
        self.highestLaps = try container.decode(Int.self, forKey: .highestLaps)
        self.exerciseIdMostDistance = try container.decode(String.self, forKey: .exerciseIdMostDistance)
        self.highestDistance = try container.decode(Double.self, forKey: .highestDistance)
        self.exerciseIdMostElevation = try container.decode(String.self, forKey: .exerciseIdMostElevation)
        self.highestElevation = try container.decode(Double.self, forKey: .highestElevation)
        self.exerciseIdMostDuration = try container.decode(String.self, forKey: .exerciseIdMostDuration)
        self.highestDuration = try container.decode(Double.self, forKey: .highestDuration)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.workoutCount, forKey: .workoutCount)
        try container.encode(self.totalSets, forKey: .totalSets)
        try container.encode(self.totalWeight, forKey: .totalWeight)
        try container.encode(self.totalRepetitions, forKey: .totalRepetitions)
        try container.encode(self.totalRunSetDistance, forKey: .totalRunSetDistance)
        try container.encode(self.totalRunSetDuration, forKey: .totalRunSetDuration)
        try container.encode(self.totalSwimSetDistance, forKey: .totalSwimSetDistance)
        try container.encode(self.totalSwimSetDuration, forKey: .totalSwimSetDuration)
        try container.encode(self.totalLaps, forKey: .totalLaps)
        try container.encode(self.totalElevation, forKey: .totalElevation)
        try container.encode(self.exerciseIdMostWeight, forKey: .exerciseIdMostWeight)
        try container.encode(self.highestWeight, forKey: .highestWeight)
        try container.encode(self.exerciseIdMostActivities, forKey: .exerciseIdMostActivities)
        try container.encode(self.exerciseOccurrenceCounts, forKey: .exerciseOccurrenceCounts)
        try container.encode(self.exerciseIdMostLaps, forKey: .exerciseIdMostLaps)
        try container.encode(self.highestLaps, forKey: .highestLaps)
        try container.encode(self.exerciseIdMostDistance, forKey: .exerciseIdMostDistance)
        try container.encode(self.highestDistance, forKey: .highestDistance)
        try container.encode(self.exerciseIdMostElevation, forKey: .exerciseIdMostElevation)
        try container.encode(self.highestElevation, forKey: .highestElevation)
        try container.encode(self.exerciseIdMostDuration, forKey: .exerciseIdMostDuration)
        try container.encode(self.highestDuration, forKey: .highestDuration)
    }
}

extension UserManager {
    private func userWorkoutInsightCollection(userId: String) -> CollectionReference {
        Firestore.firestore().collection("users").document(userId).collection("workout_insights")
    }
    
    private func userWorkoutInsightDocument(userId: String, insightId: String) -> DocumentReference {
        userWorkoutInsightCollection(userId: userId).document(insightId)
    }
    
    func initUserWorkoutInsights(userId: String) async throws {
        let document = userWorkoutInsightCollection(userId: userId).document()
        let documentId = document.documentID
        
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        
        // Leaving all other dateComponents nil will set them to default values,
        // which is desireable when trying to get the first of the current month
        let newInsight = WorkoutInsight(
            id: documentId,
            date: Calendar.current.date(from: components)!
        )
        
        try document.setData(from: newInsight, merge: false)
    }
}

