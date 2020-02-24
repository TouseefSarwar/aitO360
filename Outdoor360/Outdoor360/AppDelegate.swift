//
//  AppDelegate.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import Kingfisher
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import FBSDKCoreKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import TwitterKit
import SwiftyJSON
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var accessToken : String!
    let gcmMessageIDKey = "gcm.message_id"
    
    //Notification Variables
    var notificationInactive : Bool = false
    
    var commentId = 0
    var postId = 0
    var photoId = 0
    var profileId = 0
    var blogLink = ""
    
    let feedStoryboard : UIStoryboard = UIStoryboard(name: "Feeds", bundle: nil)
    let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let homeStoryboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ImageCache.default.diskStorage.config.sizeLimit = 300 * 1024 * 1024
        ImageCache.default.memoryStorage.config.totalCostLimit = 200 * 1024 * 1024
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "P8Qi7evb5J8srrQMUqLXTAD1Q", consumerSecret: "OFuqfM9v0dFiHe6xdS9kT7uR4Xz9V3ObAqFVSsbszCgWbupAKJ")
        //Google Things....
        GIDSignIn.sharedInstance()?.clientID = "260022084317-1bcfcsahmtiirmr5ck3ft9l0q6rkbo7h.apps.googleusercontent.com"
        GMSPlacesClient.provideAPIKey("AIzaSyDaB6Maex92zIOK9jgHoNba5LixPY8fI0Y")
        GMSServices.provideAPIKey("AIzaSyDaB6Maex92zIOK9jgHoNba5LixPY8fI0Y")
        //Register when going to logged in and remove registration when logged out...
        let userdata  = UserDefaults.standard.dictionary(forKey: "userInfo")
        if userdata != nil{
            application.registerForRemoteNotifications()
        }else{
            application.unregisterForRemoteNotifications()
        }
        
        setUpFireBaseNotifications()
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc =  UIStoryboard(name: "Launch Screen", bundle: nil).instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
            //Checking Version
            
        if InternetAvailabilty.isInternetAvailable(){
            NetworkController.shared.Service(parameters: nil, nameOfService: .AppVersion) { (resp, _) in
                if resp != JSON.null{
                    let storeVersion = resp["result"]["data"]["appversion"].stringValue
                    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                    
                    if storeVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AppVersion_VC") as! AppVersion_VC
                        vc.modalPresentationStyle = .fullScreen
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }else{
                        if !self.notificationInactive {
                            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateInitialViewController()
                            vc?.modalPresentationStyle = .fullScreen
                            self.window?.rootViewController = vc
                            self.window?.makeKeyAndVisible()
                        }else{
                            if self.blogLink != ""{
                                self.window = UIWindow(frame: UIScreen.main.bounds)
                                let nav = self.homeStoryboard.instantiateViewController(withIdentifier: "detailNav") as? UINavigationController
                                let vc = nav?.topViewController as! DetailStory_VC
                                vc.notificationURL = self.blogLink
                                nav?.modalPresentationStyle = .fullScreen
                                self.window!.rootViewController = nav
                                self.window!.makeKeyAndVisible()
                            }else{
                                if self.commentId > 0{
                                    if self.photoId > 0{
                                        
                                        self.window = UIWindow(frame: UIScreen.main.bounds)
                                        let nav = self.mainStoryboard.instantiateViewController(withIdentifier: "profileToComment") as? UINavigationController
                                        let vc = nav?.topViewController as! CommentsViewController
                                        vc.notification_flag = true
                                        let cmt = String(self.commentId)
                                        let phid = String(self.photoId)
                                        //                let pName = String(postUserName)
                                        vc.n_photoId = phid
                                        vc.n_commentId = cmt
                                        nav?.modalPresentationStyle = .fullScreen
                                        self.window!.rootViewController = nav
                                        self.window!.makeKeyAndVisible()
                                    }else{
                                        self.window = UIWindow(frame: UIScreen.main.bounds)
                                        let nav = self.mainStoryboard.instantiateViewController(withIdentifier: "profileToComment") as? UINavigationController
                                        let vc = nav?.topViewController as! CommentsViewController
                                        vc.notification_flag = true
                                        let cmt = String(self.commentId)
                                        let phid = String(self.photoId)
                                        let pId = String(self.postId)
                                        vc.n_photoId = phid
                                        vc.n_postId = pId
                                        vc.n_commentId = cmt
                                        nav?.modalPresentationStyle = .fullScreen
                                        self.window!.rootViewController = nav
                                        self.window!.makeKeyAndVisible()
                                    }
                                }else if self.profileId > 0{
                                    
                                    let profid = String(self.profileId)
                                    NetworkController.others_front_user_id = profid
                                    self.window = UIWindow(frame: UIScreen.main.bounds)
                                    let nav = self.mainStoryboard.instantiateViewController(withIdentifier: "showProfile") as? UINavigationController
                                    let vc = nav?.topViewController as! OthersViewController
                                    vc.pushNotification = true
                                    nav?.modalPresentationStyle = .fullScreen
                                    self.window!.rootViewController = nav
                                    self.window!.makeKeyAndVisible()
                                    
                                }else if self.photoId > 0 {
                                    
                                    self.window = UIWindow(frame: UIScreen.main.bounds)
                                    let vc: ShowImageViewController = self.feedStoryboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
                                    let pid = String(self.photoId)
                                    self.GetSingleImage(photo_id: pid) { (photo) in
                                        vc.photo = photo
                                        vc.pushNotification = true
                                        vc.index = 0
                                        vc.modalPresentationStyle = .fullScreen
                                        self.window?.rootViewController = vc
                                        self.window?.makeKeyAndVisible()
                                    }
                                }else{
                                    
                                    self.window = UIWindow(frame: UIScreen.main.bounds)
                                    let nav = self.mainStoryboard.instantiateViewController(withIdentifier: "nav") as? UINavigationController
                                    let vc = nav?.topViewController as! NotificationPostsViewController
                                    vc.notificationFlag = true
                                    let pid = String(self.postId)
                                    vc.postId = pid
                                    nav?.modalPresentationStyle = .fullScreen
                                    self.window!.rootViewController = nav
                                    self.window!.makeKeyAndVisible()
                                    
                                }
                            }
                        }
                    }
                }else{
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    vc?.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                    print("Error! Response is null")
                }
            }
        }else{
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            vc?.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        
        // IQ Keyboard Settings...
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.isAccessibilityElement = true
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        var value : Bool = true
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options){
            value =  TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }else if ApplicationDelegate.shared.application(app, open: url, options: options){
            value = ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        return value
    }
    
    private func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL)
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        /// This removes the memory warnings
        
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate {
    func setUpFireBaseNotifications(){
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        //Solicit permission from user to receive notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        var userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if userInfo["comment_id"] != nil{
            print( "Comment : \(userInfo["comment_id"] as! String)")
            self.commentId = Int(userInfo["comment_id"] as! String)!
        }else{
            self.commentId = 0
        }
        if userInfo["post_id"] != nil{
            print("Post : \(userInfo["post_id"] as! String)")
            self.postId = Int(userInfo["post_id"] as! String)!
        }else{
            self.postId = 0
        }
        
        if userInfo["photo_id"] != nil{
            print("Photo : \(userInfo["photo_id"] as! String)")
            self.photoId = Int(userInfo["photo_id"] as! String)!
        }else{
            self.photoId = 0
        }
        
        if userInfo["profile_id"] != nil{
            print("profile : \(userInfo["profile_id"] as! String)")
            self.profileId = Int(userInfo["profile_id"] as! String)!
        }else{
            self.profileId = 0
        }
        
        if let blog = userInfo["blog_url"]{
           self.blogLink = blog as! String
        }else{
            self.blogLink = ""
        }
        
        
        //            if userInfo["post_user_name"] != nil{
        //                print("post_user_name : \(userInfo["post_user_name"] as! String)")
        //                postUserName = userInfo["post_user_name"] as! String
        //            }else{
        //                postUserName = "your"
        //            }
        let userdata  = UserDefaults.standard.dictionary(forKey: "userInfo")
        
        if userdata != nil{
            NetworkController.front_user_id =  userdata!["front_user_id"] as! String
        }
        
        
        
        
        if UIApplication.shared.applicationState == .inactive {
            self.notificationInactive = true
        }
            
        if blogLink != ""{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let nav = homeStoryboard.instantiateViewController(withIdentifier: "detailNav") as? UINavigationController
            let vc = nav?.topViewController as! DetailStory_VC
            vc.notificationURL = blogLink
            self.window!.rootViewController = nav
            self.window!.makeKeyAndVisible()
        }else{
            if commentId > 0{
                if photoId > 0{
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let nav = mainStoryboard.instantiateViewController(withIdentifier: "profileToComment") as? UINavigationController
                    let vc = nav?.topViewController as! CommentsViewController
                    vc.notification_flag = true
                    let cmt = String(commentId)
                    let phid = String(photoId)
                    //                let pName = String(postUserName)
                    vc.n_photoId = phid
                    vc.n_commentId = cmt
                    self.window!.rootViewController = nav
                    self.window!.makeKeyAndVisible()
                }else{
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let nav = mainStoryboard.instantiateViewController(withIdentifier: "profileToComment") as? UINavigationController
                    let vc = nav?.topViewController as! CommentsViewController
                    vc.notification_flag = true
                    let cmt = String(commentId)
                    let phid = String(photoId)
                    let pId = String(postId)
                    vc.n_photoId = phid
                    vc.n_postId = pId
                    vc.n_commentId = cmt
                    self.window!.rootViewController = nav
                    self.window!.makeKeyAndVisible()
                }
            }else if profileId > 0{
                
                let profid = String(profileId)
                NetworkController.others_front_user_id = profid
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let nav = mainStoryboard.instantiateViewController(withIdentifier: "showProfile") as? UINavigationController
                let vc = nav?.topViewController as! OthersViewController
                vc.pushNotification = true
                self.window!.rootViewController = nav
                self.window!.makeKeyAndVisible()
                
            }else if photoId > 0 {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let vc: ShowImageViewController = feedStoryboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
                let pid = String(photoId)
                self.GetSingleImage(photo_id: pid) { (photo) in
                    vc.photo = photo
                    vc.pushNotification = true
                    vc.index = 0
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }else{
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let nav = mainStoryboard.instantiateViewController(withIdentifier: "nav") as? UINavigationController
                let vc = nav?.topViewController as! NotificationPostsViewController
                vc.notificationFlag = true
                let pid = String(postId)
                vc.postId = pid
                self.window!.rootViewController = nav
                self.window!.makeKeyAndVisible()
                
            }
        }
        
        
        
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppDelegate.accessToken = fcmToken
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
}

extension AppDelegate{
    func GetSingleImage(photo_id : String, onComplition: @escaping([Photo])-> Void){
        
      
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "last_id" : "",
            "photo_id" : "\(photo_id)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserPhotos){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["photos"]
                    var fetchphoto : [Photo] = []
                    for post in resp
                    {
                        let data = Photo(photoData: post.1)
                        fetchphoto.append(data)
                    }
                    onComplition(fetchphoto)
                    
                }
            }
        }
    }
    
    
}
