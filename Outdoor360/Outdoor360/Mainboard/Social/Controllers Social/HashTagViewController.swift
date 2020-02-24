//
//  HashTagViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 01/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class HashTagViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var hashTags : [SocialPost] = [SocialPost]()
    var hashtagString : String!
    
    var cellHeights = [IndexPath: CGFloat]()
    var load_more : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.title = "#\(self.hashtagString!)"
        tableView.register(UINib(nibName: "Feed_Cell", bundle: nil), forCellReuseIdentifier: Feed_Cell.identifier)
        
        if self.hashtagString != ""{
            Get_HashTags(hashtag: hashtagString)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}


// Mark :- TableView Delegates and DataSources

extension HashTagViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hashTags.count > 0 {
            return hashTags.count
        }else{
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let feed = tableView.dequeueReusableCell(withIdentifier: Feed_Cell.identifier, for: indexPath) as! Feed_Cell
            feed.configureCell(cellData: self.hashTags[indexPath.row], index: indexPath.row)
            feed.delegate = self
            return feed
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        if indexPath.row == self.hashTags.count - 1 && !self.load_more{
            self.tableView.tableFooterView = self.LazyLoader()
            self.tableView.tableFooterView?.isHidden = false
            self.load_more = true
            let index = self.hashTags.count - 1
            LoadMoreData(other_front_user: "0", last_post_id: self.hashTags[index].id!)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
}



//Mark: FeedsCell....
extension HashTagViewController : Feed_CellDelegate{
    func delete(index : Int){
        let indexPath =  IndexPath(row: index, section: 0)
        self.hashTags.remove(at: index)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func share(post: SocialPost) {
        self.hashTags.insert(post, at: 0)
    }
    
    func push(VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func present(VC: UIViewController) {
        self.present(VC, animated: true, completion: nil)
    }
    
    func update(count: CountUpdate) {
        if count.type == "tag"{
            self.hashTags[count.index].tags_count! = count.count
        }else if count.type == "like"{
            self.hashTags[count.index].favourite_id = count.favID!
            self.hashTags[count.index].feed_favourites = "\(count.count ?? 0)"
        }else if count.type == "commentLike"{
            if count.count == 0{
                self.hashTags[count.index].comment!.first?.is_favorite = "no"
            }else{
                self.hashTags[count.index].comment!.first?.is_favorite = "yes"
            }
            
        }else{
            if count.comment != nil {
                if self.hashTags[count.index].comment != nil && self.hashTags[count.index].comment!.count == 0{
                    self.hashTags[count.index].comment!.insert(count.comment!, at: 0)
                }else{
                    self.hashTags[count.index].comment!.insert(count.comment!, at: 0)
                }
                self.hashTags[count.index].feed_comments! = String(count.count)
            }else{
                self.hashTags[count.index].feed_comments! = String(count.count)
            }
        }
        self.tableView.reloadData()
//        let indexPath = IndexPath(row: count.index, section: 0)
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


// Mark :- API Calls
extension HashTagViewController{
    
    func LoadMoreData(other_front_user : String , last_post_id : String){
        
        self.load_more = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        let parameters : [String: Any] = [
            "front_user_id" : "\(other_front_user)",
            "feed_id" : "\(last_post_id)",
            "hashtag" : "\(hashtagString!)",
            "my_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters , nameOfService: .LoadMorePosts){ response, _ in
            
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    let myResp = response["result"]["data"]
                    for post in myResp{
                        let data = SocialPost(postJSON: post.1)
                        self.hashTags.append(data)
                    }
                   
                    self.load_more = false
                    self.tableView.tableFooterView?.isHidden = true
                    self.tableView.reloadData()
                }else{
                    self.load_more = false
                    self.tableView.tableFooterView?.isHidden = true
                }
            }else{
                self.load_more = false
                self.tableView.tableFooterView?.isHidden = true
            }
        }
        
        
    }
    
    func Get_HashTags(hashtag : String){
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "hashtag" : "\(hashtag)"
            ]
            
            NetworkController.shared.Service(parameters: parameters , nameOfService: .HashTag){ response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        let myResp = response["result"]["data"]
                        for post in myResp{
                            let data = SocialPost(postJSON: post.1)
                            self.hashTags.append(data)
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
        }else{
            self.presentError(massageTilte: "No Internet Connection")
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
//                    self.postData.insert(post, at: 0)
                    let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared", preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "Oops...something went wrong")
            }
        }
    }
    
}



