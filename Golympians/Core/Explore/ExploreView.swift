//
//  ExploreView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/24/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        List {
            if searchText.isEmpty {
                Text("Find your friends!")
            } else {
                ForEach(viewModel.profiles.filter {
                    searchText.isEmpty ? true : $0.username.localizedStandardContains(searchText)
                }, id: \.username) { profile in
//                    NavigationLink(profile.username, value: profile)
                    NavigationLink(value: profile) {
                        ProfileSearchResultView(profile: profile)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .navigationDestination(for: Profile.self, destination: { profile in
            ProfileView(profile: profile)
        })
        .onAppear {
            Task {
                try await viewModel.getProfiles()
            }
        }
    }
}

#Preview {
    ExploreView()
}
