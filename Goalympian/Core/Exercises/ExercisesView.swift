//
//  ExercisesView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/3/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct ExercisesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ExercisesViewModel
    @State private var targetMuscle = "Any Muscle"
    @State private var searchText = ""
    @State private var selectedExerciseId: String?
    
    @ObservedObject var activityViewModel: ActivityViewModel
    @State var navigationTitle: String
    let workoutDataService: WorkoutManagerProtocol
    let workoutId: String
    let userIds: [String]
    
    init(
        activityViewModel: ActivityViewModel,
        workoutDataService: WorkoutManagerProtocol,
        workoutId: String,
        userIds: [String],
        navigationTitle: String = "Exercises"
    ) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataService: workoutDataService))
        self.activityViewModel = activityViewModel
        self.workoutDataService = workoutDataService
        self.workoutId = workoutId
        self.userIds = userIds
        self.navigationTitle = navigationTitle
    }
    
    var body: some View {
        List(viewModel.exercises, id: \.id) { exercise in
            HStack {
                Text(exercise.name)
                
                Spacer()
                
                Button("", systemImage: "plus") {
                    if !activityViewModel.activities.contains(where: {$0.exercise.id == exercise.id}) {
                        viewModel.addWorkoutActivity(workoutId: workoutId, exercise: exercise)
                    } else {
                        guard let index = activityViewModel.activities.firstIndex(where: {$0.exercise.id == exercise.id}) else { return }
                        activityViewModel.addActivitySet(
                            workoutId: workoutId,
                            activityId: activityViewModel.activities[index].workoutActivity.id
                        )
                    }
                    dismiss()
                }
                
                // "It's good enough"
                ZStack(alignment: .trailing) {
                    NavigationLink {
                        ExerciseDetailsView(exercise: exercise)
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.blue)
                    }
                    .scaledToFit()
                }
            }
            .buttonStyle(.plain)
        }
        .navigationTitle(navigationTitle)
        .searchable(text: $searchText)
        .onAppear {
            Task {
                try await viewModel.userIdsSelected(userIds: userIds)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")", systemImage: "arrow.up.arrow.down") {
                    ForEach(ExercisesViewModel.FilterOption.allCases, id: \.self) { option in
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
                    ForEach(ExercisesViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.prettyString) {
                            Task {
                                try? await viewModel.categorySelected(category: option)
                            }
                        }
                    }
                }
            }
        }
        NavigationLink("Create New Exercise") {
            CreateExerciseView()
        }
    }
}

#Preview {
    @Previewable let workoutDataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        ExercisesView(activityViewModel: ActivityViewModel(dataService: workoutDataService), workoutDataService: workoutDataService, workoutId: "SampleId", userIds: [
            UUID().uuidString,
            "global"
        ])
    }
}
