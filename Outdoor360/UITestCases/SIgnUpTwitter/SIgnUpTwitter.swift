//
//  SIgnUpTwitter.swift
//  SIgnUpTwitter
//
//  Created by Touseef Sarwar on 17/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class SIgnUpTwitter: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let signUpButton = app.buttons["SIGN UP"]
        sleep(15)
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
        if !signUpButton.exists{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
        }
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signUpButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let signUpWithFacebookButton = XCUIApplication().buttons["Sign up with Twitter"]
        signUpWithFacebookButton.tap()
        
        sleep(5)
        
    }

    
}
