//
//  ExerciseManager_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/12/25.
//

import XCTest
@testable import Goalympians

final class ExerciseManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_DBExercise_init_shouldBeValid() {
        for _ in 0..<100 {
            // Given
            let id = Int.random(in: 0..<100)
            let name = UUID().uuidString
            let description = UUID().uuidString
            let userId = UUID().uuidString
            
            // When
            let exercise = DBExercise(id: id, name: name, description: description, userId: userId)
            
            // Then
            XCTAssertEqual(id, exercise.id)
            XCTAssertEqual(name, exercise.name)
            XCTAssertEqual(description, exercise.instructions)
            XCTAssertEqual(userId, exercise.userId)
        }
    }
    
    

}
