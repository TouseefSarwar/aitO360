//
//  VideoProfile.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 12/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoProfile {
    var id : String?
    var feed_id : String?
    var user_id : String?
    var original_post_id : String?
    var original_post_owner : String?
    var type: String?
    var is_album : String?
    var is_shared : String?
    var shared_from_table : String?
    var is_tagged : String?
    var feed_favourites : String?
    var feed_comments : String?
    var created : String?
    var is_renamed : String?
    var lat : String?
    var long : String?
    var deleted : String?
    var video : String?
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var slug : String?
    var user_image : String?
    var favourite_id : String?
    var tag_count : String?
    
    init() {
    }
    init(videoJSON: JSON) {
        self.id = videoJSON["id"].stringValue
        self.feed_id = videoJSON["feed_id"].stringValue
        self.user_id = videoJSON["user_id"].stringValue
        self.type = videoJSON["type"].stringValue
        self.is_album = videoJSON["is_album"].stringValue
        self.is_shared = videoJSON["is_shared"].stringValue
        self.shared_from_table = videoJSON["shared_from_table"].stringValue
        self.is_tagged = videoJSON["is_tagged"].stringValue
        self.feed_favourites = videoJSON["feed_favourites"].stringValue
        self.feed_comments = videoJSON["feed_comments"].stringValue
        self.original_post_id = videoJSON["original_post_id"].stringValue
        self.original_post_owner = videoJSON["original_post_owner"].stringValue
        self.created = videoJSON["created"].stringValue
        self.is_renamed = videoJSON["is_renamed"].stringValue
        self.deleted = videoJSON["deleted"].stringValue
        self.lat = videoJSON["lat"].stringValue
        self.video = videoJSON["video"].stringValue
        self.front_user_id = videoJSON["front_user_id"].stringValue
        self.first_name = videoJSON["first_name"].stringValue
        self.last_name = videoJSON["last_name"].stringValue
        self.user_image = videoJSON["user_image"].stringValue
        self.favourite_id = videoJSON["favourite_id"].stringValue
        self.tag_count = videoJSON["tag_count"].stringValue
    }
}
