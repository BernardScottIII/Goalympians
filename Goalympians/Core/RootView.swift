//
//  RootView.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/10/25.
//

import SwiftUI
import FirebaseFirestore

struct RootView: View {
    
    @EnvironmentObject private var healthManager: HealthManager
    @State private var showSignInView: Bool = false
    private var workoutDataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    
    var body: some View {
        ZStack {
            TabbarView(workoutDataService: workoutDataService, showSignInView: $showSignInView)
                .environmentObject(healthManager)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
