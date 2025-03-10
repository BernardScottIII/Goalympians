//
//  GoalympiansApp.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

// Code which gives me the filepath of the database file for this application
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print("Application Directory \(NSHomeDirectory())")
//        return true
//    }
//}

@main
struct GoalympiansApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, ResistanceSet.self, RunSet.self, SwimSet.self])
    }
}

