//
//  OtherProfile.swift
//  OtherProfile
//
//  Created by Touseef Sarwar on 19/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class OtherProfile: XCTestCase {

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
        //MARK: Image Controlles from here
        let myTable = app.tables.matching(identifier: "feedsList")
        let cell = myTable.cells["cell_no_0"]
        cell.children(matching: .image).element.tap()
        
        let tablesQuery = app.tables.matching(identifier: "otherProfile").cells["cell_no_0"]
        
        //About section....
                                
        let viewAboutButton = tablesQuery.buttons["View More"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: viewAboutButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(viewAboutButton.exists)
        viewAboutButton.tap()

        
                
        let backAbout = app.navigationBars["About"].buttons["Back"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backAbout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backAbout.exists)
        backAbout.tap()
        
        
        //Followers section....
        let viewFollowersButton = tablesQuery.buttons["View Followers"]
        XCTAssertTrue(viewFollowersButton.exists)
        viewFollowersButton.tap()
        sleep(5)
        
        let backFollower = app.navigationBars["Followers"].buttons["Back"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backFollower, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backFollower.exists)
        backFollower.tap()

        //Photos section....
        let viewPhotoButton = tablesQuery.buttons["View Photos"]
        XCTAssertTrue(viewPhotoButton.exists)
        viewPhotoButton.tap()
        sleep(5)
        let backPhotos = app.navigationBars["Photos"].buttons["Back"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backPhotos, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backPhotos.exists)
        backPhotos.tap()
        
        
        app.swipeUp()
        
        //Videos section....
        
        let viewVideosButton = tablesQuery.buttons["View Videos"]
        XCTAssertTrue(viewVideosButton.exists)
        viewVideosButton.tap()
        sleep(5)
        let backVideos = app.navigationBars["Videos"].buttons["Back"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backVideos, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backVideos.exists)
        backVideos.tap()
        
        //Albums section....
        let viewAlbumsButton = tablesQuery.buttons["View Albums"]
        XCTAssertTrue(viewAlbumsButton.exists)
        viewAlbumsButton.tap()
        sleep(5)
        let backAlbums = app.navigationBars["Albums"].buttons["Back"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backAlbums, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backAlbums.exists)
        backAlbums.tap()
        
        //Maps section....
        
        let viewMapButton = tablesQuery.buttons["View Map"]
        XCTAssertTrue(viewMapButton.exists)
        viewMapButton.tap()
        sleep(10)
        let backMap = app.navigationBars["Photos Map"].buttons["Back"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backMap, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backMap.exists)
        backMap.tap()
        
        app.swipeUp()
        app.swipeUp()
        
        sleep(10)
        
        let backProfile = app.navigationBars["Outdoor360.OthersView"].children(matching: .button).element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backProfile, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        backProfile.tap()
        
        
        //MARK: User Name Controlles from here
        cell.buttons["userName"].tap()
        
        //About section....
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: viewAboutButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(viewAboutButton.exists)
        viewAboutButton.tap()

        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backAbout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backAbout.exists)
        backAbout.tap()
        
        
        //Followers section....
        XCTAssertTrue(viewFollowersButton.exists)
        viewFollowersButton.tap()
        sleep(5)
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backFollower, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backFollower.exists)
        backFollower.tap()

        //Photos section....
        
        XCTAssertTrue(viewPhotoButton.exists)
        viewPhotoButton.tap()
        sleep(5)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backPhotos, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backPhotos.exists)
        backPhotos.tap()
        
        
        app.swipeUp()
        
        //Videos section....
        

        XCTAssertTrue(viewVideosButton.exists)
        viewVideosButton.tap()
        sleep(5)

        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backVideos, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backVideos.exists)
        backVideos.tap()
        
        
        //Albums section....
        
        XCTAssertTrue(viewAlbumsButton.exists)
        viewAlbumsButton.tap()
        sleep(5)
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backAlbums, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backAlbums.exists)
        backAlbums.tap()
        
        
        
        //Maps section....
        
        
        XCTAssertTrue(viewMapButton.exists)
        viewMapButton.tap()
        sleep(10)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backMap, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backMap.exists)
        backMap.tap()
        
        app.swipeUp()
        
        sleep(10)
        
        app.swipeUp()
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backProfile, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        backProfile.tap()
        sleep(5)
        
        app.terminate()
        
        sleep(5)
        
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let signInButton = app.buttons["SIGN IN"]
        
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
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
        sleep(15)
        
        let commentBtn = myTable.cells["cell_no_0"].buttons["comment"]
        XCTAssertTrue(commentBtn.exists)
        commentBtn.tap()
        
        app.typeText("😍😍😍😍😍 This is my test comment...! #MastMalang... 😍")
        
        let sendBtn = app.buttons["send"]
        XCTAssertTrue(sendBtn.exists)
        sendBtn.tap()
        sleep(5)
        
        
        
        
        
        
        
    }

}
