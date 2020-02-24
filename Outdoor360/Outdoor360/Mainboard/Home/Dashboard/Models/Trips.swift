//
//  Trips.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 19/09/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Trips{
    var additionalGuest : String?
    var address : String?
    var assignTo : String?
    var deposit : String?
    var depositPercent : String?
    var descriptionField : String?
    var guest : String?
    var guideImage : String?
    var guideName : String?
    var image : String?
    var lat : String?
    var longField : String?
    var slug : String?
    var status : String?
    var title : String?
    var tripId : String?
    var tripLink : String?
    var tripLink2 : String?
    var tripRate : String?
    var tripType : String?
    var whatToBring : String?
    
    
    
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        additionalGuest = json["additional_guest"].stringValue
        address = json["address"].stringValue
        assignTo = json["assign_to"].stringValue
        deposit = json["deposit"].stringValue
        depositPercent = json["deposit_percent"].stringValue
        descriptionField = json["description"].stringValue
        guest = json["guest"].stringValue
        guideImage = json["guide_image"].stringValue
        guideName = json["guide_name"].stringValue
        image = json["image"].stringValue
        lat = json["lat"].stringValue
        longField = json["long"].stringValue
        slug = json["slug"].stringValue
        status = json["status"].stringValue
        title = json["title"].stringValue
        tripId = json["trip_id"].stringValue
        tripLink = json["trip_link"].stringValue
        tripLink2 = json["trip_link_2"].stringValue
        tripRate = json["trip_rate"].stringValue
        tripType = json["trip_type"].stringValue
        whatToBring = json["what_to_bring"].stringValue
    }
}
