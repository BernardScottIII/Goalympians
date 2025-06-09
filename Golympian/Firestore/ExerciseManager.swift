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

struct APIExercise: Identifiable, Codable {
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

enum CategoryOption: String, Codable, CaseIterable {
    case noCategory, abductor, abs, adductors, biceps, calves, cardiovascularSystem, delts, forearms, glutes, hamstrings, lats, levatorScapulae, pectorals, quads, serratusAnterior, spine, traps, triceps, upperBack
    
    var prettyString: String {
        switch self {
        case .noCategory: return "All Muscles"
        case .abductor: return "Abductor"
        case .abs: return "Abdominals/Core"
        case .adductors: return "Adductors"
        case .biceps: return "Biceps"
        case .calves: return "Calves"
        case .cardiovascularSystem: return "Cardio/Heart"
        case .delts: return "Deltoids"
        case .forearms: return "Forearms"
        case .glutes: return "Gluteal Muscles"
        case .hamstrings: return "Hamstrings"
        case .lats: return "Latissimus Dorsi"
        case .levatorScapulae: return "Levator Scapulae (Neck)"
        case .pectorals: return "Pectorals (Chest)"
        case .quads: return "Quadriceps"
        case .serratusAnterior: return "Serratus Anterior"
        case .spine: return "Spine (Lower Back)"
        case .traps: return "Trapezius"
        case .triceps: return "Triceps"
        case .upperBack: return "Upper Back"
        }
    }
}

enum EquipmentOption: String, Codable, CaseIterable {
    case noEquipment, assisted, band, barbell, bodyWeight, bosuBall, cable, dumbbell, ellipticalMachine, ezBarbell, hammer, kettlebell, leverageMachine, medicineBall, olympicBarbell, resistanceBand, roller, rope, skiergMachine, sledMachine, smithMachine, stabilityBall, stationaryBike, stepmillMachine, tire, trapBar, upperBodyErgometer, weighted, wheelRoller, customEquipment
    
    var prettyString: String {
        switch self{
        case .assisted: return "Weight Assisted"
        case .band: return "Band"
        case .barbell: return "Barbell"
        case .bodyWeight: return "Body Weight"
        case .bosuBall: return "Bosu Ball"
        case .cable: return "Cable (Machine)"
        case .dumbbell: return "Dumbbell"
        case .ellipticalMachine: return "Elliptical Machine"
        case .ezBarbell: return "EZ Barbell"
        case .hammer: return "Hammer"
        case .kettlebell: return "Kettlebell"
        case .leverageMachine: return "Leverage Machine"
        case .medicineBall: return "Medicine Ball"
        case .olympicBarbell: return "Olympic Barbell"
        case .resistanceBand: return "Resistance Band"
        case .roller: return "Roller"
        case .rope: return "Rope"
        case .skiergMachine: return "Skierg Machine"
        case .sledMachine: return "Sled Machine"
        case .smithMachine: return "Smith Machine"
        case .stabilityBall: return "Stability Ball"
        case .stationaryBike: return "Stationary Bike"
        case .stepmillMachine: return "Stepmill Machine"
        case .tire: return "Tire"
        case .trapBar: return "Trap Bar"
        case .upperBodyErgometer: return "Upper Body Ergometer"
        case .weighted: return "Weighted"
        case .wheelRoller: return "Wheel Roller"
        case .customEquipment: return "Special/Custom Equipment"
        case .noEquipment: return "No Equipment"
        }
    }
}

enum FilterOption: String, CaseIterable {
    case noFilter
    case nameAscending
    case nameDescending
    
    var nameDescending: Bool? {
        switch self {
        case .noFilter: return nil
        case .nameAscending: return false
        case .nameDescending: return true
        }
    }
    
    var prettyString: String {
        switch self {
        case .noFilter: return "Unsorted"
        case .nameAscending: return "Alphabetical"
        case .nameDescending: return "Reverse Alphabetical"
        }
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
            result = result.whereField(APIExercise.CodingKeys.target.rawValue, isEqualTo: category)
        }
        
        if let equipment = equipment {
            result = result.whereField(APIExercise.CodingKeys.equipment.rawValue, isEqualTo: equipment)
        }
        
        if let uuids = uuids {
            result = result.whereField(APIExercise.CodingKeys.uuid.rawValue, in: uuids)
        }
        
        return try await result.getDocuments(as: APIExercise.self)
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
