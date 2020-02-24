//
//  FollowersListViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 12/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON


class FollowersListViewController: UIViewController {

    @IBOutlet var loaderView: ViewX!
    @IBOutlet weak var tableView: UITableView!
    
    var followerList : [Follower] = [Follower]()
    
    var sendlist: [String] = []
    var other  : String!
//    var sendlist_following : [String] = []

//    var followingList : [SearchGuides] = [SearchGuides]()
    
//   Flag for following and followers
    
    var flag : Bool!
    var isLoadMore : Bool = false
    var currentIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    
        tableView.register(UINib(nibName: "FollowerListTableViewCell", bundle: nil), forCellReuseIdentifier: "followList")
        tableView.reloadData()
        
        
        if !flag{
            self.Followers(other_front_user_id: NetworkController.others_front_user_id)
        }else{
            self.Following(other_front_user_id: NetworkController.others_front_user_id)
        }
        tableView.tableFooterView = UIView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
    }
    
    @IBAction func cancel_btn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

extension FollowersListViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followList", for: indexPath) as! FollowerListTableViewCell
        
        cell.Configure(cellData: self.followerList[indexPath.row])
        cell.follow_btn.tag = indexPath.row
        if self.followerList[indexPath.row].is_followed! == "yes"{
            cell.follow_btn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            cell.follow_btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.follow_btn.setTitle("Following", for: .normal)
            cell.follow_btn.addTarget(self, action: #selector(Follow_Btn(_:)), for: .touchUpInside)
        } else {
            cell.follow_btn.setTitle("Follow+", for: .normal)
            cell.follow_btn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.follow_btn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
            cell.follow_btn.addTarget(self, action: #selector(Follow_Btn(_:)), for: .touchUpInside)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.followerList.count - 1 && !isLoadMore{
        
            if flag{
                if self.followerList.count > 0 {
                     isLoadMore = true
                    
                    self.tableView.tableFooterView = self.LazyLoader()
                    self.tableView.tableFooterView?.isHidden = false
                    self.LoadMoreFollowing(last_id : "\(self.followerList.count)")
                }
            }else{
                if self.followerList.count > 0 {
                     isLoadMore = true
                    self.tableView.tableFooterView = self.LazyLoader()
                    self.tableView.tableFooterView?.isHidden = false
                    self.LoadMoreFollower(last_id : "\(self.followerList.count)")
                }
          
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkController.others_front_user_id = self.followerList[indexPath.row].front_user_id!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func Follow_Btn(_ sender: ButtonY) {
        
        self.currentIndex = sender.tag
        if NetworkController.front_user_id != "0"{
            if self.followerList[sender.tag].is_followed! == "yes"{
                
                self.Follow_Unfollow(other_front_user_id: self.followerList[sender.tag].front_user_id!, followStatus: "unfollow")
            }else{
                self.Follow_Unfollow(other_front_user_id: self.followerList[sender.tag].front_user_id!, followStatus: "follow")
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
        }
        
    }
    
}


//MARK: API calls

extension FollowersListViewController{
    
    func Following(other_front_user_id : String){
    
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(other_front_user_id)",
            "my_id" : "\(NetworkController.front_user_id)",
            "sendlist" : "\(self.sendlist)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Following){ resp,_ in
            
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    let followerDataResp = resp["result"]["my_following"]
                    for post in followerDataResp{
                        let data = Follower(followerJSON: post.1)
                        self.sendlist.append(data.front_user_id!)
                        self.followerList.append(data)
                    }
                    self.tableView.reloadData()
                    self.removeActivityLoader()
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(resp["result"]["description"].stringValue)"))")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
            
        }
    }
    
    
    func LoadMoreFollowing(last_id : String){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.others_front_user_id)",
            "my_id" : "\(NetworkController.front_user_id)",
            "sendlist" : "\(self.sendlist)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Following){ resp,_ in
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    let followerDataResp = resp["result"]["my_following"]
                    if followerDataResp.count != 0 {
                        for post in followerDataResp
                        {
                            let data = Follower(followerJSON: post.1)
                            self.followerList.append(data)
                            self.sendlist.append(data.front_user_id!)
                        }
                        self.isLoadMore = false
                        self.tableView.tableFooterView?.isHidden = true
                        self.tableView.reloadData()
                    }
                    self.tableView.tableFooterView?.isHidden = true
                   
                }else{
                    self.tableView.tableFooterView?.isHidden = true
                    self.presentError(massageTilte: "\(String(describing: "\(resp["result"]["description"].stringValue)"))")
                }
            }else{
                self.tableView.tableFooterView?.isHidden = true
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
            
        }
    }
    
    
    func Followers(other_front_user_id : String){
        self.addActivityLoader()
        let parameters : [String : Any] = [
            "front_user_id" : "\(other_front_user_id)",
            "my_id" : "\(NetworkController.front_user_id)",
            "sendlist" : "\(self.sendlist)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Followers){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let followerDataResp = response["result"]["my_followers"]
                    for post in followerDataResp{
                        let data = Follower(followerJSON: post.1)
                        self.followerList.append(data)
                        self.sendlist.append(data.front_user_id!)
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
    
    func LoadMoreFollower(last_id : String){

        let parameters : [String : Any] = [
            "front_user_id" : "\(NetworkController.others_front_user_id)",
            "my_id" : "\(NetworkController.front_user_id)",
            "sendlist" : "\(self.sendlist)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Followers){resp,_ in
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    let followerDataResp = resp["result"]["my_followers"]
                    print(followerDataResp)
                    print(followerDataResp.count)
                    if followerDataResp.count != 0 {
                        for post in followerDataResp
                        {
                            let data = Follower(followerJSON: post.1)
                            self.followerList.append(data)
                            self.sendlist.append(data.front_user_id!)
                        }
                        self.isLoadMore = false
                        self.tableView.tableFooterView?.isHidden = true
                        self.tableView.reloadData()
                    }
                    self.tableView.tableFooterView?.isHidden = true
                   
                }else{
                    self.isLoadMore = false
                    self.tableView.tableFooterView?.isHidden = true
                    self.presentError(massageTilte: "\(String(describing: "\(resp["result"]["description"].stringValue)"))")
                }
            }else{
                self.isLoadMore = false
                self.tableView.tableFooterView?.isHidden = true
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
            
        }
    }

    func Follow_Unfollow( other_front_user_id : String , followStatus : String ){
        print(other_front_user_id)
        let parameters : [String: Any] = [
            "front_user_id" : "\(other_front_user_id)",
            "my_id" : "\(NetworkController.front_user_id)",
            "type" : "\(followStatus)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .FollowUnfollow){ resp,_ in
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    let cell = self.tableView.cellForRow(at: IndexPath(row: self.currentIndex, section: 0)) as! FollowerListTableViewCell
                    if followStatus == "follow"{
                        self.followerList[self.currentIndex].is_followed! = "yes"
                        
                        UIView.transition(with: cell.follow_btn as UIView, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve , animations: {
                            cell.follow_btn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                            cell.follow_btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , for: .normal)
                            cell.follow_btn.setTitle("Following", for: .normal)
                            
                        }, completion: nil)
                    }else if followStatus == "unfollow"{
                        //                        self.follow_btn.setTitle("Following", for: .normal)
                        self.followerList[self.currentIndex].is_followed! = "no"
                        UIView.transition(with: cell.follow_btn as UIView, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve , animations: {
                            cell.follow_btn.backgroundColor = UIColor.clear
                            cell.follow_btn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
                            cell.follow_btn.setTitle("Follow +", for: .normal)
                        }, completion: nil)
                    }
                }
                
            }else{
            }
        }
    }
    
}
