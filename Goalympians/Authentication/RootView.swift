//
//  RootView.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/10/25.
//

import SwiftUI

struct RootView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showSignInView: Bool = false
    @State private var selectedTab: Tabs = .workouts
    @State private var path: [Workout] = []
    
    enum Tabs: String, Equatable, Hashable, Identifiable {
        var id: Tabs { self }
        
        case workouts = "Workouts"
        case insights = "Insights"
        case settings = "Settings"
    }
    
    var body: some View {
        ZStack {
            ContentView(showSignInView: $showSignInView)
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
    
    func addWorkout() {
        let newWorkout = Workout()
        modelContext.insert(newWorkout)
        path = [newWorkout]
    }
}

#Preview {
    RootView()
}
