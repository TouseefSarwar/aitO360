//
//  ReportGlobals.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 29/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import SystemConfiguration

class InternetAvailabilty {
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}





/// Signup Globals...
class SignupGolbal {
    static var first_name : String!
    static var last_name : String!
    static var password : String?
    static var email : String!
    static var mobile : String!
    static var address : String!
    static var country_Code: String!
    static var front_user_id : String!
    
}


///Selected top tab View.... 1 for Storie, 2 for trips, 3 for reports
class SelectedTab{
    static var index : Int = 0
}

///Search Guides For Mentions, SearchViewController, Profile etc....

class Guides{
    static var Users : [SearchGuides] = []
    static var suggestedUsers : [Suggested_User] = []
}


/// MARK: To create post and edit Album
/// Post Global is used
/// Make sure to empty after used.
class PostUpdateGlobal{
    static var indx : Int!
    static var g_games : Array<String> = Array.init(repeating: "", count: 150)
    static var g_species : Array<String> = Array.init(repeating: "", count: 150)
    static var loction : Array<String> = Array.init(repeating: "", count: 150)
    static var photo_tags : Array<String> = Array.init(repeating: "", count: 150)
    static var post_tags : String = ""
    
}

class ImageInfoGlobals{
    static var location : String = ""
    static var game : [String] = []
    static var species : [String] = []
}

