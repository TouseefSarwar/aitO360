//
//  SignUp.swift
//  SignUp
//
//  Created by Touseef Sarwar on 29/01/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import XCTest

class SignUp: XCTestCase {

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

        
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
        sleep(15)
        let signupButton = app.buttons["SIGN UP"]
        if signupButton.exists{
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signupButton, handler: nil)
            waitForExpectations(timeout: 25, handler: nil)
            XCTAssertTrue(signupButton.exists)
            signupButton.tap()
        }else{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 20, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signupButton, handler: nil)
            waitForExpectations(timeout: 20, handler: nil)
            XCTAssertTrue(signupButton.exists)
            signupButton.tap()
        }
        
        sleep(15)
        let signUpWithEmail = app.buttons["Sign up with email"]
        XCTAssertTrue(signUpWithEmail.exists)
        signUpWithEmail.tap()
        
        let no = arc4random_uniform(1000)
        print(no)
        let emailTextFeild = app.textFields["Email"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: emailTextFeild, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(emailTextFeild.exists)
        emailTextFeild.tap()
        emailTextFeild.typeText("abc\(no)@gmail.com")
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        let rightArrowButton = app.buttons["right arrow"]
        XCTAssertTrue(rightArrowButton.exists)
        rightArrowButton.tap()
        
        let fNameTextFeild = app.textFields["First Name"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: fNameTextFeild, handler: nil)
        waitForExpectations(timeout: 25, handler: nil)
        XCTAssertTrue(fNameTextFeild.exists)
        fNameTextFeild.tap()
        fNameTextFeild.typeText("Cristiano")
        
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText("Ronaldo")
        
        doneButton.tap()
        rightArrowButton.tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: passwordSecureTextField, handler: nil)
        waitForExpectations(timeout: 25, handler: nil)
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Abcd1234")
        
        
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        XCTAssertTrue(confirmPasswordSecureTextField.exists)
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("Abcd1234")
        
        doneButton.tap()
        rightArrowButton.tap()
        
        let mobileTextField = app.textFields["Mobile"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: mobileTextField, handler: nil)
        waitForExpectations(timeout: 25, handler: nil)
        XCTAssertTrue(mobileTextField.exists)
        mobileTextField.tap()
        app.typeText("1111111111")
        
        doneButton.tap()
        rightArrowButton.tap()
        
        sleep(30)
        let key = app.keys["0"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: key, handler: nil)
        waitForExpectations(timeout: 120, handler: nil)
        XCTAssertTrue(key.exists)
        key.tap()
        
        let key2 = app.keys["3"]
        key2.tap()
        
        let key3 = app.keys["2"]
        key3.tap()
        
        key2.tap()
        
        sleep(15)
        app.swipeUp()
        
        app.swipeUp()
        
        app.terminate()
        
        //MARK: Facebook Signup
        
        app.launch()
        sleep(15)

        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
          
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
        let signUpButton = app.buttons["SIGN UP"]
        if !signUpButton.exists{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 10, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
        }
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signUpButton, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
      
        let signUpWithFacebookButton = XCUIApplication().buttons["Sign up with Facebook"]
        signUpWithFacebookButton.tap()
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
        sleep(5)
        
        app.terminate()
        
        
        sleep(10)
        //MARK: Google Signup
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let signUpButton = app.buttons["SIGN UP"]
        sleep(15)
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
        if !signUpButton.exists{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
        }
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signUpButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let signUpWithGoogleButton = XCUIApplication().buttons["Sign up with Google"]
        signUpWithGoogleButton.tap()
                        
        addUIInterruptionMonitor(withDescription: "“Outdoor360” Wants to Use “google.com” to Sign In") { alert in
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
        sleep(5)
        
        app.terminate()
        
        //MARK: Twitter....
        app.launch()
        sleep(15)
        addUIInterruptionMonitor(withDescription: "“Outdoors360” Would Like to Send You Notifications"){ alert in
            
            if alert.buttons["Allow"].exists{
                alert.buttons["Allow"].tap()
                return true
            }
            return false
        }
        app.tap()
        if !signUpButton.exists{
            let rightButton =  app.navigationBars["Outdoor360.NewFeedsView"].images["profile"]
            expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: rightButton, handler: nil)
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertTrue(rightButton.exists)
            rightButton.tap()
            app.buttons["Sign out"].tap()
        }
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signUpButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let signUpWithTwitterButton = XCUIApplication().buttons["Sign up with Twitter"]
        signUpWithTwitterButton.tap()
        
        sleep(5)
        
    }
    
}
