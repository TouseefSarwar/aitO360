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
        //TODO: Uncomment tap when run on browserStack.
//        app.tap()
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
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
            
            XCTAssertTrue(doneButton.exists)
            doneButton.tap()
            let loginButton = elementsQuery.buttons["Login"]
            XCTAssertTrue(loginButton.exists)
            loginButton.tap()
        }
        sleep(10)
        
        let plusButton = app.otherElements["Plus Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: plusButton, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertTrue(plusButton.exists)
        plusButton.tap()
    
//        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 0).tap()
        
        let createPost = app.otherElements["Create Album"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: createPost, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertTrue(createPost.exists)
        createPost.tap()
        
        let textView = app.textViews["captionText"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: textView, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertTrue(textView.exists)
        textView.tap()
        
        textView.typeText("😍😍😍😍😍 This is a test post to test photos with smiles and HashTags...! #MastMalang.. 😍")
        
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        
        
        
        let cameraButton = app.buttons["image"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: cameraButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(cameraButton.exists)
        cameraButton.tap()
        
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Access Your Photos"){ alert in
            if alert.buttons["OK"].exists{
                alert.buttons["OK"].tap()
                return true
            }
            app.tap()
            return false
        }
        //TODO: On this tap when test is run on the BrowserStack.....
//        app.tap()
        
        sleep(15)
//        app.alerts["“Outdoors360” Would Like to Access Your Photos"].scrollViews.otherElements.buttons["OK"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars.buttons["Done"].tap()
        sleep(10)
        
        let createTable = app.tables.matching(identifier: "CreatePostTable")
        let cell0 = createTable.cells["cell_no_0"]
        let tablesQuery = app.tables
        
        //location for 1st cell
        let loc0 = cell0.buttons.matching(identifier: "location").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: loc0, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        loc0.tap()
        sleep(5)
        
        app.keys["L"].tap()
        app.keys["o"].tap()
        app.keys["s"].tap()
        app.keys["space"].tap()
        app.keys["a"].tap()
        app.keys["n"].tap()
        app.keys["g"].tap()
//        app.tables.children(matching: .cell).element(boundBy: 0).tap()
        sleep(10)
        app.tables.staticTexts["Los Angeles"].tap()
                
        //tag people for 1st cell
        var tag = cell0.buttons.matching(identifier: "peopleTag").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: tag, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        tag.tap()
        sleep(10)
        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 3).tap()
        app.navigationBars.buttons["Tag"].tap()
        
        //species Tag for 1st cell
        var specyTag = cell0.buttons.matching(identifier: "speciesTag").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: specyTag, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        specyTag.tap()
        sleep(10)

        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        app.navigationBars.buttons["Tag"].tap()
        
        let cell1 = createTable.cells["cell_no_1"]
                
        //tag people for 1st cell
        tag = cell1.buttons.matching(identifier: "peopleTag").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: tag, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        tag.tap()
        sleep(10)

        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()

        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        
        app.navigationBars.buttons["Tag"].tap()
        
        //species Tag for 1st cell
        specyTag = cell1.buttons.matching(identifier: "speciesTag").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: specyTag, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        specyTag.tap()
        
        sleep(10)

        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()

        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        
        tablesQuery.children(matching: .cell).element(boundBy: 3).tap()
        
        tablesQuery.children(matching: .cell).element(boundBy: 4).tap()
        
        app.navigationBars.buttons["Tag"].tap()
        
        let cell2 = createTable.cells["cell_no_2"]
        

               
               
               
        //tag people for 1st cell
        tag = cell2.buttons.matching(identifier: "peopleTag").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: tag, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        tag.tap()
        sleep(10)

        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()

        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        
        tablesQuery.children(matching: .cell).element(boundBy: 3).tap()
        
        tablesQuery.children(matching: .cell).element(boundBy: 4).tap()
        
       
        app.navigationBars.buttons["Tag"].tap()
       
       //species Tag for 1st cell
        specyTag = cell2.buttons.matching(identifier: "speciesTag").element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: specyTag, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        specyTag.tap()
       
        sleep(10)

        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()

        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 3).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 4).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 5).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 6).tap()
        tablesQuery.children(matching: .cell).element(boundBy: 7).tap()

        app.navigationBars.buttons["Tag"].tap()

        let postButton = app.buttons["Post"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: postButton, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertTrue(postButton.exists)
        postButton.tap()
        
        
        let rightBarButton = app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightBarButton, handler: nil)
        waitForExpectations(timeout: 360, handler: nil)
        XCTAssertTrue(rightBarButton.exists)
//        rightBarButton.tap()
//
//        let cancelButton = app.buttons["big cancel"]
//        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: cancelButton, handler: nil)
//        waitForExpectations(timeout: 20, handler: nil)
//        XCTAssertTrue(cancelButton.exists)
//        cancelButton.tap()
        
        
        //MARK: Feeds Test Start from here...
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
        
        let textViewComnment = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textViewComnment.tap()
        textViewComnment.typeText("😍😍😍😍😍 This is my test comment on a photo yooo ...! #MastMalang.. 😍")
        
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
        
        
        app.terminate()
        
        
        sleep(10)
        
        
       
        //MARK: SHARE POST Start from here...
        app.launch()
        sleep(20)
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
        
//        let myTable = app.tables.matching(identifier: "feedsList")

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
        
        //MARK: Share on Other Social Network.
//        let shareButton = myTable.cells["cell_no_0"].buttons["share"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: shareButton, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertTrue(shareButton.exists)
        shareButton.tap()
        
        let shareToSocial = app.sheets["Select the social network you wish to share post on."].scrollViews.otherElements.buttons["Share to Social Network"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: shareToSocial, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(shareToSocial.exists)
        shareToSocial.tap()
        
        
    }

 
}
