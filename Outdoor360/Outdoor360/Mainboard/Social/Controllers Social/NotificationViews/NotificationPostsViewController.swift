//
//  NotificationPostsTableViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 29/10/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import  Kingfisher
class NotificationPostsViewController: UIViewController {

    
    @IBOutlet var noPost : UILabel!
    @IBOutlet weak var tableView: UITableView!

    var postId : String!
    var notificationFlag : Bool = false
    var post : SocialPost!
    var comments : [CommentsResponse] = []
    
    
    var hashtagTitle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if notificationFlag{
//            self.navigationItem.leftBarButtonItem = nil
            self.Fetch_Notification_Post(post_id: postId)
        }else if !notificationFlag || postId != nil{
            self.navigationItem.leftBarButtonItem = nil
            self.Fetch_Notification_Post(post_id: postId)
        }
        
        tableView.register(UINib(nibName: "Feed_Cell", bundle: nil), forCellReuseIdentifier: Feed_Cell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }

    @IBAction func cancel_Btn(_ sender : UIBarButtonItem){
        if notificationFlag{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            tab_Crtl.modalTransitionStyle = .crossDissolve
            tab_Crtl.modalPresentationStyle = .fullScreen
            self.present(tab_Crtl, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"{
        }else if segue.identifier == "hashtag"{
            let nav = segue.destination as! UINavigationController
            let VC : HashTagViewController = nav.topViewController as! HashTagViewController
            VC.hashtagString = self.hashtagTitle
        }
    }
}

extension NotificationPostsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.post != nil{
            return 1
        }else{
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feed = tableView.dequeueReusableCell(withIdentifier: Feed_Cell.identifier, for: indexPath) as! Feed_Cell
        feed.configureCell(cellData: self.post , index: indexPath.row)
        feed.delegate = self
        return feed
    }
    
}


//MARK: Feed Cell...
extension NotificationPostsViewController : Feed_CellDelegate{
    func delete(index : Int){
        self.post = nil
        self.tableView.reloadData()
    }
    func share(post: SocialPost) {
    }
    
    func push(VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func present(VC: UIViewController) {
        self.present(VC, animated: true, completion: nil)
    }
    func update(count: CountUpdate) {
        if count.type == "tag"{
            self.post.tags_count! = count.count
        }else if count.type == "like"{
            self.post.favourite_id = count.favID!
            self.post.feed_favourites = "\(count.count ?? 0)"
        }else if count.type == "commentLike"{
            if count.count == 0{
                self.post.comment!.first?.is_favorite = "no"
            }else{
                self.post.comment!.first?.is_favorite = "yes"
            }
            
        }else{
            if count.comment != nil {
                if self.post.comment != nil && self.post.comment!.count == 0{
                    self.post.comment!.insert(count.comment!, at: 0)
                }else{
                    self.post.comment!.insert(count.comment!, at: 0)
                }
                self.post.feed_comments! = String(count.count)
            }else{
                self.post.feed_comments! = String(count.count)
            }
        }
        self.tableView.reloadData()
//        let indexPath = IndexPath(row: count.index, section: 0)
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: API Calls...!

extension NotificationPostsViewController{

    func Fetch_Notification_Post(post_id : String){
        
        self.addActivityLoader()
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(post_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SinglePost){ response,_ in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    
                    let myResp = response["result"]["data"]
                    for item in myResp{
                        let data = SocialPost(postJSON: item.1)
                        self.post = data
                    }
                    if self.post != nil {
                        self.tableView.isHidden = false
                        self.noPost.isHidden = true
                    }else{
                        self.tableView.isHidden = true
                        self.noPost.isHidden = false
                    }
                    self.tableView.reloadData()
                    self.removeActivityLoader()
                }
                else {
                    self.removeActivityLoader()
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                self.removeActivityLoader()
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
//                    self.postData.insert(post, at: 0)
                    let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared", preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

