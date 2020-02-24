//
//  AlbumProfile.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 12/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class AlbumProfile{
    
    var id : String?
    var user_id : String?
    var feed_content : String?
    var url_fetched_content : String?
    var is_album : String?
    var album_title : String?
    var is_shared : String?
    var shared_from_table : String?
    var share_caption : String?
    var is_tagged : String?
    var feed_favourites : String?
    var feed_comments : String?
    var original_post_id : String?
    var original_post_owner : String?
    var created : String?
    var status : String?
    var deleted : String?
    var album_col_id : String?
    var feed_id : String?
    var photo : String?
    var photo_count : String?
    
    
    
    init() {
    }
    
    
    init(albumJSON: JSON) {
       
        self.id = albumJSON["id"].stringValue
        self.user_id = albumJSON["user_id"].stringValue
        self.feed_content = albumJSON["feed_content"].stringValue
        self.url_fetched_content = albumJSON["url_fetched_content"].stringValue
        self.is_album = albumJSON["is_album"].stringValue
        self.album_title = albumJSON["album_title"].stringValue
        self.is_shared = albumJSON["is_shared"].stringValue
        self.shared_from_table = albumJSON["shared_from_table"].stringValue
        self.share_caption = albumJSON["share_caption"].stringValue
        self.is_tagged = albumJSON["is_tagged"].stringValue
        self.feed_favourites = albumJSON["feed_favourites"].stringValue
         self.feed_comments = albumJSON["feed_comments"].stringValue
         self.original_post_id = albumJSON["original_post_id"].stringValue
         self.original_post_owner = albumJSON["original_post_owner"].stringValue
         self.created = albumJSON["created"].stringValue
        self.status = albumJSON["status"].stringValue
        self.deleted = albumJSON["deleted"].stringValue
        self.album_col_id = albumJSON["album_col_id"].stringValue
        self.feed_id = albumJSON["feed_id"].stringValue
        self.photo = albumJSON["photo"].stringValue
        self.photo_count = albumJSON["photo_count"].stringValue
    }
}

