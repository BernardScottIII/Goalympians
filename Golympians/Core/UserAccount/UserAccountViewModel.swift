//
//  ProfileViewModel.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/31/25.
//

import SwiftUI
import PhotosUI

@MainActor
final class UserAccountViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func toggleDarkMode() {
        guard let user else { return }
        let currentValue = user.usingDarkMode ?? false
        Task {
            try await UserManager.shared.updateUserDarkMode(userId: user.userId, usingDarkMode: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func saveProfileImage(item: PhotosPickerItem) {
        guard let user else { return }
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                return
            }
            let (path, name) = try await StorageManager.shared.saveImage(data: data)
//            print("SUCCESS")
//            print(path)
//            print(name)
            let url = try await StorageManager.shared.getURLForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
            try await ProfileManager.shared.updatePhotoURL(username: user.username, path: path, url: url.absoluteString)
        }
    }
    
    func deleteProfileImage() {
        guard let user, let path = user.photoImagePath else { return }
        
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
            try await ProfileManager.shared.updatePhotoURL(username: user.username, path: nil, url: nil)
        }
    }
}
