//
//  SearchData.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 17/04/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    var id : String?
    var user_image : String?
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var lat : Double?
    var long : Double?
    var photo : String?
    var created : String?
    var thumb_photo : String?
    var small_photo: String?
    var type : String?
    var fav_count : String?
    var comment_count : String?
    var tag_count : String?
    var is_favorite : String?
    var height : Float?
    var width : Float?

   
    init() {
    }
    init(photoData : JSON) {
        
        if photoData.isEmpty{
            return
        }
        
        self.id = photoData["id"].stringValue
        self.photo = photoData["photo"].stringValue
        self.lat = photoData["lat"].doubleValue
        self.long = photoData["long"].doubleValue
        self.created = photoData["created"].stringValue
        self.front_user_id = photoData["front_user_id"].stringValue
        self.first_name = photoData["first_name"].stringValue
        self.last_name = photoData["last_name"].stringValue
        self.user_image = photoData["user_image"].stringValue
        self.thumb_photo = photoData["thumb_photo"].stringValue
        self.small_photo = photoData["small_photo"].stringValue
        self.type = photoData["type"].stringValue
        self.fav_count = photoData["fav_count"].stringValue
        self.comment_count = photoData["comment_count"].stringValue
        self.tag_count = photoData["tag_count"].stringValue
        self.is_favorite = photoData["is_favorite"].stringValue
        self.height = photoData["height"].floatValue
        self.width = photoData["width"].floatValue
    }
    
}
