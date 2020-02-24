//
//  ViewMoreViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 18/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher

class ViewMoreViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var profileData : ProfileResponse?
    
    var list_of_followers : [Follower] = []
    var list_of_following : [Follower] = []
    
    var sendlist_follower : [String] = []
    var sendlist_following : [String] = []
    
    var flag : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ViewMoreViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as? ImageTableViewCell
            
            let res = ImageResource(downloadURL: URL(string: (self.profileData?.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.profileData?.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            imageCell!.user_image.kf.indicatorType = .activity
            imageCell!.user_image.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
            
            return imageCell!
        case 1:
            let name = tableView.dequeueReusableCell(withIdentifier: "name", for: indexPath) as? NameTableViewCell

            name?.username.text = "About " + (self.profileData?.first_name)! + " " + (self.profileData?.last_name)!
            return name!
//        case 2:
//            let member = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as? MemberTableViewCell
//            member?.member_since.text = self.profileData?.member_since!
//            return member!
//        case 3:
//            let followers = tableView.dequeueReusableCell(withIdentifier: "followers", for: indexPath) as? FollowerTableViewCell
//            followers?.followerCount.text = self.profileData?.follower!
//            return followers!
//        case 4:
//            let following = tableView.dequeueReusableCell(withIdentifier: "following", for: indexPath) as? FollowingTableViewCell
//            following?.followingCount.text = self.profileData?.following
//            return following!
        
        case 2:
            let desc = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath) as? DescriptionTableViewCell
                desc?.descrip.text = self.profileData?.user_description!
            return desc!
            
        default:
            let cell = UITableViewCell()
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let f_VC = storyboard.instantiateViewController(withIdentifier: "followers") as? FollowersListViewController
            f_VC?.followerList = self.list_of_followers
            f_VC?.sendlist = self.sendlist_follower
            f_VC?.flag = false
            f_VC?.title = "Followers"
            let nav = UINavigationController(rootViewController: f_VC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        case 4:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let f_VC = storyboard.instantiateViewController(withIdentifier: "followers") as? FollowersListViewController

            f_VC?.followerList = self.list_of_following
            f_VC?.sendlist = self.sendlist_following
            
            f_VC?.flag = true
            f_VC?.title = "Following"
            let nav = UINavigationController(rootViewController: f_VC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        default:
            print("Selected index is not clickable")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
