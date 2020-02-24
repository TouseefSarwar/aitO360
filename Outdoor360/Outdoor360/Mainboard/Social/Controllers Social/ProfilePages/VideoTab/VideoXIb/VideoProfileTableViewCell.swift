//
//  VideoProfileTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 31/08/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import ActiveLabel
import Kingfisher
import SwiftyJSON

protocol VideoProfileCellDelegate : class {
    func AlertControllerVideo(  alert : UIAlertController)
    func PerformSegueVideo(data : VideoProfile , identifier : String , index : Int)
    func deletedRowVideo(tag : Int)
    func ShareToYentnaVideo(post : VideoProfile, shareCaption : String)
    func SocialShareVideo(postId: String)
    func pushVideoProfile(viewController : UIViewController)
}

class VideoProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var user_Image: ImageViewX!
    @IBOutlet weak var user_Name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var videoProfileView: AGVideoPlayerView!
    @IBOutlet weak var likeCount: ButtonY!
    @IBOutlet weak var commentCount: ButtonY!
    @IBOutlet weak var tagCount: ButtonY!
    @IBOutlet weak var more_btn : ButtonY!
    
    @IBOutlet weak var like : ButtonY!
    @IBOutlet weak var comment : ButtonY!
    @IBOutlet weak var tagB : UIButton!
    
    
    var data : VideoProfile!
    var index : Int!
    weak var delegate : VideoProfileCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func Configure(cellData : VideoProfile , index : Int){
        self.data = cellData
        self.index = index
        if self.data.favourite_id == "" {
            self.like.setImage(#imageLiteral(resourceName: "Unlike"), for: .normal)
        }else{
            self.like.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
        if self.data.user_id! == NetworkController.front_user_id {
            self.more_btn.isHidden = false
        }
        
        let resource = ImageResource(downloadURL: URL(string: (self.data.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)!, cacheKey: self.data.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.user_Image.kf.indicatorType = .activity
        self.user_Image.kf.setImage(with: resource, placeholder : #imageLiteral(resourceName: "placeholderImage"))
        self.user_Name.text = "\(self.data.first_name!) \(self.data.last_name!)"
//        let tapProfileImg = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
//        self.user_Image.isUserInteractionEnabled = true
//        self.user_Image.addGestureRecognizer(tapProfileImg)
//
//        //Tap Guesture on userName
//        let tapUserName = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
//        self.user_Name.isUserInteractionEnabled = true
//        self.user_Name.addGestureRecognizer(tapUserName)
        
        
        
        
        self.time.text =  NetworkController.shared.dateConverter(dateString:  self.data.created!)
        
        self.likeCount.setTitle("\(self.data.feed_favourites!)", for: .normal)
        self.commentCount.setTitle("\(self.data.feed_comments!)", for: .normal)
        print(self.data.tag_count!)
        self.tagCount.setTitle("\(self.data.tag_count!)", for: .normal)
//        self.tag_btn.addTarget(self, action: #selector(self.TagPost(_sender:)), for: .touchUpInside)
//        self.like_Btn.addTarget(self, action: #selector(self.LikePost(_sender:)), for: .touchUpInside)
//        self.comment_Btn.addTarget(self, action: #selector(self.CommentPost(_sender:)), for: .touchUpInside)
//        self.share_Btn.addTarget(self, action: #selector(self.SharePost(_sender:)), for: .touchUpInside)
//        self.more_btn.addTarget(self, action: #selector(self.More(_sender:)), for: .touchUpInside)
        //Video Player
        
        self.videoProfileView.videoUrl = URL(string: "\(self.data.video!)")
        self.videoProfileView.shouldSwitchToFullscreen = true
        self.videoProfileView.showsCustomControls = true
        
    }
}

// Mark :- Like Comment Share Tag

extension VideoProfileTableViewCell{
    
    
    @IBAction func morBtn(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Options!", message: "Choose an option", preferredStyle: .actionSheet)
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
//
//        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler:{ alert -> (Void) in
//
//            let alertEdit = UIAlertController(title: "Edit", message: "Edit Caption", preferredStyle: .alert)
//            alertEdit.addAction(UIAlertAction(title: "Update", style: .default, handler: { (alert) -> (Void)in
//
//                let txtFeild = alertEdit.textFields![0] as UITextField
//                print(txtFeild.text!)
//
//                NetworkController.sharedInstance.update_post_caption(front_user_id: "\(NetworkController.front_user_id)", post_id: self.data.id!, feed_content: "\(txtFeild.text!)", type: "post"){ resp in
//
//                    if resp != JSON.null{
//                        if resp["result"]["status"].boolValue == true{
//
//                            print(resp["result"]["status"].boolValue)
////                            self.data.feed_content = txtFeild.text!
////                            self.content.text = txtFeild.text
//                            let alert =  UIAlertController(title : "Alert!" , message : "Successfully Updated", preferredStyle :UIAlertControllerStyle.alert )
//                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertActionStyle.cancel , handler : nil))
//                            self.delegate?.AlertControllerVideo(alert: alert)
//
//
//                        }else{
//
//                            let alert =  UIAlertController(title : "Error!" , message : "\(resp["result"]["description"].stringValue)", preferredStyle :UIAlertControllerStyle.alert )
//                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertActionStyle.cancel , handler : nil))
//                            self.delegate?.AlertControllerVideo(alert: alert)
//                        }
//                    }else{
//                        let alert =  UIAlertController(title : "Network Error!" , message : "Internet Connection Interrupted", preferredStyle :UIAlertControllerStyle.alert )
//                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertActionStyle.cancel , handler : nil))
//                        self.delegate?.AlertControllerVideo(alert: alert)
//                    }
//
//
//                }
//
//
//            }))
//            alertEdit.addTextField(configurationHandler: {(txtF)-> Void in
////                txtF.text = "\(self.content.text!)"
//            })
//
//            alertEdit.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//            self.delegate?.AlertControllerVideo(alert: alertEdit)
//            //            self.present(alertEdit, animated: true, completion: nil)
//        }))
//
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "post_id" : "\(self.data.id!)",
                "type" : "post"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost){
                response,_ in
                if response != JSON.null{
                    if response["result"]["status"].boolValue == true{
                        let alert =  UIAlertController(title : "Successfully Deleted" , message : nil , preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertControllerVideo(alert: alert)
//                        self.delegate?.deletedRowVideo(tag: self.index)
                        
                    }else{
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil , preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertControllerVideo(alert: alert)
                    }
                }else{
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertControllerVideo(alert: alert)
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.delegate?.AlertControllerVideo(alert: actionSheet)
    }
    
    
    @IBAction func shareBtn(_ sender: Any) {
        let shareAlert = UIAlertController(title: "Share Post", message: "Select the social network you wish to share post on.", preferredStyle: .actionSheet)
        shareAlert.modalPresentationStyle = .popover
        shareAlert.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        shareAlert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        shareAlert.addAction(UIAlertAction(title: "Share on Yentna", style: .default , handler: {_ in
            let alert = UIAlertController(title: "Share", message: "Share Post on Yentna", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Share Now", style: .default, handler: { _ in
                
                let txtFeild = alert.textFields![0] as UITextField
                self.delegate?.ShareToYentnaVideo(post: self.data!, shareCaption: txtFeild.text!)
                
            }))
            alert.addTextField(configurationHandler: {(txtF)-> Void in
                txtF.placeholder = "Add Caption"
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.delegate?.AlertControllerVideo(alert: alert)
            
        }))
        shareAlert.addAction(UIAlertAction(title: "Share to Socail Network", style: .default , handler: {_ in
            
            self.delegate?.SocialShareVideo(postId: self.data.id!)
            
        }))
        
        shareAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: {_ in
            
        }))
        
        self.delegate?.AlertControllerVideo(alert: shareAlert)
    }
    
    @IBAction func likeBtn(_ sender: Any) {
        if ((sender as AnyObject).currentImage?.isEqual(UIImage(named: "like")))!{
            let parameters : [String: Any] = [
                "post_id" : "\(data.original_post_id!)",
                "front_user_id" : "\(NetworkController.front_user_id)",
                "type" : "post",
                "state" : "unlike"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                if response != JSON.null{
                    
                    print("\(response["result"]["status"])")
                    if response["result"]["status"].boolValue == true{
                        self.likeCount.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                        
                        //  DispatchQueue.main.async {
                        UIView.transition(with: sender as! UIView, duration: 0.8, options: .transitionCrossDissolve, animations: {
                            (sender as AnyObject).setImage(#imageLiteral(resourceName: "Unlike"), for: .normal)
                            
                            self.likeCount.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                        }, completion: nil)
                        
                    }
                    else {
                        
                        
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)", message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertControllerVideo(alert: alert)
                        //                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                }else{
                    
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertControllerVideo(alert: alert)
                }
            }
            
        }
        else{
            let parameters : [String: Any] = [
                "post_id" : "\(data.original_post_id!)",
                "front_user_id" : "\(NetworkController.front_user_id)",
                "type" : "post",
                "state" : "like"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                if response != JSON.null{
                    print("\(response["result"]["status"])")
                    if response["result"]["status"].boolValue == true{
                        self.likeCount.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                        print("\(response["result"]["like_count"].stringValue)")
                        //DispatchQueue.main.async {
                        UIView.transition(with: sender as! UIView, duration: 0.8, options: .transitionCrossDissolve, animations: {
                            (sender as AnyObject).setImage(#imageLiteral(resourceName: "like"), for: .normal)
                            
                            self.likeCount.setTitle("\("\(response["result"]["like_count"].stringValue)")", for: .normal)
                            
                            
                        }, completion: nil)
                        //}
                        //self.tableView.reloadRows(at: [indexPath] , with: .bottom)
                    }
                    else {
                        
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil , preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertControllerVideo(alert: alert)
                    }
                    
                    
                }else{
                    
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertControllerVideo(alert: alert)
                }
            }
        }
    }
    
    @IBAction func tagBtn(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TagUsersViewController") as! TagUsersViewController
//        vc.delegate = self
//        vc.index = self.index
////        vc.post = self.data
//        vc.content_type = "photo"
//        self.delegate?.pushVideoProfile(viewController: vc)
        
        
        
        self.delegate?.PerformSegueVideo(data: data, identifier: "showTags", index: index)
    }
    @IBAction func commentBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "comment") as! CommentsViewController
//        vc.delegate = self
//        vc.index = self.index
//        vc.post = self.data
//        self.delegate?.pushVideo(viewController: vc)
//
//        self.delegate.PerformSegueVideo(data: data, identifier: "showComment" , index : index)
    }
    
    @objc func connented(sender : UITapGestureRecognizer ) {
        
        NetworkController.photo_id = self.data.original_post_id!
        self.delegate?.PerformSegueVideo(data: self.data, identifier: "showImage", index: index)
        
        
        //    performSegue(withIdentifier: "showImage", sender: self)
    }
    @objc func TappedUser(sender : UITapGestureRecognizer){
        print("Tapped on Label and Image Both")
        if NetworkController.front_user_id != self.data.user_id!{
            NetworkController.others_front_user_id = self.data.user_id!
        }
        self.delegate?.PerformSegueVideo(data: self.data, identifier: "showProfile" , index: index)
    }
}




//extension VideoProfileTableViewCell : CommentsCountDelegate , TagDelegate{
//    func TagCount(count: Int, index: Int) {
//        self.delegate?.TagCountVideo(count: count, index: index)
//    }
//
//    func UpdatedCount(count: Int, index: Int, comment : CommentsResponse?){
//        self.delegate?.updateCommentCountVideo(count: count, index: index, comment: comment)
//    }
//}
//
//extension VideoProfileTableViewCell : AnimatedCommentDelegate{
//
//    func UpdateComment(comment: CommentsResponse?, count : Int?) {
//        self.delegate?.updateCommentCountVideo(count: count! , index: self.index, comment: comment)
//    }
//
//}
