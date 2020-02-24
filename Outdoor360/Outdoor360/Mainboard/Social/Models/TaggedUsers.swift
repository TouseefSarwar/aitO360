//
//  File.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 05/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import  SwiftyJSON
class TaggedUsers{
    
    var tagged_user_id : String?
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var front_user_name_slug : String?
    var user_image : String?
    
    init() {
    }
    init(tagJSON : JSON) {
        self.tagged_user_id = tagJSON["tagged_user_id"].stringValue
        self.front_user_id = tagJSON["front_user_id"].stringValue
        self.first_name = tagJSON["first_name"].stringValue
        self.last_name = tagJSON["last_name"].stringValue
        self.front_user_name_slug = tagJSON["front_user_name_slug"].stringValue
        self.user_image = tagJSON["user_image"].stringValue
    }
}
