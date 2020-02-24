//
//  HomeData.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 23/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeData {
    var reports : [Reports]!
    var status : Bool!
    var trips : [Trips]!
    var stories : [Stories]!
    var descriptionField : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        reports = [Reports]()
        let reportsArray = json["reports"].arrayValue
        for reportsJson in reportsArray{
            let value = Reports(fromJson: reportsJson)
            reports.append(value)
        }
        status = json["status"].boolValue
        trips = [Trips]()
        let tripsArray = json["trips"].arrayValue
        for tripsJson in tripsArray{
            let value = Trips(fromJson: tripsJson)
            trips.append(value)
        }
        stories = [Stories]()
        let blogsArray = json["blogs"].arrayValue
        for blogsJson in blogsArray{
            let value = Stories(fromJson: blogsJson)
            stories.append(value)
        }
        descriptionField = json["description"].stringValue
    }
}

