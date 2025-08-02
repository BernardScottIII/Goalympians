//
//  ProfileView.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/30/25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

struct UserAccountView: View {
    @StateObject private var viewModel = UserAccountViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var userId: String = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    @Binding var showSignInView: Bool
    let workoutDataService: WorkoutManagerProtocol
    
    var body: some View {
        List {
            if let user = viewModel.user, let profile = profileViewModel.myProfile {
                HStack {
                    if let urlString = user.photoURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 108, height: 108)
                                .clipShape(.circle)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 108, height: 108)
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 48))
                    }
                    
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(profile.nickname ?? "")
                        
                        HStack {
                            VStack {
                                Text("Followers")
                                Text("\(profile.followers.count)")
                            }
                            
                            VStack {
                                Text("Following")
                                Text("\(profile.following.count)")
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(height: 108)
                    
                    Spacer()
                }
                
                Section("Personal Content") {
                    NavigationLink("My Exercises", value: "")
                }
            }
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                Text("Select Profile Picture")
            }
            
//            if let urlString = viewModel.user?.photoURL, let url = URL(string: urlString) {
//                AsyncImage(url: url) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 48, height: 48)
//                        .clipShape(.circle)
//                } placeholder: {
//                    ProgressView()
//                        .frame(width: 150, height: 150)
//                }
//            }
            
            if viewModel.user?.photoImagePath != nil {
                Button("Delete Image") {
                    viewModel.deleteProfileImage()
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
            try? await profileViewModel.loadMyProfile()
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
        .onChange(of: selectedPhoto, { oldValue, newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
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
        UserAccountView(
            showSignInView: .constant(false),
            workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
        )
    }
}
