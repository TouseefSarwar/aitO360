//
//  Feeds.swift
//  Feeds
//
//  Created by Touseef Sarwar on 19/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class Feeds: XCTestCase {

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
        // Use XCTAssert and related functions to verify your tests produce the correct results
        
        let signInButton = app.buttons["SIGN IN"]
        
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
        sleep(15)
        let myTable = app.tables.matching(identifier: "feedsList")
        let cell = myTable.cells["cell_no_0"]
        
        //Like Post
        
        //comment on post
        //Close Comment
        //View Photo
        
        let CV = cell.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element
        let singleImage = cell.children(matching: .image).element(boundBy: 0)
        if CV.exists{
            CV.tap()
        }else if singleImage.exists{
            singleImage.tap()
        }
        

        //like photo
//        let likeButton = app.buttons.matching(identifier: "like")
        let likeButton = app.buttons["like"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: likeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        likeButton.tap()
        
        //go to comment photo
        let commentButton = app.buttons["big comment"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: commentButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        commentButton.tap()
        //close comment
        let backComment = app.navigationBars["Comments"].children(matching: .button).element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backComment, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        backComment.tap()
        //submit comment
        commentButton.tap()
        
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        textView.typeText("😍😍😍😍😍 This is my test comment on a photo yooo ...! #MastMalang.. 😍")
        
        app.buttons["send"].tap()
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backComment, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        backComment.tap()
        //view photo Info
        let infoButton = app.buttons["More Info"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: infoButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        infoButton.tap()
        let backInfo = app.navigationBars["Info"].children(matching: .button).element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backInfo, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        backInfo.tap()
        // close photo view
        let closeButton = app.buttons["big cancel"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: closeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        closeButton.tap()
        
        
        //Click name/image  to go to the profile
        //click name
        
        cell.children(matching: .image).element.tap()
//        cellNo0Cell.images[""]
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        
        let backProfile = app.navigationBars["Outdoor360.OthersView"].children(matching: .button).element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backProfile, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        backProfile.tap()
        
        
        cell.buttons["userName"].tap()
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backProfile, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        backProfile.tap()
        
        
                
        
        
        //Scroll Post
        app.swipeUp()
        sleep(2)
        app.swipeUp()
        sleep(2)
        app.swipeUp()
        
        
        sleep(5)
        
    }

}
