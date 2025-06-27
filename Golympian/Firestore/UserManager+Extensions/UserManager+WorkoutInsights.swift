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
    let activityIdMostWeight: String
    let highestWeightValue: Double
    let highestWeightSetIndex: Int
    let exerciseIdMostActivities: String
    let exerciseOccurrenceCounts: [String: Int]
    let activityIdMostLaps: String
    let highestLapsValue: Int
    let highestLapsSetIndex: Int
    let activityIdMostRunDistance: String
    let activityIdMostSwimDistance: String
    let highestRunDistanceValue: Double
    let highestRunDistanceSetIndex: Int
    let highestSwimDistanceValue: Double
    let highestSwimDistancesetIndex: Int
    let activityIdMostElevation: String
    let highestElevationValue: Double
    let highestElevationSetIndex: Int
    let activityIdMostRunDuration: String
    let activityIdMostSwimDuration: String
    let highestRunDurationValue: Double
    let highestRunDurationSetIndex: Int
    let highestSwimDurationValue: Double
    let highestSwimDurationSetIndex: Int
    let activityIdMostRepetitions: String
    let highestRepetitionsValue: Int
    let highestRepetitionsSetIndex: Int
    
    init(
        id: String,
        date: Date,
    ) {
        self.id = id
        self.date = date
        self.workoutCount = 0
        self.totalSets = 0
        self.totalWeight = 0
        self.totalRepetitions = 0
        self.totalRunSetDistance = 0
        self.totalRunSetDuration = 0
        self.totalSwimSetDistance = 0
        self.totalSwimSetDuration = 0
        self.totalLaps = 0
        self.totalElevation = 0
        self.activityIdMostWeight = ""
        self.highestWeightValue = 0
        self.highestWeightSetIndex = 0
        self.exerciseIdMostActivities = ""
        self.exerciseOccurrenceCounts = [:]
        self.activityIdMostLaps = ""
        self.highestLapsValue = 0
        self.highestLapsSetIndex = 0
        self.activityIdMostRunDistance = ""
        self.activityIdMostSwimDistance = ""
        self.highestRunDistanceValue = 0
        self.highestRunDistanceSetIndex = 0
        self.highestSwimDistanceValue = 0
        self.highestSwimDistancesetIndex = 0
        self.activityIdMostElevation = ""
        self.highestElevationValue = 0
        self.highestElevationSetIndex = 0
        self.activityIdMostRunDuration = ""
        self.activityIdMostSwimDuration = ""
        self.highestRunDurationValue = 0
        self.highestRunDurationSetIndex = 0
        self.highestSwimDurationValue = 0
        self.highestSwimDurationSetIndex = 0
        self.activityIdMostRepetitions = ""
        self.highestRepetitionsValue = 0
        self.highestRepetitionsSetIndex = 0
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
        try container.encode(self.activityIdMostWeight, forKey: .activityIdMostWeight)
        try container.encode(self.highestWeightValue, forKey: .highestWeightValue)
        try container.encode(self.highestWeightSetIndex, forKey: .highestWeightSetIndex)
        try container.encode(self.exerciseIdMostActivities, forKey: .exerciseIdMostActivities)
        try container.encode(self.exerciseOccurrenceCounts, forKey: .exerciseOccurrenceCounts)
        try container.encode(self.activityIdMostLaps, forKey: .activityIdMostLaps)
        try container.encode(self.highestLapsValue, forKey: .highestLapsValue)
        try container.encode(self.highestLapsSetIndex, forKey: .highestLapsSetIndex)
        try container.encode(self.activityIdMostRunDistance, forKey: .activityIdMostRunDistance)
        try container.encode(self.activityIdMostSwimDistance, forKey: .activityIdMostSwimDistance)
        try container.encode(self.highestRunDistanceValue, forKey: .highestRunDistanceValue)
        try container.encode(self.highestRunDistanceSetIndex, forKey: .highestRunDistanceSetIndex)
        try container.encode(self.highestSwimDistanceValue, forKey: .highestSwimDistanceValue)
        try container.encode(self.highestSwimDistancesetIndex, forKey: .highestSwimDistancesetIndex)
        try container.encode(self.activityIdMostElevation, forKey: .activityIdMostElevation)
        try container.encode(self.highestElevationValue, forKey: .highestElevationValue)
        try container.encode(self.highestElevationSetIndex, forKey: .highestElevationSetIndex)
        try container.encode(self.activityIdMostRunDuration, forKey: .activityIdMostRunDuration)
        try container.encode(self.activityIdMostSwimDuration, forKey: .activityIdMostSwimDuration)
        try container.encode(self.highestRunDurationValue, forKey: .highestRunDurationValue)
        try container.encode(self.highestRunDurationSetIndex, forKey: .highestRunDurationSetIndex)
        try container.encode(self.highestSwimDurationValue, forKey: .highestSwimDurationValue)
        try container.encode(self.highestSwimDurationSetIndex, forKey: .highestSwimDurationSetIndex)
        try container.encode(self.activityIdMostRepetitions, forKey: .activityIdMostRepetitions)
        try container.encode(self.highestRepetitionsValue, forKey: .highestRepetitionsValue)
        try container.encode(self.highestRepetitionsSetIndex, forKey: .highestRepetitionsSetIndex)
    }
    
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
        case activityIdMostWeight = "activity_id_most_weight"
        case highestWeightValue = "highest_weight_value"
        case highestWeightSetIndex = "highest_weight_set_index"
        case exerciseIdMostActivities = "exercise_id_most_activities"
        case exerciseOccurrenceCounts = "exercise_occurrence_counts"
        case activityIdMostLaps = "activity_id_most_laps"
        case highestLapsValue = "highest_laps_value"
        case highestLapsSetIndex = "highest_laps_set_index"
        case activityIdMostRunDistance = "activity_id_most_run_distance"
        case activityIdMostSwimDistance = "activity_id_most_swim_distance"
        case highestRunDistanceValue = "highest_run_distance_value"
        case highestRunDistanceSetIndex = "highest_run_distance_set_index"
        case highestSwimDistanceValue = "highest_swim_distance_value"
        case highestSwimDistancesetIndex = "highest_swim_distance_set_index"
        case activityIdMostElevation = "activity_id_most_elevation"
        case highestElevationValue = "highest_elevation_value"
        case highestElevationSetIndex = "highest_elevation_set_index"
        case activityIdMostRunDuration = "activity_id_most_run_duration"
        case activityIdMostSwimDuration = "activity_id_most_swim_duration"
        case highestRunDurationValue = "highest_run_duration_value"
        case highestRunDurationSetIndex = "highest_run_duration_set_index"
        case highestSwimDurationValue = "highest_swim_duration_value"
        case highestSwimDurationSetIndex = "highest_swim_duration_set_index"
        case activityIdMostRepetitions = "activity_id_most_repetitions"
        case highestRepetitionsValue = "highest_repetitions_value"
        case highestRepetitionsSetIndex = "highest_repetitions_set_index"
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
        self.activityIdMostWeight = try container.decode(String.self, forKey: .activityIdMostWeight)
        self.highestWeightValue = try container.decode(Double.self, forKey: .highestWeightValue)
        self.highestWeightSetIndex = try container.decode(Int.self, forKey: .highestWeightSetIndex)
        self.exerciseIdMostActivities = try container.decode(String.self, forKey: .exerciseIdMostActivities)
        self.exerciseOccurrenceCounts = try container.decode([String : Int].self, forKey: .exerciseOccurrenceCounts)
        self.activityIdMostLaps = try container.decode(String.self, forKey: .activityIdMostLaps)
        self.highestLapsValue = try container.decode(Int.self, forKey: .highestLapsValue)
        self.highestLapsSetIndex = try container.decode(Int.self, forKey: .highestLapsSetIndex)
        self.activityIdMostRunDistance = try container.decode(String.self, forKey: .activityIdMostRunDistance)
        self.activityIdMostSwimDistance = try container.decode(String.self, forKey: .activityIdMostSwimDistance)
        self.highestRunDistanceValue = try container.decode(Double.self, forKey: .highestRunDistanceValue)
        self.highestRunDistanceSetIndex = try container.decode(Int.self, forKey: .highestRunDistanceSetIndex)
        self.highestSwimDistanceValue = try container.decode(Double.self, forKey: .highestSwimDistanceValue)
        self.highestSwimDistancesetIndex = try container.decode(Int.self, forKey: .highestSwimDistancesetIndex)
        self.activityIdMostElevation = try container.decode(String.self, forKey: .activityIdMostElevation)
        self.highestElevationValue = try container.decode(Double.self, forKey: .highestElevationValue)
        self.highestElevationSetIndex = try container.decode(Int.self, forKey: .highestElevationSetIndex)
        self.activityIdMostRunDuration = try container.decode(String.self, forKey: .activityIdMostRunDuration)
        self.activityIdMostSwimDuration = try container.decode(String.self, forKey: .activityIdMostSwimDuration)
        self.highestRunDurationValue = try container.decode(Double.self, forKey: .highestRunDurationValue)
        self.highestRunDurationSetIndex = try container.decode(Int.self, forKey: .highestRunDurationSetIndex)
        self.highestSwimDurationValue = try container.decode(Double.self, forKey: .highestSwimDurationValue)
        self.highestSwimDurationSetIndex = try container.decode(Int.self, forKey: .highestSwimDurationSetIndex)
        self.activityIdMostRepetitions = try container.decode(String.self, forKey: .activityIdMostRepetitions)
        self.highestRepetitionsValue = try container.decode(Int.self, forKey: .highestRepetitionsValue)
        self.highestRepetitionsSetIndex = try container.decode(Int.self, forKey: .highestRepetitionsSetIndex)
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

