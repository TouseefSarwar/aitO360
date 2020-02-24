//
//  SharePost.swift
//  SharePost
//
//  Created by Touseef Sarwar on 11/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class SharePost: XCTestCase {

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
        
        let shareOnO360 = app.sheets["Select the social network you wish to share post on."].scrollViews.otherElements.buttons["Share on Outdoors360"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: shareOnO360, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(shareOnO360.exists)
        shareOnO360.tap()
        XCUIApplication().alerts["Share Post on Outdoors360"].scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.textFields["Add Share Caption"]/*[[".cells.textFields[\"Add Share Caption\"]",".textFields[\"Add Share Caption\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().alerts["Share Post on Outdoors360"].scrollViews.otherElements.collectionViews.textFields["Add Share Caption"].typeText("Sharing the Post with Outdoors360 network")
        
        let shareNowButton = app.alerts["Share Post on Outdoors360"].scrollViews.otherElements.buttons["Share Now"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: shareNowButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(shareNowButton.exists)
        shareNowButton.tap()

        let okButton = app.alerts["Share Alert"].scrollViews.otherElements.buttons["Ok"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: okButton, handler: nil)
          waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(okButton.exists)
        okButton.tap()   
        app.swipeDown()

        sleep(10)
                
    }

   
}
