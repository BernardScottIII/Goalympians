//
//  HealthManager.swift
//  Goalympians
//
//  Created by Bernard Scott on 5/1/25.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var hkInsights: [String : HKInsight] = [:]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        
        let healthTypes: Set = [steps, calories]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
//                fetchTodaySteps()
//                fetchTodayCalories()
//                print(hkInsights)
            } catch {
                print("error fetching data")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = HKInsight(id: 0, title: "Today's Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: stepCount.formattedString()!)
            DispatchQueue.main.async {
                self.hkInsights["todaySteps"] = activity
            }
            print(stepCount)
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's calorie data")
                return
            }
            
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = HKInsight(id: 1, title: "Today's Calories Burned", subtitle: "Goal: 300", image: "flame.fill", amount: caloriesBurned.formattedString()!)
            DispatchQueue.main.async {
                self.hkInsights["activeCaloriesBurned"] = activity
            }
            print(caloriesBurned)
        }
        
        healthStore.execute(query)
    }
}

extension Double {
    func formattedString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
