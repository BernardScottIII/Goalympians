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
                            Button {
                                Task {
                                    try? await viewModel.filterSelectedOption(option: option)
                                }
                            } label: {
                                HStack {
                                    if viewModel.selectedFilter == option {
                                        Image(systemName: "checkmark")
                                    }
                                    Text(option.prettyString)
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")", systemImage: "figure.strengthtraining.traditional") {
                        ForEach(CategoryOption.allCases, id: \.self) { option in
                            Button {
                                Task {
                                    try? await viewModel.categorySelected(category: option)
                                }
                            } label: {
                                HStack {
                                    if viewModel.selectedCategory == option {
                                        Image(systemName: "checkmark")
                                    }
                                    Text(option.prettyString)
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Equipment: \(viewModel.selectedEquipment?.rawValue ?? "NONE")", systemImage: "dumbbell.fill") {
                        ForEach(EquipmentOption.allCases, id: \.self) { option in
                            Button {
                                Task {
                                    try? await viewModel.filterEquipmentOption(equipment: option)
                                }
                            } label: {
                                HStack {
                                    if viewModel.selectedEquipment == option {
                                        Image(systemName: "checkmark")
                                    }
                                    Text(option.prettyString)
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
