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
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    @Published var selectedEquipment: EquipmentOption? = nil
    @Published var userIds: [String]? = nil
    
    let dataService: WorkoutManagerProtocol
    
    init(dataService: WorkoutManagerProtocol) {
        self.dataService = dataService
    }
    
//    func downloadProductsAndUploadToFirebase() {        
////        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises?limit=0") else { return }
//        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises/targetList") else { return }
//        
//        Task {
//            do {
//                var request = URLRequest(url: url)
//                request.addValue("c531d8c736mshbe3347fea1e86c5p1aac93jsneed777f556e9", forHTTPHeaderField: "x-rapidapi-key")
//                let (data, _) = try await URLSession.shared.data(for: request)
////                let exercises = try JSONDecoder().decode([APIExercise].self, from: data)
////                print(exercises)
////                
////                for exercise in exercises {
////                    try? await ExerciseManager.shared.uploadAPIExercise(apiExercise: exercise)
////                }
//                let bodyParts = try JSONDecoder().decode([String].self, from: data)
//                print(bodyParts)
//                
////                for part in bodyParts {
////                    
////                }
//                
//                print("SUCCESS")
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    func addWorkoutActivity(workoutId: String, exercise: APIExercise) {
        Task {
            try await dataService.addWorkoutActivity(workoutId: workoutId, exercise: exercise)
        }
    }
    
    func filterSelectedOption(option: FilterOption) async throws {
        self.selectedFilter = option
        self.getExercises()
    }
    
    func filterEquipmentOption(equipment: EquipmentOption) async throws {
        self.selectedEquipment = equipment
        self.getExercises()
    }
    
    func categorySelected(category: CategoryOption) async throws {
        self.selectedCategory = category
        self.getExercises()
    }
    
    func userIdsSelected(userIds: [String]) async throws {
        self.userIds = userIds
        self.getExercises()
    }
    
    func getExercises() {
        Task {
            self.exercises = try await ExerciseManager.shared.getAllExercises(nameDescending: selectedFilter?.nameDescending, forCategory: selectedCategory?.rawValue, usingEquipment: selectedEquipment?.rawValue, uuids: userIds)
        }
    }
    
    func removeUserExercise(exercise: APIExercise) async throws {
        try await ExerciseManager.shared.removeUserExercise(userId: AuthenticationManager.shared.getAuthenticatedUser().uid, exercise: exercise)
    }
}
