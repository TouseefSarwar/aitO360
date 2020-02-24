//
//  FirstView.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 27/06/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

protocol FirstViewDelegate {
    func push(view Controller : UIViewController)
    func Loader(isAdded : Bool)
    func present(view : UIViewController)
}


class FirstView: UITableViewCell {

  
    @IBOutlet weak var profile_image: ImageViewX!
    @IBOutlet weak var user_name: UIButton!
    @IBOutlet weak var type_label: UILabel!
    @IBOutlet weak var post: UIButton!
    @IBOutlet weak var time: UILabel!
    
    var cellData: NotificationResponse!
    var delegate : FirstViewDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func Configure(cell : NotificationResponse){
        
        cellData = cell
        if cellData.comment_id! != "0" {
        }
        if cellData.post_id! == "0" {
//            if cellData.photo_id! == "0"{
//                self.post.isHidden = true
//            }
//            print(cell)
//            print(cell.post_id!)
//            print(cell.notification_id!)
//            print(cell.target_type!)
            self.post.isHidden = true
        }
        
        
        let resource = ImageResource(downloadURL: URL(string: (cellData.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)!, cacheKey: cellData.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        self.profile_image.kf.indicatorType = .activity
        self.profile_image.kf.setImage(with: resource)
        self.user_name.setTitle("\(cellData.user_name!)", for: .normal)
        self.type_label.text = cellData.type!
        self.post.setTitle("\(cellData.target_type!)", for: .normal)
        self.time.text = NetworkController.shared.dateConverter(dateString: cell.created_date!)
        
        let tapProfileImg = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
        self.profile_image.isUserInteractionEnabled = true
        self.profile_image.addGestureRecognizer(tapProfileImg)
        
    }
    
}


extension FirstView {
    @objc func TappedUser(sender : UITapGestureRecognizer){

        if NetworkController.front_user_id != self.cellData.front_user_id{
            NetworkController.others_front_user_id = self.cellData.front_user_id!
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        self.delegate.push(view: vc)
    }
    
    @IBAction func userName_Btn(_ sender: Any) {
        if NetworkController.front_user_id != self.cellData.front_user_id{
            NetworkController.others_front_user_id = self.cellData.front_user_id!
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        self.delegate.push(view: vc)
    }
    
    @IBAction func post_Btn(_ sender: Any) {
        
    
        if self.cellData.target_type! == "comment"{
            
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "comment") as! CommentsViewController
            VC.notification_flag = true
            VC.notificationLocalFlag = true
            VC.n_postId = self.cellData.post_id!
            VC.n_photoId = self.cellData.photo_id!
            self.delegate?.push(view: VC)
        }else if self.cellData.target_type! == "photo"{
            

            self.GetSingleImage(photo_id: cellData.photo_id!) { (photo) in
                    let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
                    VC.photo.append(photo)
                    VC.index = 0
                    self.delegate?.push(view: VC)
            }
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "postNotification") as! NotificationPostsViewController
            vc.postId = self.cellData.post_id!
            self.delegate?.push(view: vc)
        }
        
    }
    
}


extension FirstView{
    //MARK: Get Single Image Details....
    func GetSingleImage(photo_id : String, onComplition : @escaping (Photo) -> Void){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "last_id" : "",
            "photo_id" : "\(photo_id)"
        ]
        self.delegate.Loader(isAdded: true)
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserPhotos){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["photos"]
                    for post in resp{
                        let data = Photo(photoData: post.1)
                        onComplition(data)
                    }
                    self.delegate.Loader(isAdded: false)
                }else{
                    
                    self.delegate.Loader(isAdded: false)
                    print("\(response["result"]["description"].stringValue)")
                }
            }else{
                
                self.delegate.Loader(isAdded: false)
                print("Oops...something went wrong")
            }
        }
    }
}
