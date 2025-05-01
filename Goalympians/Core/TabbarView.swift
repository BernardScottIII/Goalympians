//
//  ContentView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/3/25.
//

import SwiftUI
import FirebaseFirestore

struct TabbarView: View {
    @Binding var showSignInView: Bool
    let workoutDataService: WorkoutManagerProtocol
    @StateObject private var workoutViewModel: WorkoutViewModel
    @StateObject private var activityViewModel: ActivityViewModel
    
    init(workoutDataService: WorkoutManagerProtocol, showSignInView: Binding<Bool>) {
        _workoutViewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
        self.workoutDataService = workoutDataService
        _showSignInView = showSignInView
    }
    
    var body: some View {
        TabView {
            Tab("Workouts", systemImage: "dumbbell") {
                NavigationStack {
                    WorkoutView(viewModel: workoutViewModel)
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line") {
                NavigationStack {
                    InsightsView(workoutViewModel: workoutViewModel, activityViewModel: activityViewModel)
                }
            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
    }
}

#Preview {
    TabbarView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), showSignInView: .constant(false))
}
