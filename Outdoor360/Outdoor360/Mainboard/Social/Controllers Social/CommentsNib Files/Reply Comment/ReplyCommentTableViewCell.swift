//
//  ReplyCommentTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 18/12/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftSoup
import SwiftyJSON

protocol ReplyCommentTableViewCellDelegate : class{
    func UpdateReplyCount(yesNo status : String, changeAt index : Int)
    func performSegueReply(identifire : String , title : String)
    func deletedRowReply(tag : Int, total_comment : Int)
    func AlertControllerReply(  alert : UIViewController)
    func EditCommentSegueReply(comment : CommentsResponse, index : Int)
    func ViewAllReply(index : Int)
    func push(VC: UIViewController)
}


class ReplyCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var pro_image: ImageViewX!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var reply_comment: UITextView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var viewReplies_Btn: UIButton!
    @IBOutlet weak var like: UIButton!

    // Variabels...
    var reply : CommentsResponse!
    var index : Int!
    var count : Int!
    
    weak var delegate : ReplyCommentTableViewCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func ConfigureCell(data : CommentsResponse ){
        self.reply = data
//        if let _ = self.count, self.count > 1{
//            self.viewReplies_Btn.isHidden = false
//        }else{
//            self.viewReplies_Btn.isHidden = true
//        }
        
        if self.reply.front_user_id! != NetworkController.front_user_id{
            self.moreBtn.isHidden = true
        }else{
            self.moreBtn.isHidden = false
        }
        let resource = ImageResource(downloadURL: URL(string:
            (self.reply.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.reply.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        self.pro_image.kf.indicatorType = .activity
        self.pro_image.kf.setImage(with: resource ,placeholder: #imageLiteral(resourceName: "placeholderImage"))
        //Tap Guesture to go on the profile....
        let tapProfileImg = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
        self.pro_image.isUserInteractionEnabled = true
        self.pro_image.addGestureRecognizer(tapProfileImg)
        self.reply_comment.text = self.reply.comment!
        self.user_name.text = "\(self.reply.first_name!) \(self.reply.last_name!)"
        let tapName = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
        self.user_name.isUserInteractionEnabled = true
        self.user_name.addGestureRecognizer(tapName)
        
        self.time.text = NetworkController.shared.dateConverter(dateString:  self.reply.created!)
        self.swiftsoup(text: self.reply_comment.text!)
        
        self.viewReplies_Btn.addTarget(self, action: #selector(self.View_Reply(_:)), for: .touchUpInside)
        
        
        if self.reply.is_favorite! == "yes"{
            self.like.setImage(UIImage(named: "comment_like"), for: .normal)
        }else{
            self.like.setImage(UIImage(named: "comment_unlike"), for: .normal)
        }
        self.like.addTarget(self, action: #selector(self.Like_Comment(sender:)), for: .touchUpInside)
        self.moreBtn.addTarget(self, action: #selector(self.MoreBtn(sender:)), for: .touchUpInside)
    }
    
}

extension ReplyCommentTableViewCell{
    
    //View All Replies
    @objc func View_Reply(_ sender : UIButton){
        if let ind = self.index{
            self.delegate.ViewAllReply(index: ind)
        }
//        self.viewReplies_Btn.isHidden = true
    }
    
    // User name and image to profile
    @objc func TappedUser(sender : UITapGestureRecognizer){
        NetworkController.others_front_user_id = self.reply.front_user_id!
        self.delegate.performSegueReply(identifire: "showProfile", title: "")
    }
    
    // More Button
    @objc func MoreBtn(sender : UIButton){
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler:{ alert -> (Void) in
            self.delegate.EditCommentSegueReply(comment: self.reply, index: self.index)
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "post_id" : "\(self.reply.id!)",
                "type" : "comment"
            ]
            
            NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost) { (response,status) in
                //                print(response)
                if response != JSON.null{
                    if response["result"]["status"].boolValue == true{
                        let alert =  UIAlertController(title : "Successfully Deleted" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertControllerReply(alert: alert)
                        self.delegate?.deletedRowReply(tag: self.index , total_comment : response["result"]["comment_count"].int!)
                        
                    }else{
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertControllerReply(alert: alert)
                    }
                }else{
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertControllerReply(alert: alert)
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.delegate?.AlertControllerReply(alert: actionSheet)
        
    }
    
    //Like Button
    @objc func Like_Comment(sender : UIButton){
        
        
        if NetworkController.front_user_id != "0"{
            if (sender.currentImage?.isEqual(UIImage(named: "comment_like")))!{
                UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    sender.setImage(UIImage(named: "comment_unlike"), for: .normal)
                }, completion: nil)
                
                let parameters : [String: Any] = [
                    "post_id" : "\(self.reply.id!)",
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : "comment",
                    "state" : "unlike"
                ]
                
                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost) { (response,status) in
                    if response != JSON.null{
                        
                        if response["result"]["status"].boolValue == true{
                            self.delegate.UpdateReplyCount(yesNo: "no", changeAt: self.index)
                        }
                        else {
                            
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        }
                    }else{
                        
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message :  nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    }
                }
            }
            else{
                UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    sender.setImage(UIImage(named: "comment_like"), for: .normal)
                }, completion: nil)
                
                let parameters : [String: Any] = [
                    "post_id" : "\(self.reply.id!)",
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : "comment",
                    "state" : "like"
                ]
                
                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost) { (response,status) in
                    if response != JSON.null{
                        
                        if response["result"]["status"].boolValue == true{
                            self.delegate.UpdateReplyCount(yesNo: "yes", changeAt: self.index)
                        }
                        else {
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil , preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        }
                        
                        
                    }else{
                        
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    }
                }
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.delegate?.AlertControllerReply(alert: vc)
        }
        
        
        
    }
    
}

extension ReplyCommentTableViewCell : UITextViewDelegate  {
    
    func mentionTapped( textView : UITextView, mentionText : [String], regularText : String, id : [String]){
        
        let regularText = NSMutableAttributedString(string: regularText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12 , weight: .regular), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)])
        
        
        var locArr : [NSRange] = []
        for i in 0..<id.count {
            
            let tappableText = NSMutableAttributedString(string: mentionText[i])
            
            let val = "Mention,\(id[i])"
            if tappableText.string.first! == "#"{
                
                tappableText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .semibold), range: NSMakeRange(0, tappableText.length))
                let arr = tappableText.string.components(separatedBy: "#")
                print(arr.last!)
                tappableText.addAttribute(NSAttributedString.Key.link, value: "Hashtag,\(arr.last!)", range: NSMakeRange(0, tappableText.length))
            }else{
                
                tappableText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .semibold), range: NSMakeRange(0, tappableText.length))
                tappableText.addAttribute(NSAttributedString.Key.link, value: val, range: NSMakeRange(0, tappableText.length))
                
            }
            
            let tp = tappableText.string
            let loc = regularText.mutableString.range(of: tp)
            if !locArr.contains(loc){
                locArr.append(loc)
                regularText.replaceCharacters(in: loc, with: tappableText)
            }
        }
        
        self.reply_comment.attributedText = regularText
    }
    
    func swiftsoup( text : String){
        do{
            let html: String = self.reply_comment.text!
            let doc : Document = try! SwiftSoup.parse(html)
            let link : [Element] = try! doc.select("a").array()
            let text: String = try! doc.body()!.text(); // "An example link"
            var mentions : [String] = []
            var ids : [String] = []
            for lk in link{
                let linkHref: String = try! lk.attr("data-userid"); // "http://example.com/
                let linkText: String = try! lk.text(); // "example""
                ids.append(linkHref)
                mentions.append(linkText)
            }
            
            self.mentionTapped(textView: reply_comment, mentionText: mentions, regularText : text , id: ids)
        }catch Exception.Error(let type, let message){
            print("\(message) \n \(type)")
        }catch{
            print("error")
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        let arr = URL.absoluteString.components(separatedBy: ",")
        if arr.first! == "Mention"{
            NetworkController.others_front_user_id = arr.last!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
            self.delegate?.push(VC: vc)
            return false // return false for this to work
        }else if arr.first! == "Hashtag"{
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "hashTag") as! HashTagViewController
            vc.hashtagString = arr.last!
            self.delegate.push(VC: vc)
            return false
        }
        return true
        
    }
}
