//
//  VideoViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 10/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class VideoViewController: UIViewController {

    //Variables
    var videoResp : JSON = JSON.null
    var videos : [VideoProfile] = []
    
    //Segue Variables
    var post_id : String!
    var type :  String!
    var index : Int!
    
    // IBOutlet.....
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var no_video: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NetworkController.others_front_user_id != "0"{
            Get_Videos(front_user_id: NetworkController.others_front_user_id)
        }else{
            Get_Videos(front_user_id: NetworkController.front_user_id)
        }
        self.title = "Videos"
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VideoProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "vid")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showComment"{
            let nav = segue.destination as! UINavigationController
            let vc : CommentsViewController = nav.topViewController as! CommentsViewController
            vc.post_id = self.post_id
            vc.type = "photo"
            vc.video = self.videos[index]
            
        }else if segue.identifier == "showTags"{
            let nav = segue.destination as! UINavigationController
            let VC : TagUsersViewController = nav.topViewController as! TagUsersViewController
            VC.post_id = self.post_id
            VC.type = "photo"
            
        }
    }

}
//tableview delegate and datasource

extension VideoViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vid", for: indexPath) as! VideoProfileTableViewCell
        
        cell.Configure(cellData: self.videos[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
}


// VideoCells Delegates

extension VideoViewController : VideoProfileCellDelegate{
    
    func pushVideoProfile(viewController : UIViewController){
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func AlertControllerVideo(alert: UIAlertController) {
         self.present(alert, animated: true, completion: nil)
    }
    
    func PerformSegueVideo(data: VideoProfile, identifier: String , index : Int) {
        self.post_id = data.id!
        self.index = index
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    func deletedRowVideo(tag: Int) {
        
//        let index =  IndexPath(row: tag, section: 0)
//        self.postData.remove(at: tag)
//        print(index.row)
//        print(tag)
//        self.tableView.deleteRows(at: [index], with: .fade)
//        self.tableView.reloadData()
    }
    
    func ShareToYentnaVideo(post: VideoProfile, shareCaption: String) {
         self.Share(postid: post.id!, caption: shareCaption, post: post)
    }
    
    func SocialShareVideo(postId: String) {
        let num = NetworkController.shared.random(digits: 8)
        let activityVC =  UIActivityViewController(activityItems: ["\(NetworkController.shareURL)\(String(num))\(postId)"], applicationActivities: nil)
         activityVC.excludedActivityTypes = [UIActivity.ActivityType.mail, UIActivity.ActivityType.message]
        self.present(activityVC, animated: true, completion: nil)
        
    }
}


// Mark :- API Calls
extension VideoViewController{
    
    func Get_Videos(front_user_id : String){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "last_id" : ""
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserVideos){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.videoResp = response["result"]["videos"]
                    
                    for post in self.videoResp{
                        let data = VideoProfile(videoJSON : post.1)
                        self.videos.append(data)
                    }
                    if self.videos.count > 0{
                        self.no_video.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }else{
                        self.no_video.isHidden = false
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
        
    }
    
    func Share(postid : String, caption : String, post : VideoProfile){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(postid)",
            "type" : "post",
            "share_caption" : "\(caption)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){
            response,_ in
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
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }

    func LoadMore_Videos(front_user_id : String , last_id : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "last_id" : "\(last_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserVideos){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.videoResp = response["result"]["videos"]
                    for post in self.videoResp{
                        let data = VideoProfile(videoJSON : post.1)
                        self.videos.append(data)
                    }
                    self.tableView.reloadData()
                }else{
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
}

