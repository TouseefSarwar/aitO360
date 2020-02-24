//
//  OthersViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 27/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire


class OthersViewController: UIViewController {

    
    // IBOutlets
    @IBOutlet weak var tableView : UITableView!
    
    var followers : [SearchGuides] = []
    //PushnOtification
    var pushNotification = false
    
    
    var profile : ProfileResponse!
    var feeds : [SocialPost] = []
    
    var refreshControl = UIRefreshControl()
    
    //old Variables....
    var hashtagTitle : String!
    
    var likeCount : String?
    var selectedIndex : Int!
    var images_To_Show : [Photo] = []
    var load_more : Bool = false
    var otherFlag = 6

    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
    var cellHeights = [IndexPath: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.GetProfile()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "otherProfile"
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(RefreshProfile(_:)) , for: .valueChanged)
        tableView.registerNib(HeaderCell.self)
        tableView.register(UINib(nibName: "Feed_Cell", bundle: nil), forCellReuseIdentifier: Feed_Cell.identifier)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    deinit{
        print("Other deallocation")
    }
    
    
    
    @IBAction func back_Btn(_ sender: UIBarButtonItem) {
        NetworkController.others_front_user_id = "0"
        if pushNotification{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            tab_Crtl.modalTransitionStyle = .crossDissolve
            tab_Crtl.modalPresentationStyle = .fullScreen
            self.present(tab_Crtl, animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
 
}

//Table Delegates and data sources...
extension OthersViewController : UITableViewDataSource , UITableViewDelegate{
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
                if NetworkController.others_front_user_id == "0"{
                    header.mainButton.setTitle("Edit Profile", for: .normal)
                    if dic != nil{
                        header.mainButton.isEnabled = true
                    }else{
                        header.mainButton.isEnabled = false
                    }

                }else{
                    if profile.is_followed! == "yes"{
                        header.mainButton.setTitle("Following", for: .normal)
                    }else{
                        header.mainButton.setTitle("Follow", for: .normal)
                    }
                    if dic != nil{
                        header.mainButton.isEnabled = true
                    }else{
                        header.mainButton.isEnabled = false
                    }
                }
            header.isAccessibilityElement = true
            header.accessibilityIdentifier = "cell_no_\(indexPath.row)"
            header.ConfigureHeader(with: self.profile)
            header.delegate = self
            return header

        }else{
            if self.feeds.count > 0{
                let feed = tableView.dequeueReusableCell(withIdentifier: Feed_Cell.identifier, for: indexPath) as! Feed_Cell
                feed.isAccessibilityElement = true
                feed.accessibilityIdentifier = "cell_no_\(indexPath.row)"
                feed.configureCell(cellData: self.feeds[indexPath.row - 1], index: indexPath.row - 1)
                feed.delegate = self
                return feed
            }else{
                let suggestCell = self.tableView.dequeueReusableCell(withIdentifier: "suggestTableCell", for: indexPath) as! SuggestedTableViewCell
                suggestCell.delegate = self
                suggestCell.ConfigureSuggestions(suggestedUsers: Guides.suggestedUsers)
                return suggestCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cellHeights[indexPath] = cell.frame.size.height
        if otherFlag < 0{
            if indexPath.row == self.feeds.count && self.load_more == false{
                self.tableView.tableFooterView = self.LazyLoader()
                self.tableView.tableFooterView?.isHidden = false
                self.load_more = true
                if NetworkController.others_front_user_id == "0"{
                    if self.feeds.count > 0{
                        LoadMoreData(other_front_user: NetworkController.front_user_id, last_post_id: self.feeds[self.feeds.count - 1].id!)
                    }
                }else{
                    if self.feeds.count > 0{
                        LoadMoreData(other_front_user: NetworkController.others_front_user_id, last_post_id: self.feeds[self.feeds.count - 1].id!)
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


//MARK:Feed Cell  Delegate
extension OthersViewController : Feed_CellDelegate{
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


//API Calls....
extension OthersViewController{
    
    
    @objc func RefreshProfile(_ sender : Any){
        self.feeds.removeAll()
        self.profile = nil
        let parameters : [String: Any] = [
            "front_user_id" : NetworkController.others_front_user_id ,
            "my_id" : NetworkController.front_user_id
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
            "front_user_id" : NetworkController.others_front_user_id,
            "my_id" : NetworkController.front_user_id
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
                    self.load_more = false
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
                    self.tableView.reloadData()
                    self.tableView.isScrollEnabled = true
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
    
    
}


extension OthersViewController : HeaderCellDelegate{

    func push(viewController: UIViewController) {
        self.navigationController!.pushViewController(viewController, animated: true)
    }

    func present(viewController : UIViewController){
        self.present(viewController, animated: true, completion: nil)
    }

}

//MARK: Suggested User
extension OthersViewController : SuggestedTableViewCellDelegate{
    func pushController(withNavigation viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}
