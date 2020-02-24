//
//  Follower.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 30/10/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class Follower{
    
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var user_image : String?
    var is_followed : String?
    
    
    init() {
    }
    
    init(followerJSON : JSON) {
        self.front_user_id = followerJSON["front_user_id"].stringValue
        self.first_name = followerJSON["first_name"].stringValue
        self.last_name = followerJSON["last_name"].stringValue
        self.user_image = followerJSON["user_image"].stringValue
        self.is_followed = followerJSON["is_followed"].stringValue
        
    }
    
}
