//
//  ViewPhotoComPost.swift
//  ViewPhotoComPost
//
//  Created by Touseef Sarwar on 12/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class ViewPhotoComPost: XCTestCase {

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
        let cell = myTable.cells["cell_no_0"]
        let CV = cell.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element
        let singleImage = cell.children(matching: .image).element(boundBy: 0)
        if CV.exists{
            CV.tap()
        }else if singleImage.exists{
            singleImage.tap()
        }
        //else{} put  a code of creating post in else....
        //Covering Photo
        let infoButton = app.buttons["More Info"]
        infoButton.tap()
        
        let backInfo = app.navigationBars["Info"].children(matching: .button).element
        backInfo.tap()
        
        let commentButton = app.buttons["big comment"]
        commentButton.tap()
        
        let backComment = app.navigationBars["Comments"].children(matching: .button).element
        backComment.tap()
        
        let tagButton = app.buttons["big tag"]
        tagButton.tap()
        
        let backTag = app.navigationBars["Tagged"].children(matching: .button).element(boundBy: 0)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backTag, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        backTag.tap()
        
        
        let viewLikeButton = app.buttons["View people who like this"]
        viewLikeButton.tap()
        
        
        let backLike = app.navigationBars["People who like this"].children(matching: .button).element
        backLike.tap()
        
        let shareButton = app.buttons["big share"]
        shareButton.tap()

        let cancelShare = app.sheets["Share Post"].scrollViews.otherElements.buttons["Cancel"]
        cancelShare.tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .image).element.swipeLeft()
        
        let closeButton = app.buttons["big cancel"]
        closeButton.tap()
        
        sleep(5)
        
        //Covering Comments
        let commentBtn = myTable.cells["cell_no_0"].buttons["comment"]
        XCTAssertTrue(commentBtn.exists)
        commentBtn.tap()
        
        app.typeText("😍😍😍😍😍 This is my test comment...! #MastMalang.. 😍")
        
        let sendBtn = app.buttons["send"]
        XCTAssertTrue(sendBtn.exists)
        sendBtn.tap()
        let viewAllCommentButton = myTable.cells["cell_no_0"].buttons["View all comments"]
        
        if viewAllCommentButton.exists{
            viewAllCommentButton.tap()
        }else{
            let commentLabelTap = cell.staticTexts["commentLabel"]
            commentLabelTap.tap()
        }
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
        
        app.typeText("😍😍😍😍😍 This is my test comment...! #MastMalang.. 😍")
        sleep(5)
        app.navigationBars["Comments"].buttons["Back"].tap()
        
    }
}
