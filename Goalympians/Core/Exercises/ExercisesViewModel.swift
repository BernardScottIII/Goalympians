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
    
//    func getAllExercises() async throws {
//        self.exercises = try await ExerciseManager.shared.getAllExercises()
//    }
    
    func addWorkoutActivity(workoutId: String, exerciseId: String) {
        Task {
            try await dataService.addWorkoutActivity(workoutId: workoutId, exerciseId: exerciseId)
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
    }
    
    func filterSelectedOption(option: FilterOption) async throws {
        self.selectedFilter = option
        self.getExercises()
    }
    
    enum CategoryOption: String, CaseIterable {
        case abductor, abs, adductors, biceps, calves, cardiovascularSystem, delts, forearms, glutes, hamstrings, lats, levatorScapulae, pectorals, quads, serratusAnterior, spine, traps, triceps, upperBack, noCategory
    }
    
    enum EquipmentOption: String, CaseIterable {
        case assisted, band, barbell, bodyWeight, bosuBall, cable, dumbbell, ellipticalMachine, ezBarbell, hammer, kettlebell, leverageMachine, medicineBall, olympicBarbell, resistanceBand, roller, rope, skiergMachine, sledMachine, smithMachine, stabilityBall, stationaryBike, stepmillMachine, tire, trapBar, upperBodyErgometer, weighted, wheelRoller, customEquipment, noEquipment
    }
    
    func categorySelected(category: CategoryOption) async throws {
        self.selectedCategory = category
        self.getExercises()
    }
    
    func getExercises() {
        Task {
            self.exercises = try await ExerciseManager.shared.getAllExercises(nameDescending: selectedFilter?.nameDescending, forCategory: selectedCategory?.rawValue)
        }
    }
}
