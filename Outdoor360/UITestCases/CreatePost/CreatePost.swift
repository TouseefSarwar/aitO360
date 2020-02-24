//
//  CreatePost.swift
//  CreatePost
//
//  Created by Touseef Sarwar on 03/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class CreatePost: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }


    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let signInButton = app.buttons["SIGN IN"]
        sleep(15)
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
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
        
        let element = XCUIApplication().otherElements.statusBars.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).tap()
        element.tap()
                
        app.tables.otherElements["tableHeader"].buttons["image"].tap()
        
        app.tables["Empty list"].otherElements["tableHeader"].children(matching: .textView).element.tap()
        app.typeText("This is a post with image..... Test 2 image")
        sleep(2)

                                                                                                
    
//        let table = app.tables
        //        let imageButton = table.buttons["image"]
//        XCTAssertTrue(imageButton.exists)
//        imageButton.tap()
        
        let collectionViewsQuery = app.collectionViews
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: collectionViewsQuery, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars.buttons["Done"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        cell.buttons["location"].tap()
        app.typeText("Los Ang")
        tablesQuery.children(matching: .cell).element(boundBy: 0).tap()
        
        tablesQuery.children(matching: .button)["tag"].tap()
        cell.buttons["0 People Tagged"].tap()
        
        let okButton = app.alerts["Oops...something went wrong"].scrollViews.otherElements.buttons["OK"]
        okButton.tap()
        app.navigationBars["Photo Tags"].children(matching: .button).element(boundBy: 0).tap()
        cell.buttons["tag"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["0 People Tagged"]/*[[".cells.buttons[\"0 People Tagged\"]",".buttons[\"0 People Tagged\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        okButton.tap()
                
        
    }

 
}
