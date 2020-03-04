//
//  Login.swift
//  Login
//
//  Created by Touseef Sarwar on 27/01/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class Login: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample () {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
        sleep(15)
        let signInButton = app.buttons["SIGN IN"]
        if signInButton.exists{
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signInButton, handler: nil)
            waitForExpectations(timeout: 25, handler: nil)
            XCTAssertTrue(signInButton.exists)
            signInButton.tap()
        }else{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]  
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 25, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signInButton, handler: nil)
            waitForExpectations(timeout: 25, handler: nil)
            XCTAssertTrue(signInButton.exists)
            signInButton.tap()
        }
        sleep(15)
        let elementsQuery = app.scrollViews.otherElements
        let emailTextField = elementsQuery.textFields["Email"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: emailTextField, handler: nil)
        waitForExpectations(timeout: 25, handler: nil)
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("jcgalleries.testemail1@gmail.com")
        let passwordTextField = elementsQuery.secureTextFields["Password"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: passwordTextField, handler: nil)
        waitForExpectations(timeout: 25, handler: nil)
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        let loginButton = elementsQuery.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        sleep(15)
        let tabBarsQuery = app.tabBars
//        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: tabBarsQuery, handler: nil)
//        waitForExpectations(timeout: 10, handler: nil)
        tabBarsQuery.buttons["Search"].tap()
        sleep(5)
        
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        
        tabBarsQuery.buttons["Feeds"].tap()
        
        let profileImage = app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
        profileImage.tap()
        app.buttons["Sign out"].tap()
        sleep(15)
     
        app.terminate()
        
        
        //MARK: Facebook Login....
        
        app.launch()

         // Use recording to get started writing UI tests.
         // Use XCTAssert and related functions to verify your tests produce the correct results.
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
         }else{
             let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
             expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
             waitForExpectations(timeout: 20, handler: nil)
             XCTAssertTrue(rightButton.exists)
             rightButton.tap()
             app.buttons["Sign out"].tap()
             expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signInButton, handler: nil)
             waitForExpectations(timeout: 20, handler: nil)
             XCTAssertTrue(signInButton.exists)
             signInButton.tap()
         }
         
         
        let signInWithFacebookButton = app.buttons["Login with Facebook"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signInWithFacebookButton, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        signInWithFacebookButton.tap()
        addUIInterruptionMonitor(withDescription: "“Outdoor360” Wants to Use “facebook.com” to Sign In") { alert in
            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
                return true
            }

            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
                return true
            }

            let continueButton = alert.buttons["Continue"]
            if continueButton.exists {
                continueButton.tap()
                return true
            }
            return false
        }
        app.tap()
        sleep(5)
        
        
        app.terminate()
        
        //MARK: Google Login....
        
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
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
        }else{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signInButton, handler: nil)
            waitForExpectations(timeout: 7, handler: nil)
            XCTAssertTrue(signInButton.exists)
            signInButton.tap()
        }
        
        
        let signInWithGooglButton = XCUIApplication().buttons["Login with Google"]
        signInWithGooglButton.tap()
                        
        addUIInterruptionMonitor(withDescription: "“Outdoor360” Wants to Use “google.com” to Sign In") {
          (alert) -> Bool in
            let continueButton = alert.buttons["Continue"]
            if continueButton.exists {
                continueButton.tap()
            }
          return true
        }
        app.tap()
        sleep(5)
        
        
        //MARK: Twitter Login...
        
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
        }else{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signInButton, handler: nil)
            waitForExpectations(timeout: 7, handler: nil)
            XCTAssertTrue(signInButton.exists)
            signInButton.tap()
        }
        
        
        let logInWithTwitterButton = app.buttons["Login with Twitter"]
        logInWithTwitterButton.tap()
                        
//        addUIInterruptionMonitor(withDescription: "“Outdoor360” Wants to Use “google.com” to Sign In"){ alert in
//            let continueButton = alert.buttons["Continue"]
//            if continueButton.exists {
//                continueButton.tap()
//            }
//          return true
//        }
        sleep(5)
        
        
    }

}
