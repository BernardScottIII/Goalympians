//
//  ExercisesToolbarView.swift
//  Goalympian
//
//  Created by Bernard Scott on 6/4/25.
//

import SwiftUI
import FirebaseFirestore

struct ExercisesToolbarViewModifier: ViewModifier {
    @State private var showMuscleOptionSheet: Bool = false
    @State private var selectedMuscle: MuscleOption = .allMuscles
    @State private var showEquipmentOptionSheet: Bool = false
    @State private var selectedEquipment: EquipmentOption = .noEquipment
    
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
                    Button {
                        showMuscleOptionSheet = true
                    } label: {
                        Image(systemName: "figure.strengthtraining.traditional")
                    }
                    .sheet(isPresented: $showMuscleOptionSheet) {
                        MuscleOptionMenuView(selection: $selectedMuscle, isPresented: $showMuscleOptionSheet)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEquipmentOptionSheet = true
                    } label: {
                        Image(systemName: "dumbbell.fill")
                    }
                    .sheet(isPresented: $showEquipmentOptionSheet) {
                        EquipmentOptionMenuView(selection: $selectedEquipment, isPresented: $showEquipmentOptionSheet)
                    }
                }
            }
            .onChange(of: selectedMuscle) {
                Task {
                    try? await viewModel.muscleSelected(muscle: selectedMuscle)
                }
            }
            .onChange(of: selectedEquipment) {
                Task {
                    try? await viewModel.filterEquipmentOption(equipment: selectedEquipment)
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
