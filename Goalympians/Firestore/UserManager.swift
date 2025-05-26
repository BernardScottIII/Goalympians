//
//  UserManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 3/31/25.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    var usingDarkMode: Bool?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.usingDarkMode = false
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case usingDarkMode = "using_dark_mode"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.usingDarkMode = try container.decodeIfPresent(Bool.self, forKey: .usingDarkMode)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.usingDarkMode, forKey: .usingDarkMode)
    }
    
    mutating func toggleDarkMode() {
        let currentValue = usingDarkMode ?? false
        self.usingDarkMode = !currentValue
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userInsightCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("insights")
    }
    
    private func userInsightDocument(userId: String, insightId: String) -> DocumentReference {
        userInsightCollection(userId: userId).document(insightId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
        
        try await addUserInsight(
            userId: user.userId,
            insightName: "workout_count",
            insightData: ["count":0])
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserDarkMode(userId: String, usingDarkMode: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.usingDarkMode.rawValue : usingDarkMode
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserInsight(userId: String, insightName: String, insightData: [String:Any]) async throws {
        
        let document = userInsightCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            "id": documentId,
            "name": insightName,
            "data": insightData
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserInsight(userId: String, insightId: String) async throws {
        try await userInsightDocument(userId: userId, insightId: insightId).delete()
    }
    
    func getAllUserInsights(userId: String) async throws -> [Insight] {
        try await userInsightCollection(userId: userId).getDocuments(as: Insight.self)
    }
}
