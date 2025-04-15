//
//  SignInEmailViewModel_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/12/25.
//

import XCTest
@testable import Goalympians

final class SignInEmailViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_SignInEmailViewModel_email_shouldBeEmptyString() {
        // Given
        
        // When
        let vm = SignInEmailViewModel()
        
        // Then
        XCTAssertEqual(vm.email, "")
        XCTAssertEqual(vm.email.count, 0)
        XCTAssertTrue(vm.email.isEmpty)
    }
    
    func test_SignInEmailViewModel_password_shouldBeEmptyString() {
        // Given
        
        // When
        let vm = SignInEmailViewModel()
        
        // Then
        XCTAssertEqual(vm.password, "")
        XCTAssertEqual(vm.password.count, 0)
        XCTAssertTrue(vm.password.isEmpty)
    }

}
