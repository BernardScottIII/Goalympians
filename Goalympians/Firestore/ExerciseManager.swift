//
//  ExerciseManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation
import FirebaseFirestore

struct DBExerciseArray: Codable {
    let exercises: [DBExercise]
    let total, skip, limit: Int
}

struct DBExercise: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
    let userId: String
}

final class ExerciseManager {
    static let shared = ExerciseManager()
    private init() {}
    
    private let exercisesCollection = Firestore.firestore().collection("exercises")
    
    private func exerciseDocument(exerciseId: String) -> DocumentReference {
        exercisesCollection.document(exerciseId)
    }
    
    func uploadExercise(exercise: DBExercise) async throws {
        try exerciseDocument(exerciseId: String(exercise.id)).setData(from: exercise, merge: false)
    }
    
    func getExercise(exerciseId: String) async throws -> DBExercise {
        try await exerciseDocument(exerciseId: exerciseId).getDocument(as: DBExercise.self)
    }
    
    func getAllExercises() async throws -> [DBExercise] {
        try await exercisesCollection.getDocument(as: DBExercise.self)
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
