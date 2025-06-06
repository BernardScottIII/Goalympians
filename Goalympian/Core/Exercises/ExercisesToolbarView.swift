//
//  ExercisesToolbarView.swift
//  Goalympian
//
//  Created by Bernard Scott on 6/4/25.
//

import SwiftUI
import FirebaseFirestore

struct ExercisesToolbarViewModifier: ViewModifier {
    @ObservedObject var viewModel: ExercisesViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")", systemImage: "arrow.up.arrow.down") {
                        ForEach(FilterOption.allCases, id: \.self) { option in
                            Button(option.prettyString) {
                                Task {
                                    try? await viewModel.filterSelectedOption(option: option)
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")", systemImage: "figure.strengthtraining.traditional") {
                        ForEach(CategoryOption.allCases, id: \.self) { option in
                            Button(option.prettyString) {
                                Task {
                                    try? await viewModel.categorySelected(category: option)
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Equipment: \(viewModel.selectedEquipment?.rawValue ?? "NONE")", systemImage: "dumbbell.fill") {
                        ForEach(EquipmentOption.allCases, id: \.self) { option in
                            Button(option.prettyString) {
                                Task {
                                    try? await viewModel.filterEquipmentOption(equipment: option)
                                }
                            }
                        }
                    }
                }
            }
    }
}

extension View {
    func withExercisesToolbar(viewModel: ExercisesViewModel) -> some View {
        modifier(ExercisesToolbarViewModifier(viewModel: viewModel))
    }
}

#Preview {
    @Previewable @State var viewModel = ExercisesViewModel(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
    NavigationStack {
        EmptyView()
            .withExercisesToolbar(viewModel: viewModel)
    }
}
