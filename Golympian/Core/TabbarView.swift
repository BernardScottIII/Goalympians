//
//  ContentView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/3/25.
//

import SwiftUI
import FirebaseFirestore

struct TabbarView: View {
    enum TabbarTab: Hashable {
        case workouts, insights, profile
    }
    
    @State private var selectedTab: TabbarTab = .workouts
    
    @State private var workoutNavigationPath = NavigationPath()
    @State private var insightNavigationPath = NavigationPath()
    @State private var profileNavigationPath = NavigationPath()
    
    @Binding var showSignInView: Bool
    let workoutDataService: WorkoutManagerProtocol
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        showSignInView: Binding<Bool>
    ) {
        _showSignInView = showSignInView
        self.workoutDataService = workoutDataService
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Workouts", systemImage: "dumbbell", value: .workouts) {
                NavigationStack(path: $workoutNavigationPath) {
//                    WorkoutsView(workoutDataService: workoutDataService)
                    UserWorkoutsView(workoutDataService: workoutDataService)
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line", value: .insights) {
                NavigationStack(path: $insightNavigationPath) {
                    InsightsView(showSignInView: $showSignInView)
                }
            }
            
            Tab("Profile", systemImage: "person", value: .profile) {
                NavigationStack(path: $profileNavigationPath) {
                    ProfileView(showSignInView: $showSignInView, workoutDataService: workoutDataService)
                }
            }
        }
        .onChange(of: selectedTab) {
            if selectedTab == .workouts { workoutNavigationPath = NavigationPath() }
            if selectedTab == .insights { insightNavigationPath = NavigationPath() }
            if selectedTab == .profile { profileNavigationPath = NavigationPath() }
        }
    }
}

#Preview {
    TabbarView(
        workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")),
        showSignInView: .constant(false)
    )
}
