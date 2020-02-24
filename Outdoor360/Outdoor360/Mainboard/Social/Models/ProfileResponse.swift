//
//  ProfileResponse.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 27/06/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//


import Foundation
import  SwiftyJSON

class ProfileResponse {
    
    var front_user_id : String?
    var first_name : String?
    var last_name : String?
    var social_cover_image : String?
    var user_image : String?
    var user_description : String?
    var following : String?
    var follower : String?
    var post : String?
    var is_followed : String?
    var member_since : String?
    
    var dateOfBirth : String?
    var phoneNumber : String?
    
    
    //additions
    //followers
    
    var followers : [Follower]?
    //photos
    var photos : [Photo]?
    //ALbums
    var albums : [AlbumProfile]?
    //video
    var videos : [VideoProfile]?
    //Feeds
    var homeFeeds : [SocialPost]?
    
    
    init(){
    }
    
    init(ProfileData : JSON) {
        if ProfileData.isEmpty{
            return
        }
        
        self.front_user_id = ProfileData["front_user_id"].stringValue
        self.first_name = ProfileData["first_name"].stringValue
        self.last_name = ProfileData["last_name"].stringValue
        self.social_cover_image = ProfileData["social_cover_image"].stringValue
        self.user_image = ProfileData["user_image"].stringValue
       // self.social_cover_image = ProfileData["social_cover_image"].stringValue
        self.user_description = ProfileData["user_description"].stringValue
        self.following = ProfileData["following"].stringValue
        self.follower = ProfileData["follower"].stringValue
        self.post = ProfileData["post"].stringValue
        self.is_followed = ProfileData["is_followed"].stringValue
        self.member_since = ProfileData["member_since"].stringValue
        
        self.phoneNumber = ProfileData["mobile_number"].stringValue
        self.dateOfBirth = ProfileData["date_of_birth"].stringValue
        
        self.photos = [Photo]()
        let photoArray = ProfileData["photos"].arrayValue
        for js in photoArray{
            let value = Photo(photoData: js)
            self.photos?.append(value)
        }
        
        self.followers = [Follower]()
        let followerArray = ProfileData["followers"].arrayValue
        for js in followerArray{
            let value = Follower(followerJSON: js)
            self.followers?.append(value)
        }
        
        self.albums = [AlbumProfile]()
        let albumArray = ProfileData["albums"].arrayValue
        for js in albumArray{
            let value = AlbumProfile(albumJSON: js)
            self.albums?.append(value)
        }
        
        self.videos = [VideoProfile]()
        let videoArray = ProfileData["videos"].arrayValue
        for js in videoArray{
            let value = VideoProfile(videoJSON: js)
            self.videos?.append(value)
        }
        
        
     }
}
