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
}

#Preview {
    RootView()
}
