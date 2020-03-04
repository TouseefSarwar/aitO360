//
//  SharePostSocialNetworks.swift
//  SharePostSocialNetworks
//
//  Created by Touseef Sarwar on 12/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class SharePostSocialNetworks: XCTestCase {

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
        let signInButton = app.buttons["SIGN IN"]
        sleep(15)
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
             
             if alert.buttons["Allow"].exists{
                 alert.buttons["Allow"].tap()
                 return true
             }
             return false
         }
        app.tap()
        
        if signInButton.exists{
            XCTAssertTrue(signInButton.exists)
            signInButton.tap()
            let elementsQuery = app.scrollViews.otherElements
                        let emailTextField = elementsQuery.textFields["Email"]
            XCTAssertTrue(emailTextField.exists)
            emailTextField.tap()
            emailTextField.typeText("jcgalleries.testemail1@gmail.com")
            let passwordTextField = elementsQuery.secureTextFields["Password"]
            XCTAssertTrue(passwordTextField.exists)
            passwordTextField.tap()
            passwordTextField.typeText("123456")
            let doneButton = app.toolbars["Toolbar"].buttons["Done"]
            XCTAssertTrue(doneButton.exists)
            doneButton.tap()
            let loginButton = elementsQuery.buttons["Login"]
            XCTAssertTrue(loginButton.exists)
            loginButton.tap()
        }
        
        let myTable = app.tables.matching(identifier: "feedsList")
                
        
        let shareButton = myTable.cells["cell_no_0"].buttons["share"]
        XCTAssertTrue(shareButton.exists)
                shareButton.tap()
        
        let shareToSocial = app.sheets["Select the social network you wish to share post on."].scrollViews.otherElements.buttons["Share to Social Network"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: shareToSocial, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(shareToSocial.exists)
        shareToSocial.tap()
        
        
    }
}
