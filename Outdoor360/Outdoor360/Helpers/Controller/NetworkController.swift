//
//  NetworkController.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

class NetworkController {
    
    
    static let shared = NetworkController()
    
    
    static var front_user_id = "0"
    static var others_front_user_id = "0"
    
   //Anthony ANd colby to delete 
    static var Anthony = "103"
    static var Colby = "102"
    static var Mark = "195"
    static var Rob = "417"
    static var Blair = "333"

    static var user_name = ""
    static var user_image = ""

    
    // for individual photos
    static var imgCollection = ""
    static var photo_id = ""
    static var photo_type = ""
    
    ///URL FOr sharing post
    
//Local Url
   static let shareURL = "http://webmatech.com/project101/social/feed/" //Local
   var baseUrl = "http://webmatech.com/project101/app/"

//    Live Url
//    var baseUrl = "https://www.yentna.com/app/"
//    static let shareURL = "https://www.yentna.com/social/feed/" // Live

    
    
    /// onComplition-> JSON is json response
    ///and 0 == failed due to invalid parameters
    ///and 1 == successfull case
    /// and 2== no internet available
    func Service( parameters : [String : Any]? , nameOfService name : Name,  onComplition: @escaping (JSON, Int) -> Void) {
       
        if InternetAvailabilty.isInternetAvailable(){
            let url = "\(self.baseUrl)\(name.rawValue)"
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(){ response in
                switch response.result
                {
                case.success(let data):
                    let resp = JSON(data)
                    onComplition(resp , 1)
                    break
                case.failure(_):
                    onComplition(JSON.null,0 )
                    break
                }
            }
        }else{
            onComplition(JSON.null, 2)

        }
    }
    
    ///Function For uploading Image
    func uploadImages(parameters : [String : Any] , imagesToUpload : [PickedImages], nameOfService  name : Name,  onComplition: @escaping (Progress?, Error? , Bool?) -> Void){
        
        let url = "\(self.baseUrl)\(name.rawValue)"
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.timeoutIntervalForResource = 120
         
        manager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            for (index ,img) in imagesToUpload.enumerated(){
                
                if img.type! == "video"{
                    var videoData : Data?
                    do {
                        videoData = try Data.init(contentsOf: img.url!, options : .mappedIfSafe)
                        multipartFormData.append(videoData!, withName: "image[]", fileName: "video\(Date())\(index).mp4", mimeType: "video/mp4")
                    } catch {
                        print("Error: \(error)")
                    }
                }else{
                    let imgData = img.image.jpegData(compressionQuality: 0.5)!
                    multipartFormData.append(imgData, withName: "image[]", fileName: "image\(Date())\(index).png", mimeType: "image/png")
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    onComplition(Progress,nil,false)
                })
                upload.responseString{response in
                    if response.result.value != nil {
                        onComplition(nil,nil,true)
                    }else{
                        onComplition(nil, response.result.error!, false)
                    }
                }
                
            case .failure(let error):
                onComplition(nil, error, false)
            }
        }
    }
    
}

///Here your all service names related to the service using 'enums'
enum Name : String{
    
    //ImageUploading Cases
    ///share App Link  "share_app_link"
    case ShareAppLink = "share_app_link"
    
    ///Create Post "post_feed"
    case PostFeed  = "post_feed"
    
    /// Dashboard or Home Page "homepage"
    case Home = "homepage"
    
    ///Name of trips "trips"
    case Trips = "trips"
    
    ///Name of reports "reports"
    case Reports = "reports"
    
    ///Name of Stories "blogs"
    case Stories = "blogs"
    
    ///App Version
    case AppVersion = "app_version"
    
    /// Names of webservices related to Social
    ///1- Fetching Feeds.. "social_post"
    case SocialPosts = "social_post"
    
    ///2- Liking the post "like_post"
    case LikePost = "like_post"
    
    ///2.1 who liked Post "people_liked"
    case PeopleLiked = "people_liked"
    
    ///3- Fetching the comments of post "post_comments"
    case PostComments = "post_comments"
    
    
    ///4- Fetching Single Post Comments.. "single_post_comments"
    case SinglePostComments = "single_post_comments"
    
    ///5- View more replies of comments "view_more_replys"
    case MoreReply = "view_more_replys"
    
    ///6- Users who tagged in the post.... "tagged_user"
    case TaggedUser = "tagged_user"
    
    ///7- Fetching Notification "my_notifications"
    case UserNotifications = "my_notifications"
    
    ///8- Notification of Comment "post_comments_notfication"
    case PostCommentsNotfication = "post_comments_notfication"
    
    ///9- Notification of single post "single_post"
    case SinglePost = "single_post"

    ///10- Search CollectionData imagesss... "search_data_tab"
    case SearchDataTab = "search_data_tab"
    
    ///11- Search Guides "search_guides"
    case SearchGuides = "search_guides"
    
    ///12- Send comment to any post "send_comment"
    case SendComment = "send_comment"

    ///13- Fetching Speices "get_species"
    case Species = "get_species"
    
    ///14- Fetching games "get_games"
    case Games = "get_games"
    
    ///15- Following by me "my_following"
    case Following = "my_following"
    
    ///16- My Followers "my_followers"
    case Followers = "my_followers"
    
    ///17- Delete Post.... "delete_social_post"
    case DeletePost = "delete_social_post"
    
    ///18- update post caption "update_post_caption"
    case UpdatePostCaption = "update_post_caption"
    
    ///19- Add tags "add_tagged_users"
    case AddTaggedUsers = "add_tagged_users"
    
    
    ///20- Tag People (Follower and Following of the users) "tag_people"
    case TagPeople = "tag_people"
    
    ///21- Delete tagged users in the post... "delete_tagged_user"
    case DeleteTaggedUser = "delete_tagged_user"
    
    ///22- Share the current post in yentna "share_post"
    case SharePost = "share_post"
    
    ///23-  fetching Posts Hashtags "hashtag"
    case HashTag = "hashtag"
    
    ///24- Follow or unfollow user..... "follow_unfollow"
    case FollowUnfollow = "follow_unfollow"
    
    ///25- Loading more data of posts... "load_more_feed"
    case LoadMorePosts = "load_more_feed"
    
    
    ///26- Get ImageInfo Data Loc,specy,game "tagged_items"
    case TaggedItems = "tagged_items"
    
    ///27- Add More Tags In ImageInfo "tag_item"
    case TagItem = "tag_item"
    
    ///28- Add More Tags In ImageInfo "user_suggestions"
    case UserSuggestions = "user_suggestions"
    
    ///29- Profile dataa "profile"
    case Profile = "profile"
    ///29.0 profile Image update "edit_profile"
    case EditProfile = "edit_profile"
    ///29.1 profile Image update "profile_update_image"
    case ProfileUpdateImage = "profile_update_image"
    
    ///29.2 profile Cover image update "profile_update_cover"
    case ProfileUpdateCover = "profile_update_cover"
    
    ///30- Profile dataa photosss "User_photos"
    case ProfileUserPhotos = "User_photos"
    
    ///31- Profile dataa Albumssss "user_albums"
    case ProfileUserAlbums = "user_albums"
    
    ///32- Profile dataa Album Update name "album_update_name"
    case UpdateAlbumName = "album_update_name"
    
    ///33- Profile dataa album photosss "user_album_photos"
    case UserAlbumsPhoto = "user_album_photos"
    
    ///34- Profile dataa photoMap "photo_map"
    case PhotoMap = "photo_map"
    
    ///35- Profile dataa videos "user_videos"
    case ProfileUserVideos = "user_videos"
    
    ///36- Profile Update name of user "profile_update_name"
    case ProfileUpdateName = "profile_update_name"
    
    ///37- Login user "login"
    case Login = "login"
    
    ///38- Update social accounts FB, TW and LI "update_social"
    case UpdateSocial = "update_social"

    ///39- Social accounts  login FB, TW and LI "social_login"
    case SocialLogin = "social_login"

    ///40- SignUp with account "signup"
    case SignUp = "signup"
    
    ///40.1 - Validat Email for signup "validate_email"
    case validateEmail = "validate_email"
    
    
    ///41- Verify Code "sms_verify"
    case SmsVerify = "sms_verify"
    
    ///42- Resend Verify Code "resend_sms_code"
    case ResendSmsCode = "resend_sms_code"
    
    ///43-  Flag or Report Post "flag_post"
    
    case Flag = "flag_post"
    
    ///44- Forgot Password... ""
    case ForgotPassword = "forgot_password"
    
    ///45- Change Password... ""
    case ChangePassword = "change_password"
}


extension NetworkController{
    
    //MARK: Get My IP
    func getNetworkIP(onComplition: @escaping (JSON) -> Void){
        
        Alamofire.request("https://api.ipify.org/?format=json", method: .get).responseJSON(){ response in
            
            switch response.result{
            case .success(let data):
                let resp = JSON(data)
                onComplition(resp)
                break
            case .failure(let error):
                onComplition(JSON.null)
                print(error)
                break
            }
        }
        
        
    }
    
    //MARK: RandomDigits
    func random(digits:Int) -> Int {
        
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
    
    //MARK: Date converter
    func dateConverter(dateString : String) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateString )
        dateFormatter.timeZone = TimeZone.current
        return date?.timeAgoSinceNow.lowercased()
    }
    
    
    //MARK: Image resizer.....!
    func frame(forImage ImageView: UIImageView?) -> CGRect {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        let fullW: CGFloat? = window?.frame.size.width
        let fullH: CGFloat? = window?.frame.size.height
        let size: CGSize? = (ImageView?.image) != nil ? ImageView?.image?.size : ImageView?.frame.size
        let ratio: CGFloat = min((fullW ?? 0.0) / (size?.width ?? 0.0), (fullH ?? 0.0) / (size?.height ?? 0.0))
        let W: CGFloat = ratio * (size?.width ?? 0.0)
        let H: CGFloat = ratio * (size?.height ?? 0.0)
        return CGRect(x: 0, y: 0, width: W, height: H)
    }
    
    //MARK: UIColors using HEXA Values
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK: GetWifi_IP
    func getWiFiAddress() -> String? {
        
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
}



