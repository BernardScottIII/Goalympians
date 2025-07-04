//
//  SettingsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/10/25.
//

import SwiftUI
import FirebaseFirestore

struct SettingsView: View {
    
    @State private var accountDeletionFlag: Bool = false
    @StateObject private var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showSignInView: Bool
    let workoutDataService: WorkoutManagerProtocol
    
    init(
        showSignInView: Binding<Bool>,
        workoutDataService: WorkoutManagerProtocol
    ) {
        self.workoutDataService = workoutDataService
        _showSignInView = showSignInView
        _viewModel = StateObject(wrappedValue: SettingsViewModel(workoutDataService: workoutDataService))
    }
    
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
                accountDeletionFlag = true
            }
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .onChange(of: showSignInView) {
            dismiss()
        }
        .alert("Permanently Delete Account?", isPresented: $accountDeletionFlag) {
            Button("Confirm", role: .destructive, action: initiateAccountDelete)
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Are you sure you would like to permanently delete your account? This action cannot be undone.")
        }
    }
    
    private func initiateAccountDelete() {
        Task {
            do {
                try await viewModel.deleteAccount()
                showSignInView = true
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(true), workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
    }
}

extension SettingsView {
    private var anonymousSection: some View {
        Section {
            Button("Link Google Account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("GOOGLE LINKED")
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Link Email Account") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("EMAIL LINKED")
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Create Account")
        }
    }
    
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
