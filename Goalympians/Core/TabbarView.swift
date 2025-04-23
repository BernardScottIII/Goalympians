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
    
    var body: some View {
        TabView {
            Tab("Workouts", systemImage: "dumbbell") {
                NavigationStack {
                    WorkoutView(workoutDataService: workoutDataService)
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line") {
                NavigationStack {
                    Text("Insights Page")
                        .navigationTitle("Insights Page")
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
    TabbarView(showSignInView: .constant(true), workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
}
