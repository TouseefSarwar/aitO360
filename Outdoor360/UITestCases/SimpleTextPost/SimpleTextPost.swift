//
//  SimpleTextPost.swift
//  SimpleTextPost
//
//  Created by Touseef Sarwar on 06/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class SimpleTextPost: XCTestCase {

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
        
        let plusButton = app.otherElements["Plus Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: plusButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(plusButton.exists)
        plusButton.tap()
                
        
        let createAlbum = app.otherElements["Create Album"]
        XCTAssertTrue(createAlbum.exists)
        createAlbum.tap()
                                                        
//XCUIApplication().alerts["“Outdoors360” Would Like to Access the Camera"].buttons["OK"].tap()
//        let capTextView = app.tables["Empty list"].children(matching: .textView).element
        let capTextView = app.tables["Empty list"].otherElements["tableHeader"].children(matching: .textView).element
        XCTAssertTrue(capTextView.exists)
        capTextView.tap()
                                 
       
    }
}
