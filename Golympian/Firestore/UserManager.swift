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
    
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
}

// MARK: USER INSIGHTS
extension UserManager {
    private func userWorkoutInsightCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("workout_insights")
    }
    
    private func userWorkoutInsightDocument(userId: String, insightId: String) -> DocumentReference {
        userWorkoutInsightCollection(userId: userId).document(insightId)
    }
    
    func initUserWorkoutInsights(userId: String) async throws {
        let document = userWorkoutInsightCollection(userId: userId).document()
        let documentId = document.documentID
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let components = calendar.dateComponents([.year, .month], from: Date())
        
        // Leaving all other dateComponents nil will set them to default values,
        // which is desireable when trying to get the first of the current month
        let newInsight = WorkoutInsight(
            id: documentId,
            date: Calendar.current.date(from: components)!
        )
        
        try document.setData(from: newInsight, merge: false)
    }
    
    func getCurrMonthUserWorkoutInsight(userId: String) async throws -> [WorkoutInsight] {
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let components = calendar.dateComponents([.year, .month], from: Date())
        let fromDate = calendar.date(from: components)!
        let toDate = calendar.date(byAdding: .month, value: 1, to: fromDate)!
        
        return try await userWorkoutInsightCollection(userId: userId)
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: fromDate))
            .whereField("date", isLessThan: Timestamp(date: toDate))
            .getDocuments(as: WorkoutInsight.self)
    }
    
    func getAllUserInsights(userId: String) async throws -> [WorkoutInsight] {
        return try await userWorkoutInsightCollection(userId: userId)
            .getDocuments(as: WorkoutInsight.self)
    }
    
    func deleteUserInsight(userId: String, insightId: String) async throws {
        try await userWorkoutInsightDocument(userId: userId, insightId: insightId).delete()
    }
}
