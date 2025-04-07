//
//  ContentView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/3/25.
//

import SwiftUI
import SwiftData

struct TabbarView: View {
    @Query var workouts: [Workout]
    @Environment(\.modelContext) private var modelContext
    @State private var path: [Workout] = []
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            Tab("Workouts", systemImage: "dumbbell") {
                NavigationStack(path: $path) {
                    WorkoutView(path: $path)
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line") {
                NavigationStack {
                    Text("Insights Page")
                        .navigationTitle("Insights Page")
                }
            }
            
//            Tab("Settings", systemImage: "gear") {
//                if !showSignInView {
//                    NavigationStack {
//                        SettingsView(showSignInView: $showSignInView)
//                            .navigationTitle("Settings")
//                    }
//                }
//            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
                }
            }
            
//            Tab("Exercises", systemImage: "figure.run") {
//                NavigationStack {
//                    ExercisesView()
//                }
//            }
        }
    }
    
    
}

#Preview {
    TabbarView(showSignInView: .constant(true))
}
