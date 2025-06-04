//
//  ExerciseManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation
import FirebaseFirestore
import SwiftData

struct APIExerciseArray: Codable {
    let exercises: [APIExercise]
    let total, skip, limit: Int
}

@Model
class DevExercise {
    @Attribute(.unique) var id: String?
    var name: String
    var bodyPart: String
    var equipment: String
    var target: String
    var secondaryMuscles: [String]
    var instructions: [String]
    var gifUrl: String
    
    init(
        id: String? = nil,
        name: String,
        bodyPart: String,
        equipment: String,
        target: String,
        secondaryMuscles: [String],
        instructions: [String],
        gifUrl: String
    ) {
        self.id = id
        self.name = name
        self.bodyPart = bodyPart
        self.equipment = equipment
        self.target = target
        self.secondaryMuscles = secondaryMuscles
        self.instructions = instructions
        self.gifUrl = gifUrl
    }
}

struct APIExercise: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let bodyPart: String
    let equipment: String
    let target: String
    let secondaryMuscles: [String]
    let instructions: [String]
    let gifUrl: String
    let uuid: String
    let setType: SetType
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bodyPart
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
    
    private func getAllExercises() async throws -> [APIExercise] {
        try await exercisesCollection
            .whereField("uuid", in: [AuthenticationManager.shared.getAuthenticatedUser().uid, "global"])
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesByUser(userIds: [String]) async throws -> [APIExercise] {
        try await exercisesCollection
            .whereField("uuid", in: userIds)
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesByUserSorted(userIds: [String], descending: Bool) async throws -> [APIExercise] {
        try await exercisesCollection
            .order(by: APIExercise.CodingKeys.name.rawValue, descending: descending)
            .whereField("uuid", in: userIds)
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesByUserCategorized(userIds: [String], category: String) async throws -> [APIExercise] {
        try await exercisesCollection
            .whereField("uuid", in: userIds)
            .whereField(APIExercise.CodingKeys.target.rawValue, isEqualTo: category)
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesSortedByName(descending: Bool) async throws -> [APIExercise] {
        try await exercisesCollection
            .order(by: APIExercise.CodingKeys.name.rawValue, descending: descending)
            .whereField("uuid", in: [AuthenticationManager.shared.getAuthenticatedUser().uid, "global"])
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesForCategory(category: String) async throws -> [APIExercise] {
        try await exercisesCollection
            .whereField("uuid", in: [AuthenticationManager.shared.getAuthenticatedUser().uid, "global"])
            .whereField(APIExercise.CodingKeys.target.rawValue, isEqualTo: category)
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesByNameAndCategory(descending: Bool, category: String) async throws -> [APIExercise] {
        try await exercisesCollection
            .order(by: APIExercise.CodingKeys.name.rawValue, descending: descending)
            .whereField("uuid", in: [AuthenticationManager.shared.getAuthenticatedUser().uid, "global"])
            .whereField(APIExercise.CodingKeys.target.rawValue, isEqualTo: category)
            .getDocuments(as: APIExercise.self)
    }
    
    private func getAllExercisesByNameCategoryUser(descending: Bool, category: String, userIds: [String]) async throws -> [APIExercise] {
        try await exercisesCollection
            .order(by: APIExercise.CodingKeys.name.rawValue, descending: descending)
            .whereField("uuid", in: userIds)
            .whereField(APIExercise.CodingKeys.target.rawValue, isEqualTo: category)
            .getDocuments(as: APIExercise.self)
    }
    
    func removeUserExercise(userId: String, exercise: APIExercise) async throws {
        guard let exerciseId = exercise.id else {
            return
        }
        
        if exercise.uuid == userId {
            try await exerciseDocument(exerciseId: exerciseId).delete()
        }
    }
    
    func getAllExercises(
        nameDescending descending: Bool?,
        forCategory category: String?,
        userIds: [String]?
    ) async throws -> [APIExercise] {
        if let userIds, let descending, let category {
            return try await getAllExercisesByNameCategoryUser(descending: descending, category: category, userIds: userIds)
        } else if let userIds, let descending {
            return try await getAllExercisesByUserSorted(userIds: userIds, descending: descending)
        } else if let userIds, let category {
            return try await getAllExercisesByUserCategorized(userIds: userIds, category: category)
        } else if let userIds {
            return try await getAllExercisesByUser(userIds: userIds)
        }
        
        if let category {
            if category == ExercisesViewModel.CategoryOption.noCategory.rawValue {
                if let descending {
                    return try await getAllExercisesSortedByName(descending: descending)
                } else {
                    return try await getAllExercises()
                }
            }
        }
        
        if let descending, let category {
            return try await getAllExercisesByNameAndCategory(descending: descending, category: category)
        } else if let descending {
            return try await getAllExercisesSortedByName(descending: descending)
        } else if let category {
            return try await getAllExercisesForCategory(category: category)
        } else {
            return try await getAllExercises()
        }
    }
}

extension FirebaseFirestore.Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
//        var exercises: [T] = []
//        
//        for document in snapshot.documents {
//            let exercise = try document.data(as: T.self)
//            exercises.append(exercise)
//        }
//        
//        return exercises
        
        // This code is equivalent to the above commented out code
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
}
