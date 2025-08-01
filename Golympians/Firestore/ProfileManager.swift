//
//  ProfileManager.swift
//  Golympians
//
//  Created by Bernard Scott on 7/23/25.
//

import Foundation
import FirebaseFirestore

struct Profile: Codable, Hashable {
    let username: String // Firestore Document ID
    var nickname: String?
    var followers: [String]
    var following: [String]
    var photoURL: String?
    var photoPath: String?
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.username, forKey: .username)
        try container.encodeIfPresent(self.nickname, forKey: .nickname)
        try container.encode(self.followers, forKey: .followers)
        try container.encode(self.following, forKey: .following)
        try container.encode(self.photoURL, forKey: .photoURL)
        try container.encode(self.photoPath, forKey: .photoPath)
    }
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case nickname = "nickname"
        case followers = "followers"
        case following = "following"
        case photoURL = "photo_url"
        case photoPath = "photo_path"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.followers = try container.decode([String].self, forKey: .followers)
        self.following = try container.decode([String].self, forKey: .following)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.photoPath = try container.decodeIfPresent(String.self, forKey: .photoPath)
    }
    
    init(
        username: String,
        nickname: String?,
        followers: [String],
        following: [String],
        photoURL: String?,
        photoPath: String?
    ) {
        self.username = username
        self.nickname = nickname
        self.followers = followers
        self.following = following
        self.photoURL = photoURL
        self.photoPath = photoPath
    }
}

final class ProfileManager {
    static let shared = ProfileManager()
    
    private init() {}
    private let profileCollection = Firestore.firestore().collection("profiles")
    
    private func profileDocument(username: String) -> DocumentReference {
        profileCollection.document(username)
    }
    
    func createNewProfile(profile: Profile) async throws {
        try profileDocument(username: profile.username).setData(from: profile, merge: false)
    }
    
    func getProfile(username: String) async throws -> Profile {
        try await profileDocument(username: username).getDocument(as: Profile.self)
    }
    
    func profileExists(username: String) async throws -> Bool {
        let profile = try? await getProfile(username: username)
        return profile == nil
    }
    
    func getAllProfiles() async throws -> [Profile] {
        try await profileCollection.getDocuments(as: Profile.self)
    }
    
    func addFollower(_ followRecipient: Profile, followedBy followInitiater: Profile) async throws {
        let recipientData: [String: Any] = [
            Profile.CodingKeys.followers.rawValue: FieldValue.arrayUnion([followInitiater.username])
        ]
        
        let initiaterData: [String: Any] = [
            Profile.CodingKeys.following.rawValue: FieldValue.arrayUnion([followRecipient.username])
        ]
        
        try await profileDocument(username: followRecipient.username).updateData(recipientData)
        try await profileDocument(username: followInitiater.username).updateData(initiaterData)
    }
    
    func removeFollower(_ followRecipient: Profile, notFollowedBy followInitiater: Profile) async throws {
        let recipientData: [String: Any] = [
            Profile.CodingKeys.followers.rawValue: FieldValue.arrayRemove([followInitiater.username])
        ]
        
        let initiaterData: [String: Any] = [
            Profile.CodingKeys.following.rawValue: FieldValue.arrayRemove([followRecipient.username])
        ]
        
        try await profileDocument(username: followRecipient.username).updateData(recipientData)
        try await profileDocument(username: followInitiater.username).updateData(initiaterData)
    }
    
    func updatePhotoURL(username: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            Profile.CodingKeys.photoURL.rawValue: url,
            Profile.CodingKeys.photoPath.rawValue: path
        ]
        
        try await profileDocument(username: username).updateData(data)
    }
}
