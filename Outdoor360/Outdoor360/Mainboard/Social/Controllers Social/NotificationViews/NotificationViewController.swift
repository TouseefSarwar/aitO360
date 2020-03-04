//
//  NotificationViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 19/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//





import UIKit
import SwiftyJSON
import Kingfisher

class NotificationViewController: UIViewController {


    @IBOutlet weak var noNotification : UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedData : NotificationResponse!
    var noticationData : [NotificationResponse] = [NotificationResponse]()
    var myResp : JSON = JSON.null
    
    //Only for Single Image
    var photo  : [Photo] = []
    
    let refreshController = UIRefreshControl()
    var previousController: UIViewController?
    var load_more : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "notificationTable"
        self.noNotification.isHidden = true
        
        let state = UIApplication.shared.applicationState
        if state == UIApplication.State.inactive{
            var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
            NetworkController.front_user_id = dic!["front_user_id"] as! String
        }else if state == UIApplication.State.background{
            var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
            NetworkController.front_user_id = dic!["front_user_id"] as! String
        }
        
        if NetworkController.front_user_id == ""{
            var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
            NetworkController.front_user_id = dic!["front_user_id"] as! String
        }
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(Refresh_Notifications(_:)) , for: .valueChanged)
        Fetch_Notification(last_id: "0")
        tableView.register(UINib(nibName: "FirstView", bundle: nil), forCellReuseIdentifier: "first")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
//    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "singleImage"{
            let VC = segue.destination as! ShowImageViewController
            VC.photo = self.photo
            VC.index = 0
        }
    }

    @objc func Refresh_Notifications(_ sender : Any){
        self.Refresh_Notifications()
    }
 
}


//MARK: TabbarController Delegate......
extension NotificationViewController : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? NotificationViewController {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    vc.tableView.setContentOffset(.zero, animated: true)
                }
            }
        }else{
        }
        
        previousController = viewController
        return true
    }
}


//dataSource
extension NotificationViewController : UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let firstCell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath) as! FirstView
        firstCell.isAccessibilityElement = true
        firstCell.accessibilityIdentifier = "cell_no_\(indexPath.row)"
        firstCell.Configure(cell: self.noticationData[indexPath.row])
        firstCell.delegate = self
    
        return firstCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.selectedData = self.noticationData[indexPath.row]
        if self.selectedData.type == "started following you"{
            if NetworkController.front_user_id != self.noticationData[indexPath.row].front_user_id{
                NetworkController.others_front_user_id = self.noticationData[indexPath.row].front_user_id!
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
            self.navigationController?.pushViewController(vc, animated: true)
//            self.present(vc, animated: true, completion: nil)
        }else{
            if self.selectedData.comment_id == "0" {
                if self.selectedData.photo_id! != "0"{
                    self.GetSingleImage(photo_id: self.noticationData[indexPath.row].photo_id!)
                }else{
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "postNotification") as! NotificationPostsViewController
                    VC.postId = self.selectedData.post_id!
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                
            }else if self.selectedData.comment_id != "0"{
                let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "comment") as! CommentsViewController
                VC.notification_flag = true
                VC.notificationLocalFlag = true
                VC.n_postId = self.selectedData.post_id!
                VC.n_photoId = self.selectedData.photo_id!
                VC.n_postUserName = self.selectedData.post_user_name ?? ""
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.noticationData.count - 1 && !self.load_more{
            if self.noticationData.count > 9{
                self.load_more = true
                self.tableView.tableFooterView = self.LazyLoader()
                self.tableView.tableFooterView?.isHidden = false
                self.LoadMore(last_id: "\(self.noticationData.count)")
            }
        }
    }
    
}
//MARK: FirstViewDelegates

extension NotificationViewController : FirstViewDelegate{
    
    func push(view Controller: UIViewController) {
        self.navigationController?.pushViewController(Controller, animated: true)
    }
    func present(view : UIViewController){
        self.present(view, animated: true, completion: nil)
    }
    func Loader(isAdded : Bool)
    {
        if isAdded{
            self.addActivityLoader()
        }else{
            self.removeActivityLoader()
        }
    }
    
//    func performSegue(identifier: String, data: NotificationResponse) {
//
//        if identifier == "singleImage"{
//            self.GetSingleImage(photo_id: data.photo_id!)
//        }else{
//            self.selectedData = data
//            self.performSegue(withIdentifier: identifier, sender: self)
//        }
//
//
//    }
    
}


//API calls
extension NotificationViewController {
    
    //MARK: Get Single Image Details....
    func GetSingleImage(photo_id : String){
        
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "last_id" : "",
                "photo_id" : "\(photo_id)"
            ]
            
            NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserPhotos){response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        let resp = response["result"]["photos"]
                        for post in resp{
                            let data = Photo(photoData: post.1)
                            self.photo.append(data)
                        }
                        self.removeActivityLoader()
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let VC = storyboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
//                        VC.photo = self.photo
//                        VC.index = 0
//                        self.present(VC, animated: true)
                        self.performSegue(withIdentifier: "singleImage", sender: self)
                    }else{
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                    }
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
    
    //MARK: RefreshFeeds
    func Refresh_Notifications() {
        if InternetAvailabilty.isInternetAvailable(){
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "last_id" : "0"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .UserNotifications){response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        self.myResp = response["result"]["notifications"]
                        self.noticationData.removeAll()
                        for post in self.myResp
                        {
                            let data = NotificationResponse(notificationJSON: post.1)
                            self.noticationData.append(data)
                        }
                        self.refreshController.endRefreshing()
                        self.tableView.reloadData()
                        
                    }else{
                        self.refreshController.endRefreshing()
                        self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                    }
                }else{
                    self.refreshController.endRefreshing()
                    self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
                }
            }
            
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
    
    //MARK: Notifications
    func Fetch_Notification(last_id : String){
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "last_id" : "\(last_id)"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .UserNotifications){response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{

                        self.myResp = response["result"]["notifications"]
                        for post in self.myResp{
                            let data = NotificationResponse(notificationJSON: post.1)
                            self.noticationData.append(data)
                        }
                        if self.noticationData.count > 0{
                            self.noNotification.isHidden = true
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }else{
                            self.load_more = false
                            self.noNotification.isHidden = false
                            self.tableView.isHidden = true
                        }
                        self.removeActivityLoader()

                    }else{
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                    }
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
    
    //MARK: Load More...
    func LoadMore(last_id : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "last_id" : "\(last_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UserNotifications){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    
                    self.myResp = response["result"]["notifications"]
                    
                    for post in self.myResp
                    {
                        let data = NotificationResponse(notificationJSON: post.1)
                        self.noticationData.append(data)
                    }
                    self.load_more = false
                    self.tableView.tableFooterView!.isHidden = true
                    self.tableView.reloadData()
                    
                }else{
                    self.load_more = false
                    self.tableView.tableFooterView!.isHidden = true
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.load_more = false
                self.tableView.tableFooterView!.isHidden = true
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
}
