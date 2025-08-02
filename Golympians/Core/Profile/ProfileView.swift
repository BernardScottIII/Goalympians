//
//  ProfileView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/24/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var followerCount: Int
    @State private var followingCount: Int
    
    let profile: Profile
    
    init(
        profile: Profile
    ) {
        self.profile = profile
        followerCount = profile.followers.count
        followingCount = profile.following.count
    }
    
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
                            Text("\(followerCount)")
                        }
                        
                        VStack {
                            Text("Following")
                            Text("\(followingCount)")
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: 108)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                // There's certainly a better way to implement this, but I'm
                // garbage at coding.
                if viewModel.isFollowing ?? false == true {
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
                viewModel.checkIsFollowing(for: profile)
            }
        }
        .onChange(of: viewModel.isFollowing) { oldValue, newValue in
            Task {
                followerCount = try await viewModel.getFollowerCount(for: profile.username)
                followingCount = try await viewModel.getFollowingCount(for: profile.username)
            }
        }
    }
}

#Preview {
    ProfileView(profile: Profile(username: "TheUser", nickname: "Buddy", followers: ["3"], following: ["5", "asd"], photoURL: "", photoPath: ""))
}
