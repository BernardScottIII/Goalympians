//
//  SettingsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/10/25.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Delete Account", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(true))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET")
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("UPDATED EMAIL")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("UPDATED PASSWORD")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
}
