//
//  Reports.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 19/09/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Reports {
    var address : String?
    var descriptionField : String?
    var image : String?
    var lat : String?
    var longField : String?
    var reportId : String?
    var reportLink : String?
    var reportType : String?
    var slug : String?
    var status : String?
    var title : String?
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        descriptionField = json["description"].stringValue
        image = json["image"].stringValue
        lat = json["lat"].stringValue
        longField = json["long"].stringValue
        reportId = json["report_id"].stringValue
        reportLink = json["report_link"].stringValue
        reportType = json["report_type"].stringValue
        slug = json["slug"].stringValue
        status = json["status"].stringValue
        title = json["title"].stringValue
    }

}
