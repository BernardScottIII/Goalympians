//
//  ActivityManager_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/12/25.
//

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior

import XCTest
@testable import Goalympians

final class ActivityManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_DBResistanceSet_init_shouldBeValid() {
        // Given
        let id = UUID().uuidString
        let weight = 123.45
        let repetitions = 42
        
        // When
        let set = DBResistanceSet(id: id, weight: weight, repetitions: repetitions)
        
        // Then
        XCTAssert(id == set.id)
        XCTAssert(weight == set.weight)
        XCTAssert(repetitions == set.repetitions)
    }

}
