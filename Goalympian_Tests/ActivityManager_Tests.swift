//
//  ActivityManager_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/12/25.
//

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior

import XCTest
@testable import Goalympian

final class ActivityManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_DBResistanceSet_init_shouldBeValid() {
        for _ in 0..<100 {
            // Given
            let id = UUID().uuidString
            let weight = Double.random(in: 0..<100.00)
            let repetitions = Int.random(in: 0..<100)
            
            // When
            let set = DBResistanceSet(id: id, weight: weight, repetitions: repetitions)
            
            // Then
            XCTAssertEqual(id, set.id)
            XCTAssertEqual(weight, set.weight)
            XCTAssertEqual(repetitions, set.repetitions)
        }
    }
    
    func test_DBRunSet_init_shouldBeValid() {
        for _ in 0..<100 {
            // Given
            let id = UUID().uuidString
            let distance = Double.random(in: 0..<100.00)
            let elevation = Double.random(in: 0..<100.00)
            let duration = Double.random(in: 0..<100.00)
            
            // When
            let set = DBRunSet(id: id, distance: distance, elevation: elevation, duration: duration)
            
            // Then
            XCTAssertEqual(id, set.id)
            XCTAssertEqual(distance, set.distance)
            XCTAssertEqual(elevation, set.elevation)
            XCTAssertEqual(duration, set.duration)
        }
    }
    
    func test_DBSwimSet_init_shouldBeValid() {
        for _ in 0..<100 {
            // Given
            let id = UUID().uuidString
            let distance = Double.random(in: 0..<100.00)
            let laps = Int.random(in: 0..<100)
            let duration = Double.random(in: 0..<100.00)
            
            // When
            let set = DBSwimSet(id: id, distance: distance, laps: laps, duration: duration)
            
            // Then
            XCTAssertEqual(id, set.id)
            XCTAssertEqual(distance, set.distance)
            XCTAssertEqual(laps, set.laps)
            XCTAssertEqual(duration, set.duration)
        }
    }
    
    func test_DBActivity_init_shouldBeValid() {
        for _ in 0..<100 {
            // Given
            let id = UUID().uuidString
            let exerciseId = UUID().uuidString
            let setType = SetType.allCases[Int.random(in: 0..<SetType.allCases.count)]
            
            // When
            let activity = DBActivity(id: id, exerciseId: exerciseId, setType: setType)
            
            // Then
            XCTAssertEqual(id, activity.id)
            XCTAssertEqual(exerciseId, activity.exerciseId)
            XCTAssertEqual(setType, setType)
        }
    }
    
    func test_etc() {
        // Given
//        let mockUser = User()... 
    }

}
