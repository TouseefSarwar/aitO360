//
//  LoginResponse.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 02/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginSignupResponse {
    
    var email : String?
    var password : String?
    var front_user_id : String?
    var status : String?
    var mobile_number : String?
    var sms_verified : String?
    var first_name : String?
    var last_name : String?
    var user_image : String?
    var social_type : String?
    init() {
    }
    init(LoginData : JSON) {
        self.email = LoginData["email_address"].stringValue
        self.password = LoginData["password"].stringValue
        self.front_user_id = LoginData["front_user_id"].stringValue
        self.mobile_number = LoginData["mobile_number"].stringValue
        self.status = LoginData["status"].stringValue
        self.sms_verified = LoginData["sms_verified"].stringValue
        self.first_name = LoginData["first_name"].stringValue
        self.last_name = LoginData["last_name"].stringValue
        self.user_image = LoginData["user_image"].stringValue
        self.social_type = LoginData["social_type"].stringValue
    }

}
