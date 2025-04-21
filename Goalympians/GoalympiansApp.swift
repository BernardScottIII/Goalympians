//
//  GoalympiansApp.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/12/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore

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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Workout.self, ResistanceSet.self, RunSet.self, SwimSet.self])
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        let settings = FirestoreSettings()
        
        // Use memory-only cache
        settings.cacheSettings =
        MemoryCacheSettings(garbageCollectorSettings: MemoryLRUGCSettings())

        // Use persistent disk cache, with 100 MB cache size
        settings.cacheSettings = PersistentCacheSettings(sizeBytes: 100 * 1024 * 1024 as NSNumber)

        // Any additional options
        // ...

        // Enable offline data persistence
        let db = Firestore.firestore()
        db.settings = settings

        
        return true
    }
}

