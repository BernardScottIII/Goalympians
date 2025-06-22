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
    let streakData: [String:Int]
    let streakValidDays: [String:Bool]
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.usingDarkMode = false
        self.streakData = [
            StreakDataKeys.streakThreshold.rawValue:3,
            StreakDataKeys.currentStreak.rawValue:0
        ]
        self.streakValidDays = [
            StreakValidDayKeys.sunday.rawValue:false,
            StreakValidDayKeys.monday.rawValue:false,
            StreakValidDayKeys.tuesday.rawValue:false,
            StreakValidDayKeys.wednesday.rawValue:false,
            StreakValidDayKeys.thursday.rawValue:false,
            StreakValidDayKeys.friday.rawValue:false,
            StreakValidDayKeys.saturday.rawValue:false
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case usingDarkMode = "using_dark_mode"
        case streakData = "streak_data"
        case streakValidDays = "streak_valid_days"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.usingDarkMode = try container.decodeIfPresent(Bool.self, forKey: .usingDarkMode)
        self.streakData = try container.decode([String:Int].self, forKey: .streakData)
        self.streakValidDays = try container.decode([String:Bool].self, forKey: .streakValidDays)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.usingDarkMode, forKey: .usingDarkMode)
        try container.encode(self.streakData, forKey: .streakData)
        try container.encode(self.streakValidDays, forKey: .streakValidDays)
    }
    
    mutating func toggleDarkMode() {
        let currentValue = usingDarkMode ?? false
        self.usingDarkMode = !currentValue
    }
    
    enum StreakDataKeys: String, CodingKey, CaseIterable {
        case streakThreshold = "streak_threshold"
        case currentStreak = "current_streak"
    }
    
    enum StreakValidDayKeys: String, CodingKey, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
        
        try await initUserWorkoutInsights(userId: user.userId)
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
}
