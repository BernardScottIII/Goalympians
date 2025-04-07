//
//  ActivityManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import Foundation
import FirebaseFirestore

struct DBActivityList: Codable {
    let activities: [DBActivity]
    let total, skip, limit: Int
}

struct DBActivity: Identifiable, Codable {
    let id: String
    let exerciseId: Int
    let setType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case exerciseId = "exercise_id"
        case setType = "set_type"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.exerciseId = try container.decode(Int.self, forKey: .exerciseId)
        self.setType = try container.decode(String.self, forKey: .setType)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.exerciseId, forKey: .exerciseId)
        try container.encode(self.setType, forKey: .setType)
    }
}

final class ActivityManager {
    static let shared = ActivityManager()
    private init() {}
    
    private let activityCollection = Firestore.firestore().collection("activities")
}
