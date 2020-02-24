//
//  Header.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 13/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON


protocol AlbumHeaderDelegate {
    func AlertController(alert : UIViewController)
    func ShareToYentna(album_id : String, shareCaption: String)
    func SocialShare(album_id : String)
    func DismissController(animated : Bool)
    func PerformSegue(albumDet : ALbumDetail , identifier : String)
    func Delete(isSelected : Bool)
    func AddPhoto()
    func pushAlbum(view : UIViewController)

    func update(count : CountUpdate)
    
}



class Header: UICollectionReusableView {

    @IBOutlet weak var profile_image: ImageViewX!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var album_caption: UILabel!
    @IBOutlet weak var album_Title: UILabel!
    
    @IBOutlet weak var likeButton: ButtonY!
    @IBOutlet weak var like_count: ButtonY!
    
    @IBOutlet weak var comment_btn: ButtonY!
    @IBOutlet weak var comment_count: ButtonY!
    
    @IBOutlet weak var tag_btn: UIButton!
    @IBOutlet weak var tag_count: ButtonY!
    
    @IBOutlet weak var share_btn: ButtonY!
    
    @IBOutlet weak var share_count: ButtonY!
    
    @IBOutlet weak var moreArrow: UIButton!
    
    var albumDetail : ALbumDetail?
    var delegate : AlbumHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.moreArrow.isHidden = true
    }
    
    
    func ConfigureHeader(albumDetail: ALbumDetail){
        
        self.albumDetail = albumDetail
        
//        print(self.albumDetail?.favourite_id)
//        print(self.albumDetail?.feed_favourites)
        if self.albumDetail?.favourite_id == "" || self.albumDetail?.favourite_id == nil{
            self.likeButton.setImage(#imageLiteral(resourceName: "Unlike"), for: .normal)
        }else{
            self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
        
        if self.albumDetail?.user_id! == NetworkController.front_user_id {
            self.moreArrow.isHidden = false
        }
        
        self.name.text = (albumDetail.first_name!) + " " + (albumDetail.last_name!)
        self.album_caption.text = albumDetail.feed_content!
        self.album_Title.text = albumDetail.album_title!
        self.comment_count.setTitle(albumDetail.feed_comments!, for: .normal)
        self.like_count.setTitle(albumDetail.feed_favourites!, for: .normal)
        self.tag_count.setTitle(albumDetail.tagged_count!, for: .normal)
        
        self.moreArrow.addTarget(self, action: #selector(More(sender:)), for: .touchUpInside)
        
        let resource = ImageResource(downloadURL: URL(string: (albumDetail.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: albumDetail.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.profile_image.kf.indicatorType = .activity
        self.profile_image.kf.setImage(with: resource)
    }
 
   
}


extension Header : CommentsCountDelegate, TagDelegate{
    //Comment Delegate
    func UpdatedCount(count: Int, index: Int, comment : CommentsResponse?){
        let updates = CountUpdate(type: "comment", index: 0, count: count, favID : nil, comment: nil)
        self.delegate?.update(count: updates)
    }
    
    
    //tag Delegate
    func TagCount(count: Int, index: Int) {
        let updates = CountUpdate(type: "tag", index: 0, count: count, favID : nil, comment: nil)
        self.delegate?.update(count: updates)
    }
}
//Mark: Like Comment Share Tag

extension Header{
    
    @IBAction func commentBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "comment") as! CommentsViewController
        vc.album = self.albumDetail
        vc.delegate = self
        self.delegate?.pushAlbum(view: vc)
    }
    
    @IBAction func tagBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "TagUsersViewController") as! TagUsersViewController
        VC.type = "post"
        VC.delegate = self
        VC.album = self.albumDetail
        self.delegate?.pushAlbum(view: VC)
        
        
    }
    
    //Mark:
    @IBAction func shareBtn(_ sender: Any) {
//        print("Share pressed:  \((sender as AnyObject).tag)")
        let shareAlert = UIAlertController(title: "Share Post", message: "Select the social network you wish to share post on.", preferredStyle: .actionSheet)
        
        shareAlert.addAction(UIAlertAction(title: "Share on Outdoors360", style: .default , handler: {_ in
            
            let alert = UIAlertController(title: "Share", message: "Share Post on Outdoors360", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Share Now", style: .default, handler: { _ in
                
                let txtFeild = alert.textFields![0] as UITextField
                self.delegate?.ShareToYentna(album_id: (self.albumDetail?.id!)!, shareCaption: txtFeild.text!)
                
            }))
            alert.addTextField(configurationHandler: {(txtF)-> Void in
                txtF.placeholder = "Add Caption"
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.delegate?.AlertController(alert: alert)
        }))
        shareAlert.addAction(UIAlertAction(title: "Share to Socail Network", style: .default , handler: {_ in
            self.delegate?.SocialShare(album_id: (self.albumDetail?.id)!)
            
        }))
        
        shareAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: {_ in
            
        }))
        self.delegate?.AlertController(alert: shareAlert)
    }
    
    
    @IBAction func LikeBtn(_ sender: Any) {
        
        if ((sender as AnyObject).currentImage?.isEqual(UIImage(named: "like")))!{
            let parameters : [String: Any] = [
                "post_id" : "\(self.albumDetail!.original_post_id!)",
                "front_user_id" : "\(NetworkController.front_user_id)",
                "type" : "post",
                "state" : "unlike"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                if response != JSON.null{
                    
                    print("\(response["result"]["status"])")
                    if response["result"]["status"].boolValue == true{
                        self.like_count.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                        
                        //  DispatchQueue.main.async {
                        UIView.transition(with: sender as! UIView, duration: 0.8, options: .transitionCrossDissolve, animations: {
                            (sender as AnyObject).setImage(#imageLiteral(resourceName: "Unlike"), for: .normal)
                            
                            self.like_count.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                            
                        }, completion: nil)
                    }
                    else {
                        
                        
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil , preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertController(alert: alert)
                    }
                    
                }else{
                    
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                }
            }
        }else{
            let parameters : [String: Any] = [
                "post_id" : "\(self.albumDetail!.original_post_id!)",
                "front_user_id" : "\(NetworkController.front_user_id)",
                "type" : "post",
                "state" : "like"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                if response != JSON.null{
                    
                    print("\(response["result"]["status"])")
                    if response["result"]["status"].boolValue == true{
                        self.like_count.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                        print("\(response["result"]["like_count"].stringValue)")
                        //DispatchQueue.main.async {
                        UIView.transition(with: sender as! UIView, duration: 0.8, options: .transitionCrossDissolve, animations: {
                            (sender as AnyObject).setImage(#imageLiteral(resourceName: "like"), for: .normal)
                            
                            self.like_count.setTitle("\(response["result"]["like_count"].stringValue)", for: .normal)
                        }, completion: nil)
                        //}
                        //self.tableView.reloadRows(at: [indexPath] , with: .bottom)
                    }
                    else {
                        
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertController(alert: alert)
                    }
                    
                    
                }else{
                    
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                }
            }
        }
    }
    
    @objc func More(sender : UIButton){
        
        let actionSheet = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        //   actionSheet.addAction(UIAlertAction(title: "Add More", style: .default, handler: nil))
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            self.delegate?.AddPhoto()
        }))
        
        //  actionSheet.addAction(UIAlertAction(title: "Select Photo", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Delete Album", style: .destructive, handler:{ _ in
            let deleteAlert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                self.Delete_Album()
            }))
           deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.delegate?.AlertController(alert: deleteAlert)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       self.delegate?.AlertController(alert: actionSheet)
    }
   
    
}


// Mark:- API Calls
extension Header{
    
    func Edit_Title(title: String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(String(describing: self.albumDetail?.id!))",
            "album_title" : "\(title)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UpdateAlbumName){ resp,_ in
            
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    
                    self.albumDetail?.album_title = title
                    self.album_Title.text = title
                    let alert =  UIAlertController(title : "Successfully Updated" , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                    
                }else{
                    
                    let alert =  UIAlertController(title : "\(resp["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    //                    self.delegate?.AlertController(alert: alert)
                }
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                //                self.delegate?.AlertController(alert: alert)
            }
            
            
        }
    }
    
    func Edit_Caption(caption: String){
        
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(String(describing: (self.albumDetail?.id!)))",
            "feed_content" : "\(caption)",
            "type" : "post"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UpdatePostCaption){ resp,_ in
            
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    
                    print(resp["result"]["status"].boolValue)
                    self.albumDetail?.feed_content = caption
                    self.album_caption.text = caption
                    let alert =  UIAlertController(title :  "Successfully Updated", message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                    
                    
                }else{
                    
                    let alert =  UIAlertController(title :  "\(resp["result"]["description"].stringValue)", message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                }
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.delegate?.AlertController(alert: alert)
            }
            
            
        }
    }

    func Delete_Album(){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\((self.albumDetail?.id!)!)",
            "type" : "post"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost){
            response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    
                    let alert =  UIAlertController(title : "Successfully Deleted" , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : {_ in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                        tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                        tab_Crtl.modalPresentationStyle = .fullScreen
//                        self.present(tab_Crtl, animated: true, completion: nil)
                        self.delegate?.AlertController(alert: tab_Crtl)
//                        self.delegate?.DismissController(animated: true)
                    }))
                    self.delegate?.AlertController(alert: alert)
 
                    
                }else{
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                }
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil , preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.delegate?.AlertController(alert: alert)
            }
        }
    }

}

//Edit Options.....
/*
 
 let alertEdit = UIAlertController(title: "Choose to change", message: "Select Options", preferredStyle: .alert)
 
 alertEdit.addAction(UIAlertAction(title: "Edit Album Title", style: .default, handler: {_ in
 
 let alertText = UIAlertController(title: "Album Title", message: "Enter Text", preferredStyle: .alert)
 
 alertText.addAction(UIAlertAction(title: "Update", style: .default, handler: {alert -> Void in
 let txtFeild = alertText.textFields![0] as UITextField
 print(txtFeild.text!)
 self.Edit_Title(title: txtFeild.text!)
 
 
 }))
 
 alertText.addTextField(configurationHandler: {(txtFeild : UITextField) -> Void  in
 //txtFeild.placeholder = "Enter Title"
 txtFeild.text = self.albumDetail?.album_title!
 })
 
 alertText.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
 self.delegate?.AlertController(alert: alertText)
 
 }))
 alertEdit.addAction(UIAlertAction(title: "Edit Album Caption", style: .default, handler: {_ in
 let alertText = UIAlertController(title: "Album Caption", message: "Enter Text", preferredStyle: .alert)
 
 alertText.addAction(UIAlertAction(title: "Update", style: .default, handler: {alert -> Void in
 let txtFeild = alertText.textFields![0] as UITextField
 print(txtFeild.text!)
 self.Edit_Caption(caption: txtFeild.text!)
 
 
 }))
 
 alertText.addTextField(configurationHandler: {(txtFeild : UITextField) -> Void  in
 //txtFeild.placeholder = "Enter Title"
 txtFeild.text = self.albumDetail?.feed_content!
 })
 
 alertText.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
 self.delegate?.AlertController(alert: alertText)
 
 }))
 alertEdit.addAction(UIAlertAction(title: "Add Photo(s)", style: .default, handler: {_ in
 self.delegate?.AddPhoto()
 }))
 alertEdit.addAction(UIAlertAction(title: "Delete Photo(s)", style: .default, handler: {_ in
 self.delegate?.Delete(isSelected: true)
 
 }))
 alertEdit.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
 self.delegate?.AlertController(alert: alertEdit)
 
*/
