//
//  WorkoutsView.swift
//  Golympian
//
//  Created by Bernard Scott on 6/19/25.
//

import SwiftUI
import FirebaseFirestore

struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutViewModel
    @State private var pickerSelection: String = "My Workouts"
    private let screens = ["My Workouts", "Shared with Me"]
    
    let workoutDataService: WorkoutManagerProtocol
    
    init(
        workoutDataService: WorkoutManagerProtocol
    ) {
        self.workoutDataService = workoutDataService
        _viewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
    }
    
    var body: some View {
        Picker("", selection: $pickerSelection) {
            ForEach(screens, id: \.self) { screen in
                Text(screen)
            }
        }
        .padding()
        .pickerStyle(.palette)
        .navigationTitle("Workouts")
        
        switch pickerSelection {
        case "My Workouts":
//            UserWorkoutsView(viewModel: viewModel)
            Text("Call to UserWorkoutsView() goes here!")
        case "Shared with Me":
            SharedWorkoutsView()
        default:
            Text("Unknown")
        }
    }
}

#Preview {
    let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        WorkoutsView(workoutDataService: dataService)
    }
}
