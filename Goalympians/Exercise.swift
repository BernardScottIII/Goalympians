//
//  Exercise.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import Foundation
import SwiftData

@Model
class Exercise {
    @Attribute(.unique)
    var name: String
    var desc: String
    var setType: SetType
    
    init(name: String, desc: String, setType: SetType) {
        self.name = name
        self.desc = desc
        self.setType = setType
    }
}
