//
//  AlbumPhoto.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 13/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class AlbumPhoto{
    var id : String?
    var photo : String?
    var lat : String?
    var long : String?
    var like_count : String?
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var slug : String?
    var user_image : String?
    var favourite_id : String?
    
    init() {
        
    }
    init(albumPhotos : JSON) {
        self.id = albumPhotos["id"].string
        self.photo = albumPhotos["photo"].string
        self.lat = albumPhotos["lat"].string
        self.long = albumPhotos["long"].string
        self.like_count = albumPhotos["like_count"].string
        self.front_user_id = albumPhotos["front_user_id"].string
        self.first_name = albumPhotos["first_name"].string
        self.last_name = albumPhotos["last_name"].string
        self.slug = albumPhotos["slug"].string
        self.user_image = albumPhotos["user_image"].string
        self.favourite_id = albumPhotos["favourite_id"].string
    }
}

