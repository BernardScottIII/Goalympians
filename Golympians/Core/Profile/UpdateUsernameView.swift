//
//  UpdateUsernameView.swift
//  Golympians
//
//  Created by Bernard Scott on 8/5/25.
//

import SwiftUI

struct UpdateUsernameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showEmptyUsernameAlert: Bool = false
    @State private var savingProfile: Bool = false

    @State private var newUsername: String
    
    @ObservedObject var viewModel: ProfileViewModel
    
    init(
        viewModel: ProfileViewModel
    ) {
        self.viewModel = viewModel
        if let profile = viewModel.myProfile {
            _newUsername = .init(wrappedValue: profile.username)
        } else {
            self.newUsername = ""
        }
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("This is the page for updating a username.")
                Spacer()
            }
            .padding([.leading, .trailing])
            
            Form {
                TextField("New Username", text: $newUsername)
            }
            
            Spacer()
            
            BottomActionButton(label: "Update Username") {
                showEmptyUsernameAlert = newUsername.isEmpty
                
                if !showEmptyUsernameAlert {
                    Task {
                        savingProfile = true
                        try await viewModel.changeUsername(newUsername: newUsername)
                        savingProfile = false
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Update Username")
        .alert("Empty Username", isPresented: $showEmptyUsernameAlert) {
            Button("Okay", role: .cancel, action: {})
        } message: {
            Text("You cannot enter a blank username.")
        }
        .fullScreenCover(isPresented: $savingProfile) {
            VStack {
                Text("Saving profile...")
                ProgressView()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = ProfileViewModel()
    NavigationStack {
        UpdateUsernameView(viewModel: viewModel)
    }
}
