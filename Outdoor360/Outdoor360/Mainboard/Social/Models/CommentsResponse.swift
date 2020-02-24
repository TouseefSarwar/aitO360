//
//  CommentsResponse.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 15/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentsResponse : NSObject{
    
        var id : String?
        var feed_id : String?
        var user_id : String?
        var comment : String?
        var comment_id : String?
        var associated_table : String?
        var created : String?
        var front_user_id : String?
        var first_name : String?
        var front_user_name_slug : String?
        var lodge_type : String?
        var last_name : String?
        var user_image : String?
        var user_type : String?
        var type : String?
        var is_favorite : String?
        var view_type : String?
        var reply_count : String?
    override init() {
    }
    init(commentJSON : JSON) {
        self.id = commentJSON["id"].stringValue
        self.feed_id = commentJSON["feed_id"].stringValue
        self.user_id = commentJSON["user_id"].stringValue
        self.comment = commentJSON["comment"].stringValue
        self.comment_id = commentJSON["comment_id"].stringValue
        self.associated_table = commentJSON["associated_table"].stringValue
        self.created = commentJSON["created"].string
        self.front_user_id = commentJSON["front_user_id"].stringValue
        self.first_name = commentJSON["first_name"].stringValue
        self.front_user_name_slug = commentJSON["front_user_name_slug"].stringValue
        self.lodge_type = commentJSON["lodge_type"].stringValue
        self.last_name = commentJSON["last_name"].stringValue
        self.user_image = commentJSON["user_image"].stringValue
        self.user_type = commentJSON["user_type"].stringValue
        self.type = commentJSON["type"].stringValue
        self.is_favorite = commentJSON["is_favorite"].stringValue
        self.view_type = commentJSON["view_type"].stringValue
        self.reply_count = commentJSON["reply_count"].stringValue
    }
    
}

