//
//  RootView.swift
//  Goalympian
//
//  Created by Bernard Scott on 3/10/25.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    @State private var showSignInView: Bool = false
    @AppStorage("profileIncomplete") var profileIncomplete: Bool = true
    private var workoutDataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            TabbarView(workoutDataService: workoutDataService, showSignInView: $showSignInView)
                .environmentObject(healthManager)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            Task {
                try await viewModel.checkProfile()
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                SignInExistingUser(showSignInView: $showSignInView)
            }
        }
        .fullScreenCover(isPresented: $profileIncomplete) {
            CompleteProfileView(profileCompleted: $profileIncomplete, dataService: workoutDataService)
        }
    }
}

#Preview {
    @Previewable @StateObject var healthManager = HealthManager()
    ContentView()
        .environmentObject(healthManager)
}
