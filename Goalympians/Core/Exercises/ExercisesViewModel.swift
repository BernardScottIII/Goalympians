//
//  ExercisesViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ExercisesViewModel: ObservableObject {
    
    @Published private(set) var exercises: [APIExercise] = []
    
//    func downloadProductsAndUploadToFirebase() {        
//        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises?limit=0") else { return }
//        
//        Task {
//            do {
//                var request = URLRequest(url: url)
//                request.addValue("c531d8c736mshbe3347fea1e86c5p1aac93jsneed777f556e9", forHTTPHeaderField: "x-rapidapi-key")
//                let (data, _) = try await URLSession.shared.data(for: request)
//                let exercises = try JSONDecoder().decode([APIExercise].self, from: data)
//                print(exercises)
//                
//                for exercise in exercises {
//                    try? await ExerciseManager.shared.uploadAPIExercise(apiExercise: exercise)
//                }
//                
//                print("SUCCESS")
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    func getAllExercises() async throws {
        self.exercises = try await ExerciseManager.shared.getAllExercises()
    }
    
    func addWorkoutActivity(workoutId: String, exerciseId: String) {
        Task {
            try await WorkoutManager.shared.addWorkoutActivity(workoutId: workoutId, exerciseId: exerciseId)
        }
    }
}
