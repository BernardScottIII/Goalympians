//
//  WorkoutManager_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/22/25.
//

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior

import XCTest
import FirebaseFirestore
@testable import Goalympian

final class WorkoutManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_CreateNewWorkout_NewWorkoutId_ShouldBeValid() async {
        // Given
        let workoutId = UUID().uuidString
        let userId = UUID().uuidString
        let name = "Sample Workout"
        let description = "Sample Description"
        let date = ISO8601DateFormatter().date(from:"2016-04-14T10:44:00+0000")!
        
        let workout = DBWorkout(id: workoutId, userId: userId, name: name, description: description, date: date)
        
        try! Firestore.firestore().collection("test_workouts").document(workoutId).setData(from: workout, merge: false)
        
        let pwm = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))
        
        // When
        try! await pwm.createNewWorkout(workout: workout)
        guard let submittedWorkout = try? await pwm.getWorkout(workoutId: workout.id) else {
            XCTFail()
            return
        }
        
        // Then
        // compare results of manual insertion and manager insertion
        XCTAssertEqual(submittedWorkout.id, workout.id)
        XCTAssertEqual(submittedWorkout.userId, workout.userId)
        XCTAssertEqual(submittedWorkout.name, workout.name)
        XCTAssertEqual(submittedWorkout.description, workout.description)
        XCTAssertEqual(submittedWorkout.date, workout.date)
    }
    
    func test_CreateNewWorkout_ExistingWorkoutId_ShouldBeOverwritten() async {
        // Given
        // An existing workout in the db
        let workoutId = UUID().uuidString
        let userId = UUID().uuidString
        let name = "Sample Workout"
        let description = "Sample Description"
        let date = ISO8601DateFormatter().date(from:"2016-04-14T10:44:00+0000")!
        
        let workout = DBWorkout(id: workoutId, userId: userId, name: name, description: description, date: date)
        
        try! Firestore.firestore().collection("test_workouts").document(workoutId).setData(from: workout, merge: false)
        
        let pwm = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))
        
        // When
        // A new workout with the same workoutID is added
        let newName = "Another Sample Workout"
        let newDescription = "Another Sample Description"
        let newDate = ISO8601DateFormatter().date(from:"2020-04-14T10:44:00+0000")!
        
        let newWorkout = DBWorkout(id: workout.id, userId: workout.userId, name: newName, description: newDescription, date: newDate)
        
        try! await pwm.createNewWorkout(workout: newWorkout)
        
        guard let submittedWorkout = try? await pwm.getWorkout(workoutId: workout.id) else {
            XCTFail()
            return
        }
        
        // Then
        // the submittedWorkout should contain details of the newWorkout
        XCTAssertEqual(submittedWorkout.id, newWorkout.id)
        XCTAssertEqual(submittedWorkout.userId, newWorkout.userId)
        XCTAssertEqual(submittedWorkout.name, newWorkout.name)
        XCTAssertEqual(submittedWorkout.description, newWorkout.description)
        XCTAssertEqual(submittedWorkout.date, newWorkout.date)
        
        XCTAssertEqual(submittedWorkout.id, workout.id)
        XCTAssertEqual(submittedWorkout.userId, workout.userId)
        XCTAssertNotEqual(submittedWorkout.name, workout.name)
        XCTAssertNotEqual(submittedWorkout.description, workout.description)
        XCTAssertNotEqual(submittedWorkout.date, workout.date)
    }
    
    func test_GetWorkout_ValidWorkoutId_ShouldReturnValidWorkout() async {
        // Given
        // A valid workout exists
        let workoutId = UUID().uuidString
        let userId = UUID().uuidString
        let name = "Sample Workout"
        let description = "Sample Description"
        let date = ISO8601DateFormatter().date(from:"2016-04-14T10:44:00+0000")!
        
        let workout = DBWorkout(id: workoutId, userId: userId, name: name, description: description, date: date)
        
        try! Firestore.firestore().collection("test_workouts").document(workoutId).setData(from: workout, merge: false)
        
        let pwm = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))
        
        // When
        guard let result = try? await pwm.getWorkout(workoutId: workout.id) else {
            XCTFail()
            return
        }
        
        // Then
        XCTAssertEqual(result.id, workout.id)
        XCTAssertEqual(result.userId, workout.userId)
        XCTAssertEqual(result.name, workout.name)
        XCTAssertEqual(result.description, workout.description)
        XCTAssertEqual(result.date, workout.date)
    }
    
    func test_GetWorkout_InvalidWorkoutId_ShouldReturnNil() async {
        // Given
        let workoutId = UUID().uuidString
        let userId = UUID().uuidString
        let name = "Sample Workout"
        let description = "Sample Description"
        let date = ISO8601DateFormatter().date(from:"2016-04-14T10:44:00+0000")!
        
        let workout = DBWorkout(id: workoutId, userId: userId, name: name, description: description, date: date)
        
        try! Firestore.firestore().collection("test_workouts").document(workoutId).setData(from: workout, merge: false)
        
        let pwm = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))
        
        // When
        let result = try? await pwm.getWorkout(workoutId: "nonexistentWorkoutId")
        
        // Then
        XCTAssertNil(result)
    }
    
    // Integration Testing
    func test_GetAllWorkouts_WorkoutsExistInCollection_ShouldReturnAllWorkouts() async {
        // Given
        // Delete all pre-existing workouts in test_workouts
        let pwm = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("test_workouts"))
        let authDataResult = try! await AuthenticationManager.shared.signInUser(email: "unit-test@unit-test.com", password: "unit-test")
        let userId = authDataResult.uid
        let existingDocList = try! await pwm.getAllWorkouts()
        for entry in existingDocList {
            let id = entry.id
            try! await Firestore.firestore().collection("test_workouts").document(id).delete()
        }
        
        var workoutIds = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        workoutIds.sort()
        
        let workout1 = DBWorkout(id: workoutIds[0], userId: userId, name: "Sample Workout 1", description: "Sample Description 1", date: ISO8601DateFormatter().date(from:"2017-04-14T10:44:00+0000")!)
        let workout2 = DBWorkout(id: workoutIds[1], userId: userId, name: "Sample Workout 2", description: "Sample Description 2", date: ISO8601DateFormatter().date(from:"2018-04-14T10:44:00+0000")!)
        let workout3 = DBWorkout(id: workoutIds[2], userId: userId, name: "Sample Workout 3", description: "Sample Description 3", date: ISO8601DateFormatter().date(from:"2019-04-14T10:44:00+0000")!)
        
        try! await pwm.createNewWorkout(workout: workout1)
        try! await pwm.createNewWorkout(workout: workout2)
        try! await pwm.createNewWorkout(workout: workout3)
        
        // When
        let workoutsList = try! await pwm.getAllWorkouts()
        let _ = print(workoutsList)
        
        // Then
        XCTAssertEqual(workoutsList[0].id, workout1.id)
        XCTAssertEqual(workoutsList[0].userId, workout1.userId)
        XCTAssertEqual(workoutsList[0].name, workout1.name)
        XCTAssertEqual(workoutsList[0].description, workout1.description)
        XCTAssertEqual(workoutsList[0].date, workout1.date)
        
        XCTAssertEqual(workoutsList[1].id, workout2.id)
        XCTAssertEqual(workoutsList[1].userId, workout2.userId)
        XCTAssertEqual(workoutsList[1].name, workout2.name)
        XCTAssertEqual(workoutsList[1].description, workout2.description)
        XCTAssertEqual(workoutsList[1].date, workout2.date)
        
        XCTAssertEqual(workoutsList[2].id, workout3.id)
        XCTAssertEqual(workoutsList[2].userId, workout3.userId)
        XCTAssertEqual(workoutsList[2].name, workout3.name)
        XCTAssertEqual(workoutsList[2].description, workout3.description)
        XCTAssertEqual(workoutsList[2].date, workout3.date)
    }
}
