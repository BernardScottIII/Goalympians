//
//  Workout.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import Foundation
import SwiftData

@Model
class Workout {
    var id = UUID()
    var name: String
    var date: Date
    var desc: String
    var intensity: Int
    var exercises: [Exercise]
    
    init(name: String = "", date: Date = Date.now, desc: String = "", intensity: Int = 2, exercises: [Exercise] = []) {
        self.name = name
        self.date = date
        self.desc = desc
        self.intensity = intensity
        self.exercises = exercises
    }
}
