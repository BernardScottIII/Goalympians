//
//  CompleteProvileViewModel.swift
//  Golympians
//
//  Created by Bernard Scott on 7/22/25.
//

import Foundation

@MainActor
final class CompleteProfileViewModel: ObservableObject {
    @Published private(set) var usernameIsUnique: Bool = false
    @Published private(set) var formIsIncomplete: Bool = true
    @Published private(set) var measurementUnitSelection: MeasurementUnits = .imperial
    @Published private(set) var measurementUnitDisplay: String = "Lbs"
    
    func setMeasurementUnit(_ measurementUnit: MeasurementUnits) {
        self.measurementUnitSelection = measurementUnit
        switch measurementUnit {
        case .metric:
            measurementUnitDisplay = "Kg"
        case .imperial:
            measurementUnitDisplay = "Lbs"
        }
    }
    
    func checkUniqueness(_ username: String) async throws {
        self.usernameIsUnique = try await ProfileManager.shared.profileExists(username: username)
    }
    
    func setUserData(userId: String, data: [String:Any]) async throws {
        try await UserManager.shared.setUserData(userId: userId, data: data)
    }
    
    func createNewProfile(profile: Profile) async throws {
        try await ProfileManager.shared.createNewProfile(profile: profile)
    }
    
    func checkFormCompletion() {
        formIsIncomplete = !usernameIsUnique
    }
}
