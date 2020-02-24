//
//  MyProfile.swift
//  MyProfile
//
//  Created by Touseef Sarwar on 18/02/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class MyProfile: XCTestCase {

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
        
       
        let profileTab  = app.tabBars.buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: profileTab, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(profileTab.exists)
        profileTab.tap()
        let tablesQuery = app.tables.matching(identifier: "profileList").cells["cell_no_0"]
        
        
        //MARK: Edit Profile
        let editProfileButton = app.tables["profileList"].buttons["Edit Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: editProfileButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
                editProfileButton.tap()
        
        app.textFields["First Name"].tap()
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.press(forDuration: 1.4)
        app.typeText("Johny")
        
        app.textFields["Last Name "].tap()
        deleteKey.press(forDuration: 1.4)
        app.typeText("Doee")
        
        app.textFields["Mobile"].tap()
        app.keys["Delete"].press(forDuration: 3);
                
        app.typeText("3133301407")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.textFields["Date of birth"].tap()
        
        app.datePickers.pickerWheels["2020"].swipeDown()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        window.toolbars["Toolbar"].buttons["Done"].tap()
        window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.navigationBars["Edit Profile"].buttons["Update"].tap()
        
        //MARK: About section....
        let viewAboutButton = tablesQuery.buttons["View More"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: viewAboutButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(viewAboutButton.exists)
        viewAboutButton.tap()

        
        let backAbout = app.navigationBars["About"].buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backAbout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backAbout.exists)
        backAbout.tap()
        
        
        //MARK: Followers section....
        let viewFollowersButton = tablesQuery.buttons["View Followers"]
        XCTAssertTrue(viewFollowersButton.exists)
        viewFollowersButton.tap()
        sleep(5)
        
        let followersTable = app.tables.cells.element(boundBy: 0)
        followersTable.buttons["followButton"].tap()
        sleep(5)
        followersTable.staticTexts["Name"].tap()
        
        
        app.navigationBars["Outdoor360.OthersView"].children(matching: .button).element.tap()
        
        let backFollower = app.navigationBars["Followers"].buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backFollower, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backFollower.exists)
        backFollower.tap()

        //MARK: Photos section....
        let viewPhotoButton = tablesQuery.buttons["View Photos"]
        XCTAssertTrue(viewPhotoButton.exists)
        viewPhotoButton.tap()
        sleep(5)
        
        
        
        app.collectionViews.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.tap()
        app.buttons["big tag"].tap()
        app.navigationBars["Tagged"].buttons["Add"].tap()
        app.navigationBars["Add Tag"].children(matching: .button).element(boundBy: 0).tap()
        app.navigationBars["Tagged"].children(matching: .button).element(boundBy: 0).tap()
        
        app.buttons["big cancel"].tap()
        
                
        let backPhotos = app.navigationBars["Photos"].buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backPhotos, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backPhotos.exists)
        backPhotos.tap()
        
        
        app.swipeUp()
        
        //MARK: Videos section....
        
        let viewVideosButton = tablesQuery.buttons["View Videos"]
        XCTAssertTrue(viewVideosButton.exists)
        viewVideosButton.tap()
        sleep(5)
        let backVideos = app.navigationBars["Videos"].buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backVideos, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backVideos.exists)
        backVideos.tap()
        
        
        //MARK: Albums section....
        
        let viewAlbumsButton = tablesQuery.buttons["View Albums"]
        XCTAssertTrue(viewAlbumsButton.exists)
        viewAlbumsButton.tap()
        sleep(5)
        let backAlbums = app.navigationBars["Albums"].buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backAlbums, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backAlbums.exists)
        backAlbums.tap()
        
        
        
        //MARK: Maps section....
        
        let viewMapButton = tablesQuery.buttons["View Map"]
        XCTAssertTrue(viewMapButton.exists)
        viewMapButton.tap()
        sleep(10)
        let backMap = app.navigationBars["Photos Map"].buttons["Profile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backMap, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backMap.exists)
        backMap.tap()
        
        app.swipeUp()
        app.swipeUp()
        
        
        sleep(10)
        
    }

}
