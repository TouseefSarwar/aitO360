//
//  SocialPost.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 07/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class SocialPost {


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
    var thumb_photos : String?
    var small_photos : String?
    var first_name : String?
    var front_user_name_slug : String?
    var lodge_type : String?
    var last_name : String?
    var user_image : String?
    var user_type : String?
    var type : String?
    var favourite_id : Int?
    var tags_count : Int?
    var shared_first_name : String?
    var shared_last_name : String?
    var is_cover : String?
    var link_title : String?
    var link_image : String?
    var link_url : String?
    var link_desc : String?
    var view_type : String?
    var photos : [Photo]?
    var comment : [CommentsResponse]?
    
    init()
    {
        
    }
    
    
    init(postJSON : JSON) {
       
        self.id = postJSON["id"].stringValue
        self.user_id = postJSON["user_id"].stringValue
        self.feed_content = postJSON["feed_content"].stringValue
        self.url_fetched_content = postJSON["url_fetched_content"].stringValue
        self.is_album = postJSON["is_album"].stringValue
        self.album_title = postJSON["album_title"].stringValue
        self.is_shared = postJSON["is_shared"].stringValue
        self.share_caption = postJSON["share_caption"].stringValue
        self.is_tagged = postJSON["is_tagged"].stringValue
        self.feed_favourites = postJSON["feed_favourites"].stringValue
        self.feed_comments = postJSON["feed_comments"].stringValue
        self.original_post_id = postJSON["original_post_id"].stringValue
        self.original_post_owner = postJSON["original_post_owner"].stringValue
        self.created = postJSON["created"].stringValue
        self.status = postJSON["status"].stringValue
        self.deleted = postJSON["deleted"].stringValue
//        self.photos = postJSON["photos"].stringValue
        self.thumb_photos = postJSON["thumb_photos"].stringValue
        self.small_photos = postJSON["small_photos"].stringValue
//        self.photos_id = postJSON["photos_id"].stringValue
//        self.photos_type = postJSON["photos_type"].stringValue
        self.first_name = postJSON["first_name"].stringValue
        self.front_user_name_slug = postJSON["front_user_name_slug"].stringValue
        self.lodge_type = postJSON["lodge_type"].stringValue
        self.last_name = postJSON["last_name"].stringValue
        self.user_image = postJSON["user_image"].stringValue
        self.user_type = postJSON["user_type"].stringValue
        self.type = postJSON["type"].stringValue
        self.favourite_id = postJSON["favourite_id"].intValue
        self.tags_count = postJSON["tags_count"].intValue
        self.shared_first_name = postJSON["shared_first_name"].stringValue
        self.shared_last_name = postJSON["shared_last_name"].stringValue
        self.is_cover = postJSON["is_cover"].stringValue
        self.link_image = postJSON["link_image"].stringValue
        self.link_url = postJSON["link_url"].stringValue
        self.link_desc = postJSON["link_desc"].stringValue
        self.link_title = postJSON["link_title"].stringValue
        self.view_type = postJSON["view_type"].stringValue
//        self.photo_width = postJSON["photo_width"].floatValue
//        self.photo_height = postJSON["photo_height"].floatValue
        
        self.photos = [Photo]()
        let  p = postJSON["photos"].arrayValue
        for i in p {
            let val = Photo(photoData: i)
            self.photos?.append(val)
        }
        
        self.comment = [CommentsResponse]()
        let c = postJSON["comments"].arrayValue
        for i in c{
            let val = CommentsResponse(commentJSON: i)
            self.comment?.append(val)
        }
        
    }
}
