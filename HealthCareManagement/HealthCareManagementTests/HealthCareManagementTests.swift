//
//  HealthCareManagementTests.swift
//  HealthCareManagementTests
//
//  Created by Vishwanath Kota on 10/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import XCTest
@testable import HealthCareManagement

class HealthCareManagementTests: XCTestCase {
    var regtir: RegestrationViewController!
    func testHelloWorld(){
        var helloWorld: String?
        XCTAssertNil(helloWorld)
        helloWorld = "Hello World"
        XCTAssertEqual(helloWorld, "Hello World")
        regtir.randomNumberWith(digits: 123)
    }
    
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
