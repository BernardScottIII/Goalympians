//
//  ExerciseManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation
import FirebaseFirestore

struct APIExerciseArray: Codable {
    let exercises: [APIExercise]
    let total, skip, limit: Int
}

struct APIExercise: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let equipment: String // Not EquipmentOption to allow for custom user input
    let target: CategoryOption
    let secondaryMuscles: [String]
    let instructions: [String]
    let gifUrl: String
    let uuid: String
    let setType: SetType
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case equipment
        case target
        case secondaryMuscles
        case instructions
        case gifUrl
        case uuid
        case setType
    }
}

final class ExerciseManager {
    static let shared = ExerciseManager()
    private init() {}
    
    private let exercisesCollection = Firestore.firestore().collection("exercises")
    
    private func exerciseDocument(exerciseId: String) -> DocumentReference {
        exercisesCollection.document(exerciseId)
    }
    
    func uploadExercise(exercise: APIExercise) async throws {
        try exerciseDocument(exerciseId: exercise.id!).setData(from: exercise, merge: false)
    }
    
    func uploadAPIExercise(apiExercise: APIExercise) async throws {
        try exerciseDocument(exerciseId: apiExercise.id!).setData(from: apiExercise, merge: false)
    }
    
    func getExercise(exerciseId: String) async throws -> APIExercise {
        try await exerciseDocument(exerciseId: exerciseId).getDocument(as: APIExercise.self)
    }
    
    func removeUserExercise(userId: String, exercise: APIExercise) async throws {
        guard let exerciseId = exercise.id else {
            return
        }
        
        if exercise.uuid == userId {
            try await exerciseDocument(exerciseId: exerciseId).delete()
        }
    }
    
    // Why should public functions act as wrappers for private functions if
    // they'd do the exact same thing?
    func getAllExercises(
        nameDescending descending: Bool?,
        forCategory category: String?,
        usingEquipment equipment: String?,
        uuids: [String]?
    ) async throws -> [APIExercise] {
        var result: Query = exercisesCollection
        
        if let descending = descending {
            result = result.order(by: APIExercise.CodingKeys.name.rawValue, descending: descending)
        }
        
        if let category = category {
            if category != CategoryOption.noCategory.rawValue {
                result = result.whereField(APIExercise.CodingKeys.target.rawValue, isEqualTo: category)
            }
        }
        
        if let equipment = equipment {
            if equipment != EquipmentOption.noEquipment.rawValue {
                result = result.whereField(APIExercise.CodingKeys.equipment.rawValue, isEqualTo: equipment)
            }
        }
        
        if let uuids = uuids {
            result = result.whereField(APIExercise.CodingKeys.uuid.rawValue, in: uuids)
        }
        
        return try await result.getDocuments(as: APIExercise.self)
    }
}
