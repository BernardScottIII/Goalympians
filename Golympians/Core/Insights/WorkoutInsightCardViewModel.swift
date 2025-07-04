//
//  WorkoutInsightCardViewModel.swift
//  Golympian
//
//  Created by Bernard Scott on 7/2/25.
//

//import Foundation
//
//@MainActor
//final class WorkoutInsightCardViewModel: ObservableObject {
//    @Published var exerciseCountsWithId: [String: Int] = [:]
//    
//    func getExerciseName(exerciseId: String) async throws -> String {
//        try await ExerciseManager.shared.getExercise(exerciseId: exerciseId).name
//    }
//    
//    func labelExerciseCounts(_ exerciseCounts: [String:Int]) async throws {
//        for (exerciseId, count) in exerciseCounts {
//            let exerciseName = try await getExerciseName(exerciseId: exerciseId)
//            exerciseCountsWithId[exerciseName] = count
//        }
//    }
//}
