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
    
    let workoutDataService: WorkoutManagerProtocol
    @Binding var showSignInView: Bool
    
    @StateObject private var workoutViewModel: WorkoutViewModel
    @StateObject private var activityViewModel: ActivityViewModel
    
    @State private var selectedTab: TabbarTab = .workouts
    @State private var previousTab: TabbarTab = .workouts
    
    @State private var workoutNavigationPath = NavigationPath()
    @State private var insightNavigationPath = NavigationPath()
    @State private var profileNavigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Workouts", systemImage: "dumbbell", value: .workouts) {
                NavigationStack(path: $workoutNavigationPath) {
                    WorkoutView(viewModel: workoutViewModel)
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line", value: .insights) {
                NavigationStack(path: $insightNavigationPath) {
                    InsightsView(activityViewModel: activityViewModel)
                }
            }
            
            Tab("Profile", systemImage: "person", value: .profile) {
                NavigationStack(path: $profileNavigationPath) {
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
        .onChange(of: selectedTab) {
            if selectedTab == .workouts { workoutNavigationPath = NavigationPath() }
            if selectedTab == .insights { insightNavigationPath = NavigationPath() }
            if selectedTab == .profile { profileNavigationPath = NavigationPath() }
        }
    }
    
    init(
        workoutDataService: WorkoutManagerProtocol,
        showSignInView: Binding<Bool>
    ) {
        _workoutViewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
        _showSignInView = showSignInView
        
        self.workoutDataService = workoutDataService
    }
}

struct OldTabbarView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    @Binding var showSignInView: Bool
    let workoutDataService: WorkoutManagerProtocol
    @StateObject private var workoutViewModel: WorkoutViewModel
    @StateObject private var activityViewModel: ActivityViewModel
    
    enum TabbarTab: Hashable {
        case workouts, insights, profile
    }
    
    @State private var selectedTab: TabbarTab = .workouts
    
    @State var workoutNavigationPath = NavigationPath()
    @State var insightNavigationPath = NavigationPath()
    @State var profileNavigationPath = NavigationPath()
    
    init(workoutDataService: WorkoutManagerProtocol, showSignInView: Binding<Bool>) {
        _workoutViewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: workoutDataService))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: workoutDataService))
        self.workoutDataService = workoutDataService
        _showSignInView = showSignInView
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Workouts", systemImage: "dumbbell", value: .workouts) {
                NavigationStack(path: $workoutNavigationPath) {
                    WorkoutView(viewModel: workoutViewModel)
                }
            }//.tag(TabbarTab.workouts)
            
            Tab("Insights", systemImage: "chart.xyaxis.line", value: .insights) {
                NavigationStack(path: $insightNavigationPath) {
                    InsightsView(activityViewModel: activityViewModel)
                        .environmentObject(healthManager)
                }
            }//.tag(TabbarTab.insights)
            
            Tab("Profile", systemImage: "person", value: .profile) {
                NavigationStack(path: $profileNavigationPath) {
                    ProfileView(showSignInView: $showSignInView)
                }
            }//.tag(TabbarTab.profile)
        }
        .onChange(of: selectedTab) {
            if selectedTab != .workouts { workoutNavigationPath = NavigationPath() }
            if selectedTab != .insights { insightNavigationPath = NavigationPath() }
            if selectedTab != .profile { profileNavigationPath = NavigationPath() }
        }
    }
}

#Preview {
//    TabbarView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), showSignInView: .constant(false))
    TabbarView(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")), showSignInView: .constant(false))
}
