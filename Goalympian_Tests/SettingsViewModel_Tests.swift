//
//  SettingsViewModel_Tests.swift
//  Goalympians_Tests
//
//  Created by Bernard Scott on 4/12/25.
//

import XCTest
@testable import Goalympians

final class SettingsViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func test_SettingsViewModel_authProvidersArray_shouldBeEmpty() {
        // Given
        
        // When
        let vm = SettingsViewModel()
        
        // Then
        XCTAssert(vm.authProviders.isEmpty)
        XCTAssertEqual(vm.authProviders.count, 0)
    }
    
    @MainActor func test_SettingsViewModel_authUser_ShouldBeNil() {
        // Given
        
        // When
        let vm = SettingsViewModel()
        
        // Then
        XCTAssertNil(vm.authUser)
    }

}
