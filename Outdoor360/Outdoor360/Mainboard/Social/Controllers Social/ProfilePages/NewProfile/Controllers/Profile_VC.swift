//
//  DemoProfile_VC.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 18/10/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import SwiftyJSON
import CropViewController
import Alamofire
import JJFloatingActionButton

class DemoProfile_VC: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var profile : ProfileResponse!
    var feeds : [SocialPost] = []
    let refreshControl = UIRefreshControl()
    var previousController: UIViewController?
    
    var load_more = false
    var otherFlag = 6
    
    // flag for image and cover....
    var isPro : Bool = false
    
    //create post button
    //MARK: - Float Button
    let floatBtn = JJFloatingActionButton()
    
    var cellHeights = [IndexPath: CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "profileList"
        
        self.tabBarController?.delegate = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(RefreshProfile(_:)) , for: .valueChanged)
        
        self.GetProfile()
        //HEader Cell
        tableView.registerNib(HeaderCell.self)
        tableView.register(UINib(nibName: "Feed_Cell", bundle: nil), forCellReuseIdentifier: Feed_Cell.identifier)
        
        AddCreateBtn()
    }
    
    func AddCreateBtn(){
        
        floatBtn.buttonColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        floatBtn.buttonImageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let post_btn = floatBtn.addItem()
        post_btn.titleLabel.text = "Create Post"
        post_btn.imageView.image = #imageLiteral(resourceName: "post")
        post_btn.buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        post_btn.buttonImageColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        post_btn.action = { item in
            
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
            vc.title = "Create Post"
            let navigationControlr = UINavigationController(rootViewController: vc)
            navigationControlr.modalPresentationStyle = .fullScreen
            self.present(navigationControlr, animated: true, completion: nil)
        }
        
        let album_btn = floatBtn.addItem()
        album_btn.titleLabel.text = "Create Album"
        album_btn.imageView.image = #imageLiteral(resourceName: "image")
        album_btn.buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        album_btn.buttonImageColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        album_btn.action = { item in
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
            vc.title = "Create Album"
            let navigationControlr = UINavigationController(rootViewController: vc)
            navigationControlr.modalPresentationStyle = .fullScreen
            self.present(navigationControlr, animated: true, completion: nil)
        }
        
        floatBtn.display(inViewController: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.delegate = self
        NetworkController.others_front_user_id = "0"
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
}

extension DemoProfile_VC : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? DemoProfile_VC {
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

extension DemoProfile_VC : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if profile != nil{
                if self.feeds.count <= 0 {
                    return  1
                }else{
                    return self.feeds.count + 1
                }
            }else{
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                
                let header : HeaderCell = tableView.dequeueReusableCell(for: indexPath)
                header.isAccessibilityElement = true
                header.accessibilityIdentifier = "cell_no_\(indexPath.row)"
                header.ConfigureHeader(with: self.profile)
                header.mainButton.setTitle("Edit Profile", for: .normal)
                header.delegate = self
                return header
                
            }else{
                let feed = tableView.dequeueReusableCell(withIdentifier: Feed_Cell.identifier, for: indexPath) as! Feed_Cell
                feed.isAccessibilityElement = true
                feed.accessibilityIdentifier = "cell_no_\(indexPath.row)"
                feed.configureCell(cellData: self.feeds[indexPath.row - 1], index: indexPath.row - 1)
                feed.delegate = self
                return feed
            }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if otherFlag < 0{
            if indexPath.row == self.feeds.count  && !self.load_more {
                
                if self.feeds.count >= 5{
                    self.tableView.tableFooterView = self.LazyLoader()
                    self.tableView.tableFooterView?.isHidden = false
                    self.load_more = true
                    let index = self.feeds.count - 1
                    if NetworkController.others_front_user_id == "0"{
                        if self.feeds.count > 0{
                            LoadMoreData(other_front_user: NetworkController.front_user_id, last_post_id: self.feeds[index].id!)
                        }
                    }else{
    
                        if self.feeds.count > 0{
                            LoadMoreData(other_front_user: NetworkController.others_front_user_id, last_post_id: self.feeds[index].id!)
                        }
                    }
                }
            }
        }else{
            otherFlag = otherFlag - 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

}



//API Calls....

extension DemoProfile_VC{
    
    
    @objc func RefreshProfile(_ sender : Any){
        self.feeds.removeAll()
        self.profile = nil
        let parameters : [String: Any] = [
            "front_user_id" : "0",
            "my_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Profile){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    
                    let profileJSON = response["result"]["data"]
                    self.profile = ProfileResponse(ProfileData: profileJSON)
                    let feedsJSON = response["result"]["data"]["feeds"]
                    
                    for post in feedsJSON
                    {
                        let data = SocialPost(postJSON: post.1)
                        self.feeds.append(data)
                    }
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                }else{
                    self.refreshControl.endRefreshing()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.refreshControl.endRefreshing()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
        
    }
    
    func GetProfile(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "0",
            "my_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Profile){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let profileJSON = response["result"]["data"]
                    self.profile = ProfileResponse(ProfileData: profileJSON)
                    let feedsJSON = response["result"]["data"]["feeds"]
                    for post in feedsJSON{
                        let data = SocialPost(postJSON: post.1)
                        self.feeds.append(data)
                    }
                    self.tableView.reloadData()
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
    
    }
    
    func Share(postid : String, caption : String, post : SocialPost){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(postid)",
            "type" : "post",
            "share_caption" : "\(caption)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){ response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.feeds.insert(post, at: 0)
                    let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared", preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    func LoadMoreData(other_front_user : String , last_post_id : String){
        self.load_more = true
        let parameters : [String: Any] = [
            "front_user_id" : "\(other_front_user)",
            "feed_id" : "\(last_post_id)",
            "hashtag" : "",
            "my_id" : "\(NetworkController.front_user_id)"
        ]
        self.tableView.isScrollEnabled = false
        NetworkController.shared.Service(parameters: parameters, nameOfService: .LoadMorePosts){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    let myResp = response["result"]["data"]
                    for post in myResp{
                        let data = SocialPost(postJSON: post.1)
                        
                        self.feeds.append(data)
                    }
                    self.load_more = false
                    self.tableView.tableFooterView?.isHidden = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }else{
                    self.tableView.isScrollEnabled = true
                    self.load_more = false
                    self.tableView.tableFooterView?.isHidden = true
                }
            }else{
                self.tableView.isScrollEnabled = true
                self.load_more = false
                self.tableView.tableFooterView?.isHidden = true
            }
        }
        
    }

    ///Update Profile Photo
    
    func UpdateProfilePhoto(photo : UIImage){
        
        self.Uploader()
        let url = "\(NetworkController.shared.baseUrl)profile_update_image"
        let parameters : [String : Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
        ]
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
            multipartFormData.append(photo.jpegData(compressionQuality: 0.7)!, withName: "image", fileName: "Profileimage\(Date()).png", mimeType: "image/png")
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    self.uploaderValue(progressValue: Float(Progress.fractionCompleted))
                    let prog = Int(Progress.fractionCompleted * 100)
                    if prog == 100{
                        self.removeUploader()
                        self.addActivityLoader()
                    }
                })
                
                upload.responseJSON{ response in
                    switch response.result
                    {
                    case .success(let data):
                        let json = JSON(data)
                        if json != JSON.null {
                            if json["result"]["status"].boolValue == true{
                                self.removeActivityLoader()
                                var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
                                let userDefaultData =  [
                                    "email" : dic!["email"] as! String,
                                    "password" : dic!["password"] as! String,
                                    "front_user_id" : dic!["front_user_id"] as! String,
                                    "user_image" : json["result"]["profile_image"].stringValue,
                                    "user_name" : dic!["user_name"] as! String,
                                ]
                                UserDefaults.standard.removeObject(forKey: "userInfo")
                                UserDefaults.standard.set(userDefaultData, forKey: "userInfo")
                                UserDefaults.standard.synchronize()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                                tab_Crtl.modalPresentationStyle = .fullScreen
                                self.present(tab_Crtl, animated: true, completion: nil)
                                
                            }else{
                                self.removeActivityLoader()
                                self.presentError(massageTilte: "\(json["result"]["description"].stringValue)")
                            }
                        }else{
                            self.removeActivityLoader()
                            self.presentError(massageTilte: "Oops! Something went wrong.")
                        }
                    case .failure(let error):
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "\(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                self.removeUploader()
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(error.localizedDescription)")
            }
        }
        
    }
    
    ///Update Cover Photo
    func UpdateCoverPhoto(cropedImage : UIImage){
        self.Uploader()
        let url = "\(NetworkController.shared.baseUrl)profile_update_cover"
        let parameters : [String : Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
        ]
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
            multipartFormData.append(cropedImage.jpegData(compressionQuality: 0.7)!, withName: "image", fileName: "CoverImage\(Date()).png", mimeType: "image/png")
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    self.uploaderValue(progressValue: Float(Progress.fractionCompleted))
                    let prog = Int(Progress.fractionCompleted * 100)
                    if prog == 100{
                        self.removeUploader()
                        self.addActivityLoader()
                    }
                })
                
                upload.responseJSON{ response in
                    switch response.result
                    {
                    case .success(let data):
                        let json = JSON(data)
                        if json != JSON.null {
                            if json["result"]["status"].boolValue == true{
                                self.removeActivityLoader()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                                tab_Crtl.modalPresentationStyle = .fullScreen
                                self.present(tab_Crtl, animated: true, completion: nil)
                                
                            }else{
                                self.presentError(massageTilte: "")
                            }
                        }else{
                            self.presentError(massageTilte: "")
                        }
                    case .failure(let error):
                        self.presentError(massageTilte: "\(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(error.localizedDescription)")
            }
        }
        
    }
    
}

extension DemoProfile_VC : CropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            if self.isPro{
                self.UpdateProfilePhoto(photo: image)
            }else{
                self.UpdateCoverPhoto(cropedImage: image)
            }
        }
        
    }
    
    
}

//MARK: Header Delegates
extension DemoProfile_VC : HeaderCellDelegate{
    func push(viewController: UIViewController) {
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func present(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func CropperDelegation(isProfile : Bool,image: UIImage) {
        if isProfile{
            let profileCropper  = CropViewController(croppingStyle: .circular, image: image)
            profileCropper.delegate = self
            self.isPro = isProfile
            self.present(profileCropper, animated: true, completion: nil)
        }else{
            let coverCropper  = CropViewController(croppingStyle: .default, image: image)
            coverCropper.aspectRatioPreset = CropViewControllerAspectRatioPreset(rawValue: TOCropViewControllerAspectRatioPreset.RawValue(3.63/1))!
            coverCropper.delegate = self
            self.isPro = isProfile
            self.present(coverCropper, animated: true, completion: nil)
        }

    }
}

//MARK:Feed Cell  Delegate
extension DemoProfile_VC : Feed_CellDelegate{
    func delete(index : Int){
        let indexPath =  IndexPath(row: index, section: 0)
        self.feeds.remove(at: index)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func share(post: SocialPost) {
        self.feeds.insert(post, at: 0)
    }
    
    func push(VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func present(VC: UIViewController) {
        self.present(VC, animated: true, completion: nil)
    }
    
    func update(count: CountUpdate) {
        if count.type == "tag"{
            self.feeds[count.index].tags_count! = count.count
        }else if count.type == "like"{
            self.feeds[count.index].favourite_id = count.favID!
            self.feeds[count.index].feed_favourites = "\(count.count ?? 0)"
        }else if count.type == "commentLike"{
            if count.count == 0{
                self.feeds[count.index].comment!.first?.is_favorite = "no"
            }else{
                self.feeds[count.index].comment!.first?.is_favorite = "yes"
            }
            
        }else{
            if count.comment != nil {
                if self.feeds[count.index].comment != nil && self.feeds[count.index].comment!.count == 0{
                    self.feeds[count.index].comment!.insert(count.comment!, at: 0)
                }else{
                    self.feeds[count.index].comment!.insert(count.comment!, at: 0)
                }
                self.feeds[count.index].feed_comments! = String(count.count)
            }else{
                self.feeds[count.index].feed_comments! = String(count.count)
            }
        }
        self.tableView.reloadData()
//        let indexPath = IndexPath(row: count.index, section: 0)
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: Suggested User
extension DemoProfile_VC : SuggestedTableViewCellDelegate{
    func pushController(withNavigation viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}


