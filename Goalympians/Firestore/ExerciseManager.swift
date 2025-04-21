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

//struct DBExercise: Identifiable, Codable {
//    let id: Int
//    let name: String
//    let type: String
//    let muscle: String
//    let equipment: String
//    let difficulty: String
//    let instructions: String
//    let userId: String
//}

struct APIExercise: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let bodyPart: String
    let equipment: String
    let target: String
    let secondaryMuscles: [String]
    let instructions: [String]
    let gifUrl: String
}

final class ExerciseManager {
    static let shared = ExerciseManager()
    private init() {}
    
    private let exercisesCollection = Firestore.firestore().collection("exercises")
    
    private func exerciseDocument(exerciseId: String) -> DocumentReference {
        exercisesCollection.document(exerciseId)
    }
    
//    func uploadExercise(exercise: DBExercise) async throws {
//        try exerciseDocument(exerciseId: String(exercise.id)).setData(from: exercise, merge: false)
//    }
    func uploadExercise(exercise: APIExercise) async throws {
        try exerciseDocument(exerciseId: exercise.id!).setData(from: exercise, merge: false)
    }
    
    func uploadAPIExercise(apiExercise: APIExercise) async throws {
        try exerciseDocument(exerciseId: apiExercise.id!).setData(from: apiExercise, merge: false)
    }
    
    func getExercise(exerciseId: String) async throws -> APIExercise {
        try await exerciseDocument(exerciseId: exerciseId).getDocument(as: APIExercise.self)
    }
    
    func getAllExercises() async throws -> [APIExercise] {
        try await exercisesCollection.getDocument(as: APIExercise.self)
    }
}

extension Query {
    func getDocument<T>(as type: T.Type) async throws -> [T] where T : Decodable {
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
