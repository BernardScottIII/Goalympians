//
//  WorkoutViewModel_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/21/25.
//

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior

import XCTest
@testable import Goalympian

@MainActor
final class WorkoutViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_WorkoutViewModel_init_shouldBeValid() {
        // Given
        let mockWorkoutManager = MockWorkoutManager()
        
        // When
        let vm = WorkoutViewModel(workoutDataService: mockWorkoutManager)
        
        // Then
        XCTAssertTrue(vm.workouts.isEmpty)
        XCTAssertEqual(vm.workouts.count, 0)
    }

    func test_WorkoutViewModel_getAllWorkouts_shouldReturnAllWorkouts() {
        // Given
        let mockWorkoutManager = MockWorkoutManager()
        let vm = WorkoutViewModel(workoutDataService: mockWorkoutManager)
        
        let date = ISO8601DateFormatter().date(from:"2016-04-14T10:44:00+0000")!
        
        let mockWorkouts = [
            DBWorkout(id: "workout1", userId: "user1", name: "Workout 1", description: "First Workout", date: date),
            DBWorkout(id: "workout2", userId: "user2", name: "Workout 2", description: "Second Workout", date: date),
            DBWorkout(id: "workout3", userId: "user3", name: "Workout 3", description: "Third Workout", date: date),
            DBWorkout(id: "workout4", userId: "user4", name: "Workout 4", description: "Fourth Workout", date: date),
            DBWorkout(id: "workout5", userId: "user5", name: "Workout 5", description: "Fifth Workout", date: date),
        ]
        
        Task {
            // When
            try await vm.getAllWorkouts()

            // Then
            XCTAssertGreaterThan(vm.workouts.count, 0)
            for (index, workout) in vm.workouts.enumerated() {
                XCTAssertEqual(workout.id, mockWorkouts[index].id)
                XCTAssertEqual(workout.userId, mockWorkouts[index].userId)
                XCTAssertEqual(workout.name, mockWorkouts[index].name)
                XCTAssertEqual(workout.description, mockWorkouts[index].description)
                XCTAssertEqual(workout.date, mockWorkouts[index].date)
            }
        }
    }

}
