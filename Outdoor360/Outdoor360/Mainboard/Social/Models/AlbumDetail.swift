//
//  AlbumDetail.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 13/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class ALbumDetail{
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
    var tagged_count : String?
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var slug : String?
    var user_image : String?
    var favourite_id : String?
    
    init() {
    }
    init(albumDetail: JSON) {
        
        self.id = albumDetail["id"].stringValue
        self.user_id = albumDetail["user_id"].stringValue
        self.feed_content = albumDetail["feed_content"].stringValue
        self.url_fetched_content = albumDetail["url_fetched_content"].stringValue
        self.is_album = albumDetail["is_album"].stringValue
        self.album_title = albumDetail["album_title"].stringValue
        self.is_shared = albumDetail["is_shared"].stringValue
        self.shared_from_table = albumDetail["shared_from_table"].stringValue
        self.share_caption = albumDetail["share_caption"].stringValue
        self.is_tagged = albumDetail["is_tagged"].stringValue
        self.feed_favourites = albumDetail["feed_favourites"].stringValue
        self.feed_comments = albumDetail["feed_comments"].stringValue
        self.original_post_id = albumDetail["original_post_id"].stringValue
        self.original_post_owner = albumDetail["original_post_owner"].stringValue
        self.created = albumDetail["created"].stringValue
        self.status = albumDetail["status"].stringValue
        self.deleted = albumDetail["deleted"].stringValue
        self.tagged_count = albumDetail["tagged_count"].stringValue
        self.front_user_id = albumDetail["front_user_id"].stringValue
        self.first_name = albumDetail["first_name"].stringValue
        self.last_name = albumDetail["last_name"].stringValue
        self.slug = albumDetail["slug"].stringValue
        self.user_image = albumDetail["user_image"].stringValue
        self.favourite_id = albumDetail["favourite_id"].stringValue
    }
}
