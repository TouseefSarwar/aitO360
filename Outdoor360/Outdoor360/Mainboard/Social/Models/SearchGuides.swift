//
//  SearchGuides.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 18/04/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchGuides {
    
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var front_user_name_slug : String?
    var user_image : String?
    var full_name : String?
    
    
    init() {
    }
    
    init(searchGuides : JSON) {
        self.front_user_id = searchGuides["front_user_id"].stringValue
        self.first_name = searchGuides["first_name"].stringValue
        self.last_name = searchGuides["last_name"].stringValue
        self.front_user_name_slug = searchGuides["front_user_name_slug"].stringValue
        self.user_image = searchGuides["user_image"].stringValue
        self.full_name = searchGuides["full_name"].stringValue
        
    }
    
}
