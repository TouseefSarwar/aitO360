//
//  Species_Games.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 08/05/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import SwiftyJSON

class  Species_Games {
    var id : String?
    var name : String?
    var type : String?
    init() {
    }
    init(SpeciesGamesResponse :  JSON) {
        self.id = SpeciesGamesResponse["id"].stringValue
        self.name = SpeciesGamesResponse["name"].stringValue
        self.type = SpeciesGamesResponse["type"].stringValue
    }
}
