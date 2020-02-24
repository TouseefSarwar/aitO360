//
//  PeopleLikedViewController.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 23/09/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import SwiftyJSON

class PeopleLikedViewController: UIViewController {

    @IBOutlet weak var loaderView : UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noLiked : UILabel!
    @IBOutlet weak var backBtn : UIBarButtonItem!
    
    var peopleList :  [Follower] = []
    var postId : String = ""
    //// Content of type mean photo / post
    var content_type : String = ""
    var currentIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.nav = "People who lik this"
        self.title = "People who like this"
        if self.content_type == "photo"{
            self.navigationItem.leftBarButtonItems = [backBtn]
        }else{
            self.navigationItem.leftBarButtonItem = nil
        }
        self.PeopleLiked(type : content_type)
        tableView.register(UINib(nibName: "FollowerListTableViewCell", bundle: nil), forCellReuseIdentifier: "followList")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }

    
    @IBAction func close(_ sender : UIBarButtonItem){
        if self.content_type == "photo"{
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = .fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
        }
    }
}


///MARK: Api calls
extension PeopleLikedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.peopleList.count > 0 {
            return self.peopleList.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followList", for: indexPath) as! FollowerListTableViewCell
        
        cell.Configure(cellData: self.peopleList[indexPath.row])
        if self.peopleList[indexPath.row].front_user_id! == NetworkController.front_user_id{
            cell.follow_btn.isHidden = true
        }else{
            cell.follow_btn.isHidden = false
        }
        cell.follow_btn.tag = indexPath.row
        if self.peopleList[indexPath.row].is_followed! == "yes"{
            cell.follow_btn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            cell.follow_btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.follow_btn.setTitle("Following", for: .normal)
            cell.follow_btn.addTarget(self, action: #selector(Follow_Btn(_:)), for: .touchUpInside)
        }else{
            cell.follow_btn.setTitle("Follow+", for: .normal)
            cell.follow_btn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.follow_btn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
            cell.follow_btn.addTarget(self, action: #selector(Follow_Btn(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkController.others_front_user_id = self.peopleList[indexPath.row].front_user_id!
        
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func Follow_Btn(_ sender: ButtonY) {
        
        self.currentIndex = sender.tag
        if NetworkController.front_user_id != "0"{
            if self.peopleList[sender.tag].is_followed! == "yes"{
                
                self.Follow_Unfollow(other_front_user_id: self.peopleList[sender.tag].front_user_id!, followStatus: "unfollow")
            }else{
                self.Follow_Unfollow(other_front_user_id: self.peopleList[sender.tag].front_user_id!, followStatus: "follow")
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
        }
        
    }
    
}



///MARK: Api calls
extension PeopleLikedViewController {
    
    func PeopleLiked(type : String){
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "post_id" : self.postId,
                "type" : type
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .PeopleLiked){
                response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true {
                        let searchDataResp = response["result"]["users"]
                        for post in searchDataResp{
                            let data = Follower(followerJSON: post.1)
                            self.peopleList.append(data)
                        }
                        if self.peopleList.count > 0 {
                            self.tableView.isHidden  = false
                            self.noLiked.isHidden = true
                        }else{
                            
                            self.tableView.isHidden  = true
                            self.noLiked.isHidden = false
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
                        self.peopleList[self.currentIndex].is_followed! = "yes"
                        
                        UIView.transition(with: cell.follow_btn as UIView, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve , animations: {
                            cell.follow_btn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                            cell.follow_btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , for: .normal)
                            cell.follow_btn.setTitle("Following", for: .normal)
                            
                        }, completion: nil)
                    }else if followStatus == "unfollow"{
                        //                        self.follow_btn.setTitle("Following", for: .normal)
                        self.peopleList[self.currentIndex].is_followed! = "no"
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
