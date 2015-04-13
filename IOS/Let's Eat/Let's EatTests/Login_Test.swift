//
//  Login_Test.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 10.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit
import XCTest

class Login_Test: XCTestCase {
    var calendar: NSCalendar?
    var locale: NSLocale?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        locale = NSLocale(localeIdentifier: "en_US")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoginView(){
        
    }

}
