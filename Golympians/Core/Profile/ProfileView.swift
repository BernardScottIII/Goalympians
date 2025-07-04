//
//  ProfileView.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/30/25.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var userId: String = ""
    
    @Binding var showSignInView: Bool
    let workoutDataService: WorkoutManagerProtocol
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    viewModel.toggleDarkMode()
                } label: {
                    Text("Using Dark Mode: \(user.usingDarkMode?.description.capitalized ?? "No Data")")
                }
                
                Section("Personal Content") {
                    NavigationLink("My Exercises", value: "")
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onAppear {
            Task {
                userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            }
        }
        .onChange(of: showSignInView, { oldValue, newValue in
            Task {
                try? await viewModel.loadCurrentUser()
                userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            }
        })
        .navigationTitle("Profile")
        .navigationDestination(for: String.self) { _ in
            UserExerciseListView(
                viewModel: ExercisesViewModel(dataService: workoutDataService),
                userId: userId,
                workoutDataService: workoutDataService
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView, workoutDataService: workoutDataService)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            showSignInView: .constant(false),
            workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
        )
    }
}
