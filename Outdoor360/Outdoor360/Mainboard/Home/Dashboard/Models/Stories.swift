//
//  Stories.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 19/09/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Stories{
    var iD : String?
    var blogLink : String?
    var image : String?
    var postContent : String?
    var postDate : String?
    var postName : String?
    var postStatus : String?
    var postTitle : String?
    var postType : String?
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        iD = json["ID"].stringValue
        blogLink = json["blog_link"].stringValue
        image = json["image"].stringValue
        postContent = json["post_content"].stringValue
        postDate = json["post_date"].stringValue
        postName = json["post_name"].stringValue
        postStatus = json["post_status"].stringValue
        postTitle = json["post_title"].stringValue
        postType = json["post_type"].stringValue
    }
    
}
