//
//  AnimatedComment_VC.swift
//  Outdoor360
//
//  Created by Apple on 18/11/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import SwiftyJSON
import SwiftSoup

protocol AnimatedCommentDelegate : class{
    func UpdateComment(comment : CommentsResponse? , count : Int?)
}
class AnimatedComment_VC: UIViewController {

    
    @IBOutlet weak var animateView : UIView!
    @IBOutlet weak var userName : UILabel!
    @IBOutlet weak var userImage : ImageViewX!
    @IBOutlet weak var writeText : UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    @IBOutlet weak var mentionTableView: UITableView!
    
    var filterResult : [SearchGuides] = []
    var isSearching : Bool = false
    var alreadyTaaged : [String] = []
    
    var post : SocialPost?
    weak var delegate : AnimatedCommentDelegate! = nil
    var isUp : Bool = false
    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        writeText.becomeFirstResponder()
        writeText.delegate = self
        self.mentionTableView.isHidden = true
        self.filterResult = Guides.Users
        if self.post != nil{
            let resource1 = ImageResource(downloadURL: URL(string: (self.post?.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.post?.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            self.userImage.kf.indicatorType = .activity
            self.userImage.kf.setImage(with: resource1, placeholder: #imageLiteral(resourceName: "placeholderImage"))
            self.userName.text = (self.post?.first_name!)! + " " + (self.post?.last_name!)!
        }
        if dic != nil{
            if dic!["user_image"] != nil{
                let res = ImageResource(downloadURL: URL(string: (NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                self.userImage.kf.indicatorType = .activity
                self.userImage.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
            }
            if dic!["user_name"] != nil{
                self.userName.text = dic!["user_name"] as? String
            }
            
        }
        
        
        
    }

    @IBAction func close(_ sender : UIButton){
        writeText.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func send_Comment(_ sender: Any)  {
        if NetworkController.front_user_id != "0"{
            if self.post != nil{
                
                if writeText.text! != "Write your comment..." && writeText.text! != ""{
                    Send_Comment(post_id: self.post!.id!, type: "post", reply_Comment_id : "0")
                }else{
                    let alert = UIAlertController(title: "Please! \n Add comment", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
        }
    }
    
}

//MEntion TableView
extension AnimatedComment_VC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        returnValue =  self.filterResult.count
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell1 = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath)
        
            let img : UIImageView = cell1.contentView.viewWithTag(1) as! UIImageView
            let res = ImageResource(downloadURL: URL(string: (self.filterResult[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.filterResult[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            img.kf.indicatorType = .activity
            img.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
            let lbl  : UILabel = cell1.contentView.viewWithTag(2) as! UILabel
            lbl.text = self.filterResult[indexPath.row].full_name!
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let stringValue = "\(self.filterResult[indexPath.row].front_user_name_slug!)"
            let arr = self.writeText.text!.components(separatedBy: " ")
            
            var wordToReplace = ""
            for i in arr {
                let item =  i
                if item.contains("@"){
                    wordToReplace = item
                }
            }
            self.alreadyTaaged.append("@" + stringValue)
            self.writeText.text = self.writeText.text.replacingOccurrences(of: wordToReplace, with: "@" + stringValue + " ")
            self.mentionTableView.isHidden = true
    }
    
}

//textView Delegates

extension AnimatedComment_VC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "" && range.length > 0{
            if mentionTableView.isHidden == false{
                mentionTableView.isHidden = true
            }
        }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        let arr = changedText.components(separatedBy: " ")
        for item in arr {
            
            var newitem = item
            if newitem.first == "@"{
                if self.alreadyTaaged.contains(item){
                }else{
                    newitem.removeFirst()
                    filterResult = newitem.isEmpty ? Guides.Users : Guides.Users.filter({(dataString: SearchGuides) -> Bool in
                        // If dataItem matches the searchText, return true to include it
//                        return dataString.full_name!.range(of: newitem, options: .caseInsensitive) != nil
                        return dataString.front_user_name_slug!.range(of: newitem, options: .caseInsensitive) != nil
                    })
                    self.mentionTableView.isHidden = false
                    self.mentionTableView.reloadData()
                    return true
                }
            }
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if NetworkController.front_user_id != "0" {
            
            if textView.text == "Write your comment..."{
                textView.text = ""
            }
            textView.becomeFirstResponder()
        }else{
            textView.resignFirstResponder()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Write your comment..."
        }
        textView.resignFirstResponder()
    }
}


// MARK: Parsing Html for edit comment...! and Api Call

extension AnimatedComment_VC{
    ///Comment Parsing
    func ParseText(text : String) -> String{
        var finalString : String = ""
        do {
            let html: String = text
            let doc : Document = try! SwiftSoup.parse(html)
            let link : [Element] = try! doc.select("a").array()
            let bodytext: String = try! doc.body()!.text(); // "An example link"
            finalString = bodytext
            for lk in link{
                let slug : String = try! lk.attr("href");
                let arr = slug.split(separator: "/")
                let linkText: String = try! lk.text() // "example""
                self.alreadyTaaged.append("@" + arr.last!)
                finalString = finalString.replacingOccurrences(of: linkText, with: "@" + arr.last! + " ")
                
            }
        }catch Exception.Error(let type, let message){
            print("\(message) \n \(type)")
        }catch{
            print("error")
        }
        
        return finalString
    }
    
    
    //SendComment  etc...
    func Send_Comment(post_id : String , type : String, reply_Comment_id : String ){
        self.addActivityLoader()
        self.alreadyTaaged.removeAll()
        let parameters : [String: Any] = [
            "post_id" : "\(post_id)",
            "front_user_id" : "\(NetworkController.front_user_id)",
            "type" : "\(type)",
            "comment" : "\(self.writeText.text!)",
            "edit_comment_id" : "0",
            "reply_comment_id" : "\(reply_Comment_id)",
        ]

        self.sendBtn.isEnabled = false
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SendComment){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["new_comment"]
                    print(resp)
                    var data : CommentsResponse?
                    for comment in resp{
                        data = CommentsResponse(commentJSON: comment.1)
                    }
                    let returnCount = response["result"]["total_comments"].int!
                    
                    self.writeText.text = "Write Comment..."
                    self.writeText.resignFirstResponder()
                    self.removeActivityLoader()
                    self.dismiss(animated: true){
                        self.delegate?.UpdateComment(comment: data, count: returnCount)
                    }
                }else{
                    self.sendBtn.isEnabled = true
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.sendBtn.isEnabled = true
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
}
