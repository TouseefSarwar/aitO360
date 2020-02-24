//
//  CommentTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 23/05/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import ActiveLabel
import SwiftSoup
import SwiftyJSON
import Kingfisher

protocol CommentTableViewCellDelegate : class{
    func UpdateCommentCount(yesNo status :  String, changeAt index : Int)
    func performSegue(identifire : String , title : String)
    func deletedRow(tag : Int, total_count : Int)
    func AlertController(  alert : UIViewController)
    func EditCommentSegue(comment : CommentsResponse, index : Int)
    func ReplyToComment(comment : CommentsResponse , index : Int)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImg: ImageViewX!
    @IBOutlet weak var comment_label: ActiveLabel! // NOT Using now...
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var more_btn: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var reply_btn: UIButton!
    @IBOutlet weak var view_Previous: UIButton!
    
    var comment : CommentsResponse!
    weak var delegate : CommentTableViewCellDelegate! = nil
    var index : Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        txtView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func ConfigureCell(data : CommentsResponse , list : [SearchGuides]){
        self.comment = data
        if self.comment.front_user_id! != NetworkController.front_user_id{
            self.more_btn.isHidden = true
        }else{
            self.more_btn.isHidden = false
        }
        
        let resource = ImageResource(downloadURL: URL(string:
            (self.comment.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.comment.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        self.profileImg.kf.indicatorType = .activity
        self.profileImg.kf.setImage(with: resource ,placeholder: #imageLiteral(resourceName: "placeholderImage"))
        //Tap Guesture to go on the profile....
        let tapProfileImg = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
        self.profileImg.isUserInteractionEnabled = true
        self.profileImg.addGestureRecognizer(tapProfileImg)
        self.txtView.text = self.comment.comment!
        self.name.text = "\(self.comment.first_name!) \(self.comment.last_name!)"
        let tapName = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
        self.name.isUserInteractionEnabled = true
        self.name.addGestureRecognizer(tapName)
        
        self.time.text = NetworkController.shared.dateConverter(dateString:  self.comment.created!)
        self.swiftsoup(text: self.txtView.text!)
      
        if self.comment.is_favorite! == "yes"{
            self.like.setImage(UIImage(named: "comment_like"), for: .normal)
        }else{
            self.like.setImage(UIImage(named: "comment_unlike"), for: .normal)
        }
        self.like.addTarget(self, action: #selector(self.Like_Comment(sender:)), for: .touchUpInside)
        self.more_btn.addTarget(self, action: #selector(self.MoreBtn(sender:)), for: .touchUpInside)
        self.reply_btn.addTarget(self, action: #selector(self.ReplyComment(_:)), for: .touchUpInside)
    }
    
}


extension CommentTableViewCell{
    
    @objc func ReplyComment(_ sender : UIButton){
        self.delegate.ReplyToComment(comment: self.comment , index: self.index)
    }
    
    @objc func TappedUser(sender : UITapGestureRecognizer){
        NetworkController.others_front_user_id = self.comment.front_user_id!
        self.delegate.performSegue(identifire: "showProfile", title: "")
    }
    
    @objc func MoreBtn(sender : UIButton){
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler:{ alert -> (Void) in
            self.delegate.EditCommentSegue(comment: self.comment, index: self.index)
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
//            self.delegate?.deletedRow(tag: self.index)
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "post_id" : "\(self.comment.id!)",
                "type" : "comment"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost) {  response,_ in

                if response != JSON.null{
                    if response["result"]["status"].boolValue == true{
                        let alert =  UIAlertController(title : "Successfully Deleted" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertController(alert: alert)
                        self.delegate?.deletedRow(tag: self.index, total_count: response["result"]["comment_count"].int!)
                        
                    }else{
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.AlertController(alert: alert)
                    }
                }else{
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.AlertController(alert: alert)
                }
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.delegate?.AlertController(alert: actionSheet)

    }
    
    @objc func Like_Comment(sender : UIButton){
        
        if NetworkController.front_user_id != "0"{
            if (sender.currentImage?.isEqual(UIImage(named: "comment_like")))!{
                UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    sender.setImage(UIImage(named: "comment_unlike"), for: .normal)
                }, completion: nil)
                
                let parameters : [String: Any] = [
                    "post_id" : "\(self.comment.id!)",
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : "comment",
                    "state" : "unlike"
                ]
                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost) {  response,_ in
                    if response != JSON.null{
                        if response["result"]["status"].boolValue == true{
                            self.delegate.UpdateCommentCount(yesNo: "no", changeAt: self.index)
                        }
                        else {
                            
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        }
                    }else{
                        
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    }
                }
            }
            else{
                UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    sender.setImage(UIImage(named: "comment_like"), for: .normal)
                }, completion: nil)
                
                let parameters : [String: Any] = [
                    "post_id" : "\(self.comment.id!)",
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : "comment",
                    "state" : "like"
                ]
                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost) {  response,_ in
                    if response != JSON.null{
                        if response["result"]["status"].boolValue == true{
                            self.delegate.UpdateCommentCount(yesNo: "yes", changeAt: self.index)
                        }
                        else {
                            
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                            
                        }
                    }else{
                        
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        //                    self.delegate?.AlertController(alert: alert)
                    }
                }
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.delegate?.AlertController(alert: vc)
        }

        
    }
}

extension CommentTableViewCell : UITextViewDelegate  {
    
    func mentionTapped( textView : UITextView, mentionText : [String], regularText : String, id : [String]){
        
        let regularText = NSMutableAttributedString(string: regularText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13 , weight: .thin ), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)])
        
        
        var locArr : [NSRange] = []
        for i in 0..<id.count {
            
            let tappableText = NSMutableAttributedString(string: mentionText[i])
            
            let val = "Mention,\(id[i])"
            if tappableText.string.first! == "#"{
                
                tappableText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13, weight: .semibold), range: NSMakeRange(0, tappableText.length))
                let arr = tappableText.string.components(separatedBy: "#")
                tappableText.addAttribute(NSAttributedString.Key.link, value: "Hashtag,\(arr.last!)", range: NSMakeRange(0, tappableText.length))
            }else{
                
                tappableText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13, weight: .semibold), range: NSMakeRange(0, tappableText.length))
                tappableText.addAttribute(NSAttributedString.Key.link, value: val, range: NSMakeRange(0, tappableText.length))
                
            }
            let tp = tappableText.string
            let loc = regularText.mutableString.range(of: tp)
            if !locArr.contains(loc){
                locArr.append(loc)
                regularText.replaceCharacters(in: loc, with: tappableText)
            }
        }
        
        txtView.attributedText = regularText
    }
    
    func swiftsoup( text : String){
        do{
            let html: String = txtView.text!
            let doc : Document = try! SwiftSoup.parse(html)
            let link : [Element] = try! doc.select("a").array()
            let text: String = try! doc.body()!.text(); // "An example link"
            var mentions : [String] = []
            var ids : [String] = []
            for lk in link{
                let linkHref: String = try! lk.attr("data-userid"); // "http://example.com/
                let linkText: String = try! lk.text(); // "example""
                
                //                if linkHref == "#"{
                //
                //                    hashTags.append(linkText)
                //                    print(text)
                //                    print(linkText)
                //                }else{
                ids.append(linkHref)
                mentions.append(linkText)
                //                }
                
            }
            
            //            self.hashTag(regularText: text, hashTag: hashTags)
            self.mentionTapped(textView: txtView, mentionText: mentions, regularText : text , id: ids)
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
            delegate.performSegue(identifire: "showProfile", title: "")
            return false // return false for this to work
        }else if arr.first! == "Hashtag"{
            delegate.performSegue(identifire: "hashtag", title: arr.last!)
            return false
        }
        return true
        
    }
    
}
