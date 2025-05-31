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

//    func test_DBExercise_init_shouldBeValid() {
//        for _ in 0..<100 {
//            // Given
//            let id = Int.random(in: 0..<100)
//            let name = UUID().uuidString
//            let description = UUID().uuidString
//            let userId = UUID().uuidString
//            
//            // When
//            let exercise = DBExercise(id: id, name: name, description: description, userId: userId)
//            
//            // Then
//            XCTAssertEqual(id, exercise.id)
//            XCTAssertEqual(name, exercise.name)
//            XCTAssertEqual(description, exercise.instructions)
//            XCTAssertEqual(userId, exercise.userId)
//        }
//    }
    
    func test_APIExercise_init_shouldBeValid() {
        // Given
        let id = UUID().uuidString
        let name = UUID().uuidString
        let bodyPart = UUID().uuidString
        let equipment = UUID().uuidString
        let target = UUID().uuidString
        var secondaryMuscles: [String] = []
        var instructions: [String] = []
        let gifUrl = UUID().uuidString
        
        for _ in 0..<Int.random(in: 1..<10) {
            secondaryMuscles.append(UUID().uuidString)
            instructions.append(UUID().uuidString)
        }
        
        // When
        let exercise = APIExercise(
            id: id,
            name: name,
            bodyPart: bodyPart,
            equipment: equipment,
            target: target,
            secondaryMuscles: secondaryMuscles,
            instructions: instructions,
            gifUrl: gifUrl)
        
        // Then
        XCTAssertEqual(exercise.id, id)
        XCTAssertEqual(exercise.name, name)
        XCTAssertEqual(exercise.bodyPart, bodyPart)
        XCTAssertEqual(exercise.target, target)
        XCTAssertEqual(exercise.secondaryMuscles, secondaryMuscles)
        XCTAssertEqual(exercise.instructions, instructions)
        XCTAssertEqual(exercise.gifUrl, gifUrl)
    }
    
    

}
