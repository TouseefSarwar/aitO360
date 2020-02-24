//
//  File.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 22/04/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class Suggested_User {
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var front_user_name_slug : String?
    var user_image : String?
    var date_added : String?
    var front_user_address : String?
    
    init(suggestedJSON : JSON) {
        self.front_user_id = suggestedJSON["front_user_id"].stringValue
        self.first_name = suggestedJSON["first_name"].stringValue
        self.last_name = suggestedJSON["last_name"].stringValue
        self.front_user_name_slug = suggestedJSON["front_user_name_slug"].stringValue
        self.user_image = suggestedJSON["user_image"].stringValue
        self.date_added = suggestedJSON["date_added"].stringValue
        self.front_user_address = suggestedJSON["front_user_address"].stringValue
    }
}
