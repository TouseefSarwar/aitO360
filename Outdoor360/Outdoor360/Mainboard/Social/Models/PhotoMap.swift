//
//  PhotoMap.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 14/05/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class PhotoMaps {
    
    var id : String?
    var photo : String?
    var lat : Double?
    var long : Double?
    var like_count : String?
    
    
    init() {
    }
    init(photoJSON : JSON) {
        self.id = photoJSON["id"].stringValue
        self.photo = photoJSON["photo"].stringValue
        self.lat = photoJSON["lat"].doubleValue
        self.long = photoJSON["long"].doubleValue
        self.like_count = photoJSON["like_count"].stringValue
    }
}
