//
//  DBExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/22/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct UserExerciseListView: View {
    @StateObject var viewModel: ExercisesViewModel
    var workoutDataService: WorkoutManagerProtocol
    var userId: String
    
    init(
        viewModel: ExercisesViewModel,
        userId: String,
        workoutDataService: WorkoutManagerProtocol
    ) {
        _viewModel = StateObject(wrappedValue: ExercisesViewModel(dataService: workoutDataService))
        self.userId = userId
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        List(viewModel.exercises, id: \.id) { exercise in
            HStack {
                Text(exercise.name)
                
                Spacer()
                
                ZStack(alignment: .trailing) {
                    NavigationLink {
                        ExerciseDetailsView(exercise: exercise)
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.blue)
                    }
                    .scaledToFit()
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            Task {
                try await viewModel.userIdsSelected(userIds: [userId])
            }
        }
    }
}

#Preview {
    @Previewable let dataService: WorkoutManagerProtocol = Firestore.firestore().collection("workouts") as! WorkoutManagerProtocol
    NavigationStack {
        UserExerciseListView(viewModel: ExercisesViewModel(dataService: dataService), userId: UUID().uuidString, workoutDataService: dataService)
    }
}
