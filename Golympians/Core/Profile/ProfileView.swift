//
//  ProfileView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/24/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    let profile: Profile
    
    var body: some View {
        VStack {
            HStack {
                if let urlString = profile.photoURL, let url = URL(string: urlString) {
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
                    Text(profile.username)
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
            
            HStack {
                Spacer()
                if profile.followers.contains(viewModel.myProfile?.username ?? "") {
                    Button {
                        viewModel.removeFollower(profile, notFollowedBy: viewModel.myProfile)
                    } label: {
                        Text("Unfollow")
                    }
                    .padding([.leading, .trailing], 32)
                    .padding([.top, .bottom], 4)
                    .background(Color.gray.opacity(0.4))
                    .clipShape(.buttonBorder)
                } else {
                    Button {
                        viewModel.addFollower(profile, followedBy: viewModel.myProfile)
                    } label: {
                        Text("Follow")
                    }
                    .padding([.leading, .trailing], 32)
                    .padding([.top, .bottom], 4)
                    .background(Color.gray.opacity(0.4))
                    .clipShape(.buttonBorder)
                }
                
                Spacer()
                Button {
                    viewModel.removeFollower(profile, notFollowedBy: viewModel.myProfile)
                } label: {
                    Text("Share")
                }
                .padding([.leading, .trailing], 32)
                .padding([.top, .bottom], 4)
                .background(Color.gray.opacity(0.4))
                .clipShape(.buttonBorder)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                try await viewModel.loadMyProfile()
            }
        }
    }
}

#Preview {
    @Previewable let profile = Profile(username: "TheUser", nickname: "Buddy", followers: ["3"], following: ["5", "asd"], photoURL: "", photoPath: "")
    ProfileView(profile: profile)
}
