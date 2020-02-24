//
//  NotificationResponse.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 21/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationResponse{
    
    var notification_id : String?
    var front_user_id : String?
    var user_image : String?
    var user_name : String?
    var post_user_name : String?
    var type : String?
    var target_type : String?
    var post_id : String?
    var shared_post_id : String?
    var photo_id : String?
    var comment_id : String?
    var is_followed : String?
    var status : String?
    var created_date : String?
    
    init() {}
    init(notificationJSON : JSON) {
        self.notification_id = notificationJSON["notification_id"].stringValue
        self.front_user_id = notificationJSON["front_user_id"].stringValue
        self.user_image = notificationJSON["user_image"].stringValue
        self.user_name = notificationJSON["user_name"].stringValue
        self.post_user_name = notificationJSON["post_user_name"].stringValue
        self.type = notificationJSON["type"].stringValue
        self.target_type = notificationJSON["target_type"].stringValue
        self.post_id = notificationJSON["post_id"].stringValue
        self.photo_id = notificationJSON["photo_id"].stringValue
        self.comment_id = notificationJSON["comment_id"].stringValue
        self.shared_post_id = notificationJSON["shared_post_id"].stringValue
        self.is_followed = notificationJSON["is_followed"].stringValue
        self.status = notificationJSON["status"].stringValue
        self.created_date = notificationJSON["created_date"].stringValue
        
    }
}



