//
//  CommentsViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 15/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SwiftSoup
import SnapKit

protocol  CommentsCountDelegate {
    func UpdatedCount(count : Int, index : Int, comment: CommentsResponse?)
}

class CommentsViewController: UIViewController {

    ///Top Bar for notification Views...
    @IBOutlet weak var topCommentView : UIView!
    @IBOutlet weak var commentLabel : UILabel!
    @IBOutlet weak var goToPost : UIButton!
    ///
    @IBOutlet weak var sendButton: ButtonY!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var comentTextFeild: UITextField!
    @IBOutlet weak var no_comments: UILabel!
    @IBOutlet var loaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mentionTableView: UITableView!
    @IBOutlet weak var backBtn : UIBarButtonItem!
    @IBOutlet weak var moreComment : ButtonY!
    
    var commentIndex : Int!
    
    
    var filterResult : [SearchGuides] = []
    var isSearching : Bool = false
    var alreadyTaaged : [String] = []
    
    var comments : [CommentsResponse] = [CommentsResponse]()
    var front_user_id : String?
    var post_id : String?
    
    // Comment Count variables
    var delegate : CommentsCountDelegate?
    var index : Int!
    
    // Video Comment Variables
    var type : String!
    var video : VideoProfile!
    
    // Show Comments of Photo
    var photo  : Photo!
    // Show Comments for Postsss....
    var post : SocialPost!
    // Show comments for Albumsss...
    var album : ALbumDetail!
    
    //Notification
    var notification_flag : Bool = false
    var notificationLocalFlag : Bool = false
    var n_commentId : String = ""
    var n_photoId : String = ""
    var n_postId : String = ""
    var n_postUserName = ""
    var notification : NotificationResponse!
    
    var photo_id : String!
    var hashTagTitle : String!

    //EditComment Variables
    var currentComment : CommentsResponse!
    var currentIndex : Int!
    var isEdit : Bool = false
    
    //RepyVariables
    var replyIndex : Int = -1
    var isReply : Bool = false
    var replyComment : CommentsResponse!
    var selectedReplyBtn : [Int] = []
    var replyBtnIndex : [Int] = []
    
    var returnCount : Int!
    var g_total_Comments : Int = 0
    var g_comment_count : Int = 0
    var isLoadMore : Bool = false
    var isLoadDown : Bool = false
    
    //Back button Check
    var content_type : String = ""
    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
    
    
    var lastComment : CommentsResponse? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        mentionTableView.dataSource = self
        mentionTableView.delegate = self
        self.mentionTableView.isHidden = true
        self.filterResult = Guides.Users
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "comment")
        tableView.register(UINib(nibName: "ReplyCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "reply")
        
        self.moreComment.isHidden = true
        if notification_flag == true{
            
            if !notificationLocalFlag {
                self.topCommentView.snp.updateConstraints { (make) in
                    make.height.equalTo(40)
                    self.commentLabel.text = "Comments on \(self.n_postUserName)"
                }
                self.navigationItem.leftBarButtonItem = self.backBtn
            }else{
                self.topCommentView.snp.updateConstraints { (make) in
                    make.height.equalTo(40)
                    self.commentLabel.text = "Comments on \(self.n_postUserName)'s"
                }
                self.navigationItem.leftBarButtonItem = nil
            }

            if self.n_photoId != "0"{
                FetchComments(post_id: self.n_photoId, type: "photo", param: "",comment_id: self.n_commentId){total in
                    if total > 10{
                        self.moreComment.isHidden = false
                    }else{
                        self.moreComment.isHidden = true
                    }
                }
            }else{
                FetchComments(post_id: self.n_postId, type: "post", param: "",comment_id: self.n_commentId){total in
                    if total > 9{
                        self.moreComment.isHidden = false
                    }else{
                        self.moreComment.isHidden = true
                    }
                }
            }
        }else{
            self.topCommentView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
                self.goToPost.isHidden = true
                self.commentLabel.isHidden = true
            }
            if self.content_type == "photo"{
                self.navigationItem.leftBarButtonItem = backBtn
            }else{
                self.navigationItem.leftBarButtonItem = nil
            }
            
            self.moreComment.isHidden = true
            if photo != nil && photo.type == "photo"{
                FetchComments(post_id: photo.id!, type: "photo", param: "",comment_id: "0"){ total in
                }
            }else if post != nil{
                FetchComments(post_id: self.post.id!, type: "post", param: "",comment_id: "0"){ total in
                }
                
            }else if self.album != nil{
                FetchComments(post_id: self.album.id!, type: "post", param: "",comment_id: "0"){ total in
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.returnCount != nil && (self.index != nil){
            for i in self.comments{
                if i.view_type == "comment"{
                    lastComment = i
                }
            }
            self.delegate?.UpdatedCount(count: self.returnCount , index: self.index, comment: lastComment)
        }
    }
    
    @IBAction func Back_btn(_ sender: UIBarButtonItem) {
        
        if self.content_type == "photo"{
            for i in self.comments{
                if i.view_type == "comment"{
                    lastComment = i
                }
            }
            
            self.delegate?.UpdatedCount(count: self.returnCount , index: self.index, comment: lastComment)
            self.dismiss(animated: false)
        }else{
            if notification_flag{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                tab_Crtl.modalTransitionStyle = .crossDissolve
                self.present(tab_Crtl, animated: true, completion: nil)
            }else{
                
            }
            
        }
        
        
    }
    
    
    @IBAction func loadMore(_ sender : Any){
        if notification_flag == true{
            if self.n_photoId != "0"{
                self.tableView.tableFooterView = self.LazyLoader()
                self.tableView.tableFooterView?.isHidden = false
                LoadMoreToDown(post_id : self.n_photoId, type : "photo", comment_id : self.comments.last!.id!)
             
            }else{
                LoadMoreToDown(post_id : self.n_postId, type : "post", comment_id : self.comments.last!.id!)
            }
        }
    }
    
    @IBAction func send_Comment(_ sender: Any)  {
        if NetworkController.front_user_id != "0"{
            if notification_flag == true{
                if self.n_photoId != "0"{
                    if textView.text! != "Write Comment..." {
                        if !isEdit{
                            if isReply{
                                Send_Comment(post_id: self.n_photoId, type: "photo", reply_Comment_id : self.replyComment.id!)
                            }else{
                                Send_Comment(post_id: self.n_photoId, type: "photo", reply_Comment_id : "0")
                            }
                        }else{
                            Edit_Comment(post_id: self.n_photoId, type: "photo", edit_comment_id: self.currentComment.id!, reply_comment_id: currentComment.comment_id!)
                        }
                    }else{
                        let alert = UIAlertController(title: "Please! \n Add comment", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }else{
                    if textView.text! != "Write Comment..."{
                        
                        if !isEdit{
                            if isReply{
                                Send_Comment(post_id: self.n_postId, type: "post", reply_Comment_id : self.replyComment.id!)
                            }else{
                                Send_Comment(post_id: self.n_postId, type: "post", reply_Comment_id : "0")
                            }
                        }else{
                            
                            Edit_Comment(post_id: self.n_postId, type: "post", edit_comment_id: self.currentComment.id!, reply_comment_id: self.currentComment.comment_id!)
                        }
                    }else{
                        let alert = UIAlertController(title: "Please! \n Add comment", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }

            }else{
                if self.photo != nil{
                    if textView.text! != "Write Comment..." {
                        if !isEdit{
                            if isReply{
                                Send_Comment(post_id: self.photo.id!, type: self.photo.type!, reply_Comment_id : self.replyComment.id!)
                            }else{
                                Send_Comment(post_id: self.photo.id!, type: self.photo.type!, reply_Comment_id : "0")
                            }
                        }else{
                            Edit_Comment(post_id: self.photo.id!, type: self.photo.type!, edit_comment_id: self.currentComment.id!, reply_comment_id: currentComment.comment_id!)
                        }
                    }else{
                        let alert = UIAlertController(title: "Please! \n Add comment", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                }else if self.post != nil{
                    if textView.text! != "Write Comment..."{
                        
                        if !isEdit{
                            if isReply{
                                Send_Comment(post_id: self.post.id!, type: "post", reply_Comment_id : self.replyComment.id!)
                            }else{
                                Send_Comment(post_id: self.post.id!, type: "post", reply_Comment_id : "0")
                            }
                        }else{
                            
                            Edit_Comment(post_id: self.post.id!, type: "post", edit_comment_id: self.currentComment.id!, reply_comment_id: self.currentComment.comment_id!)
                        }
                        
                        
                    }else{
                        let alert = UIAlertController(title: "Please! \n Add comment", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }else if self.album != nil{
                    if textView.text! != "Write Comment..."{
                        
                        if !isEdit{
                            if isReply{
                                Send_Comment(post_id: self.album.id!, type: "post", reply_Comment_id : self.replyComment.id!)
                            }else{
                                Send_Comment(post_id: self.album.id!, type: "post", reply_Comment_id : "0")
                            }
                        }else{
                            
                            Edit_Comment(post_id: self.album.id!, type: "post", edit_comment_id: self.currentComment.id!, reply_comment_id: self.currentComment.comment_id!)
                        }
                        
                        
                    }else{
                        let alert = UIAlertController(title: "Please! \n Add comment", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hashtag"{
//            let nav = segue.destination as! UINavigationController
            let VC : HashTagViewController = segue.destination as! HashTagViewController
            VC.hashtagString = self.hashTagTitle
        }
    }
    
}


//MARK: TextView Delegates

extension CommentsViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        if text == "" && range.length > 0{
            if mentionTableView.isHidden == false{
                mentionTableView.isHidden = true
                tableView.isHidden = false
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
                    tableView.isHidden = true
                    no_comments.isHidden = true
                    newitem.removeFirst()
                    filterResult = newitem.isEmpty ? Guides.Users : Guides.Users.filter({(dataString: SearchGuides) -> Bool in
                        // If dataItem matches the searchText, return true to include it
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
        if NetworkController.front_user_id != "0"{
            if textView.text == "Write Comment..."{
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
            textView.text = "Write Comment..."
        }
        textView.resignFirstResponder()
    }
}

//MARK: Mentions and Comments tableviews datasource
extension CommentsViewController : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if tableView == self.tableView {
            if comments.count > 0 {
                
                self.no_comments.isHidden = true
                self.mentionTableView.isHidden = true
                self.tableView.isHidden = false
                returnValue =  comments.count
            }
            else{
                self.no_comments.isHidden = false
                self.mentionTableView.isHidden = true
                self.tableView.isHidden = true
                returnValue = 0
            }
        }else {
            returnValue =  self.filterResult.count
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == self.tableView && self.comments.count > 0{
            if self.comments[indexPath.row].view_type == "reply"{
                let replyCell = tableView.dequeueReusableCell(withIdentifier: "reply", for: indexPath) as! ReplyCommentTableViewCell
                replyCell.index = indexPath.row
                replyCell.ConfigureCell(data: self.comments[indexPath.row])
                replyCell.delegate = self
                if let _ = Int(self.comments[indexPath.row - 1].reply_count!), Int(self.comments[indexPath.row - 1].reply_count!)! > 1{
            
                    if  self.replyBtnIndex.contains(Int(self.comments[indexPath.row - 1].id!)!) {
                        replyCell.viewReplies_Btn.isHidden = true
                        replyCell.viewReplies_Btn.setTitle("", for: .normal)
                        replyCell.viewReplies_Btn.snp.updateConstraints { (make) in
                            make.height.equalTo(0)
                            make.top.equalTo(8)
                        }

                    }else{
                        replyCell.viewReplies_Btn.isHidden = false
                        replyCell.viewReplies_Btn.setTitle("View all replies", for: .normal)
                        replyCell.viewReplies_Btn.snp.updateConstraints { (make) in
                            make.height.equalTo(22)
                            make.top.equalTo(8)
                        }
                    }
                    
                }else{
                    replyCell.viewReplies_Btn.isHidden = true
                    replyCell.viewReplies_Btn.setTitle("", for: .normal)
                    replyCell.viewReplies_Btn.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                        make.top.equalTo(8)
                    }
                }
                return replyCell
            }else{
                let cell : CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell
                self.commentIndex = indexPath.row
                cell.ConfigureCell(data: self.comments[indexPath.row] , list: Guides.Users)
                cell.delegate = self
                cell.index = indexPath.row
                if indexPath.row == 0{
                    if self.g_comment_count < 10{
                        cell.view_Previous.isHidden = true
                        cell.view_Previous.snp.updateConstraints { (make) in
                            make.height.equalTo(0)
                            make.top.equalTo(8)
                        }
                    }else{
                        cell.view_Previous.isHidden = false
                        cell.view_Previous.snp.updateConstraints { (make) in
                            make.height.equalTo(26)
                            make.top.equalTo(0)
                        }
                        cell.view_Previous.addTarget(self, action: #selector(ViewMore(_:)), for: .touchUpInside)
                    }
                }else{
                    cell.view_Previous.isHidden = true
                    cell.view_Previous.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                        make.top.equalTo(8)
                    }
                }
                
                return cell
            }
        }else{
            
            let  cell1 = tableView.dequeueReusableCell(withIdentifier: "mentionCell", for: indexPath)
                let img : UIImageView = cell1.contentView.viewWithTag(1) as! UIImageView
                let res = ImageResource(downloadURL: URL(string: (self.filterResult[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.filterResult[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                
                img.kf.indicatorType = .activity
                img.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
                let lbl  : UILabel = cell1.contentView.viewWithTag(2) as! UILabel
                lbl.text = self.filterResult[indexPath.row].full_name!
            return cell1
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.mentionTableView{
            
                let stringValue = "\(self.filterResult[indexPath.row].front_user_name_slug!)"
                let arr = self.textView.text!.components(separatedBy: " ")
                
                var wordToReplace = ""
                for i in arr {
                    
                    let item =  i
                    if item.contains("@"){
                        wordToReplace = item
                    }
                }
                self.alreadyTaaged.append("@" + stringValue)
                self.textView.text = self.textView.text.replacingOccurrences(of: wordToReplace, with: "@" + stringValue + " ")
                self.mentionTableView.isHidden = true
                self.tableView.isHidden = false
                isSearching = false
                
           
        }
        
    }
   
}

//MARK: CommentCell Delegates
extension CommentsViewController : CommentTableViewCellDelegate{
    
    func UpdateCommentCount(yesNo status: String, changeAt index: Int) {
        self.comments[index].is_favorite = status
        tableView.reloadData()
    }
    
    // View More Btn....
    
    @objc func ViewMore(_ sender : UIButton){
        if !self.isLoadMore {
            if self.notification_flag{
                if self.n_photoId != "0"{
                    self.tableView.tableHeaderView = self.LazyLoader()
                    self.tableView.tableHeaderView?.isHidden = false
                    self.LoadMoreToTop(post_id: self.n_photoId , type: "photo", comment_id: self.comments.first!.id! )
                }else{
                    self.tableView.tableHeaderView = self.LazyLoader()
                    self.tableView.tableHeaderView?.isHidden = false
                    self.LoadMoreToTop(post_id: self.n_postId , type: "post", comment_id: self.comments.first!.id!)
                }
            }else{
                if photo != nil{
                    self.tableView.tableHeaderView = self.LazyLoader()
                    self.tableView.tableHeaderView?.isHidden = false
                    self.LoadMoreToTop(post_id: self.photo.id! , type: "photo", comment_id: self.comments.first!.id! )
                }else{
                    self.tableView.tableHeaderView = self.LazyLoader()
                    self.tableView.tableHeaderView?.isHidden = false
                    self.LoadMoreToTop(post_id: self.post.id! , type: "post", comment_id: self.comments.first!.id!)
                }
            }
            
        }
    }
    
    //Delegates...
    func ReplyToComment(comment : CommentsResponse , index : Int){
        self.isEdit = false
        self.isReply = true
        self.replyComment = comment
        self.replyIndex = index
        self.textView.becomeFirstResponder()
    }
    
    func EditCommentSegue(comment: CommentsResponse, index: Int) {
        self.isEdit = true
        self.currentComment = comment
        self.currentIndex = index
        self.textView.becomeFirstResponder()
        self.textView.text = ParseText(text: comment.comment!)
    }
    
    func performSegue(identifire : String, title : String) {
        if identifire == "showProfile"{
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }else if identifire == "hashtag"{
            self.hashTagTitle = title
            self.performSegue(withIdentifier: "hashtag", sender: self)
        }
    }
    
    func deletedRow(tag: Int , total_count : Int) {
        let tempInd = tag + 1
        for i in self.comments{
            if i.view_type == "reply" {
                if i.comment_id! == self.comments[tag].id!{
                    self.comments.remove(at: tempInd)
                }
            }
        }
        self.returnCount = total_count
        self.g_total_Comments = total_count
        self.comments.remove(at: tag)
        self.tableView.reloadData()
    }
    
    func AlertController(alert: UIViewController) {
         self.present(alert, animated: true, completion: nil)
    }
}

//MARK: ReplyComment Delegates
extension CommentsViewController : ReplyCommentTableViewCellDelegate{
    
    func UpdateReplyCount(yesNo status: String, changeAt index: Int) {
        self.comments[index].is_favorite = status
        tableView.reloadData()
    }
    
    func performSegueReply(identifire : String , title : String){
        if identifire == "showProfile"{
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }else if identifire == "hashtag"{
            
            self.hashTagTitle = title
            self.performSegue(withIdentifier: "hashtag", sender: self)
        }

    }

    func push(VC: UIViewController){
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func deletedRowReply(tag : Int, total_comment : Int){
    
        self.comments.remove(at: tag)
        tableView.reloadData()
        self.returnCount = total_comment
    }
    
    func AlertControllerReply(  alert : UIViewController){
        self.present(alert, animated: true, completion: nil)
    }
    
    func EditCommentSegueReply(comment : CommentsResponse, index : Int){
        self.isEdit = true
        self.currentComment = comment
        self.currentIndex = index
        self.textView.becomeFirstResponder()
        self.textView.text = ParseText(text: comment.comment!)
    }
    
    func ViewAllReply(index: Int){
        
        self.replyBtnIndex.append(Int(self.comments[index - 1].id!)!)
        self.replyIndex = index
        self.View_Replies(comment_id: self.comments[index - 1].id! , index : index)
    }
}

//MARK: Parsing Html for edit comment...!
extension CommentsViewController{
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
}

//MARK:API Calls

extension CommentsViewController{
    //MARK: Load MORE at top
    func LoadMoreToTop(post_id : String, type : String, comment_id : String){
        self.isLoadMore = true
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(post_id)",
            "type" : "\(type)",
            "param" : "less",
            "comment_id" : "\(comment_id)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .PostComments) {  response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let myResp = response["result"]["comments"]
                    self.g_comment_count = 0
                    for post in myResp{
                        let data = CommentsResponse(commentJSON: post.1)
                        self.comments.insert(data, at: 0)
                        if data.view_type! == "comment" {
                            self.g_comment_count = self.g_comment_count + 1
                        }
                        
                    }
                    self.tableView.tableHeaderView?.isHidden = true
                    self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 0)
                    self.tableView.reloadData()
                    self.isLoadMore = false
                }
                else{
                    self.loaderView.removeFromSuperview()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.loaderView.removeFromSuperview()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    //MARK: Load MORE at Down
    func LoadMoreToDown(post_id : String, type : String, comment_id : String){
        self.isLoadMore = true
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(post_id)",
            "type" : "\(type)",
            "param" : "more",
            "comment_id" : "\(comment_id)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .PostComments) {  response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let myResp = response["result"]["comments"]
                    for post in myResp{
                        let data = CommentsResponse(commentJSON: post.1)
                        self.comments.append(data)
                        if data.view_type! == "comment" {
                            self.g_comment_count = self.g_comment_count + 1
                        }
                    }
                    if myResp.count > 0{
                        self.tableView.tableFooterView?.isHidden = true
                        self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 0)
                        self.tableView.reloadData()
                    }else{
                        self.moreComment.isHidden = true
                        self.tableView.tableFooterView?.isHidden = true
                        self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 0)
                        self.tableView.reloadData()
                    }

                    
                }
                else{
                    self.loaderView.removeFromSuperview()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.loaderView.removeFromSuperview()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    
    //MARK: fetch posted comments.....
    func FetchComments( post_id : String, type: String , param : String ,comment_id : String , Handler : @escaping (Int) -> ()){
        
        self.addActivityLoader()
//        self.navigation
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(post_id)",
            "type" : "\(type)",
            "param" : param,
            "comment_id" : "\(comment_id)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .PostComments){ response, _  in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let myResp = response["result"]["comments"]
                    self.g_total_Comments = response["result"]["comment_count"].intValue
                    for post in myResp{
                        let data = CommentsResponse(commentJSON: post.1)
                        self.comments.append(data)
                        if data.view_type == "comment"{
                            self.g_comment_count = self.g_comment_count + 1
                        }
                    }
                    Handler(self.g_total_Comments)
                    self.returnCount = response["result"]["feed_comments"].int!
                    if self.comments.count > 0{
                        let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
    
    //MARK: SendComment reply etc...
    func Send_Comment(post_id : String , type : String, reply_Comment_id : String ){

        self.alreadyTaaged.removeAll()
        let parameters : [String: Any] = [
            "post_id" : "\(post_id)",
            "front_user_id" : "\(NetworkController.front_user_id)",
            "type" : "\(type)",
            "comment" : "\(self.textView.text!)",
            "edit_comment_id" : "0",
            "reply_comment_id" : "\(reply_Comment_id)",
        ]
        self.sendButton.isEnabled = false
       NetworkController.shared.Service(parameters: parameters, nameOfService: .SendComment){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    
                    let resp = response["result"]["new_comment"]
                    if reply_Comment_id == "0"{
                        for comment in resp{
                            let data = CommentsResponse(commentJSON: comment.1)
                            self.comments.append(data)
                        }
//                        self.tableView.beginUpdates()
//                        self.tableView.insertRows(at: [IndexPath(row: self.comments.count - 1, section: 0)], with: .automatic)
//                        let indexPath = IndexPath(row: self.comments.count, section: 0)
//                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                        self.tableView.endUpdates()
                        self.textView.text = "Write Comment..."
                        self.textView.resignFirstResponder()
                        self.tableView.reloadData()
                        
                    }else{
                        for comment in resp{
                            let data = CommentsResponse(commentJSON: comment.1)
                            self.comments.insert(data, at: self.replyIndex + 1)
                        }
                        self.textView.text = "Write Comment..."
                        self.isReply = false
                        self.textView.resignFirstResponder()
                        self.tableView.reloadData()
                        
                    }
                    self.returnCount = response["result"]["total_comments"].int!
                    self.sendButton.isEnabled = true
                }else{
                    self.sendButton.isEnabled = true
                    self.loaderView.removeFromSuperview()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.sendButton.isEnabled = true
                self.loaderView.removeFromSuperview()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }

    //MARK: Edit Comment.....
    func Edit_Comment( post_id : String , type : String, edit_comment_id : String, reply_comment_id : String ){
        self.alreadyTaaged.removeAll()
        let parameters : [String: Any] = [
            "post_id" : "\(post_id)",
            "front_user_id" : "\(NetworkController.front_user_id)",
            "type" : "\(type)",
            "comment" : "\(self.textView.text!)",
            "edit_comment_id" : "\(edit_comment_id)",
            "reply_comment_id" : "\(reply_comment_id)",
        ]
        self.sendButton.isEnabled = false
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SendComment){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["new_comment"]
                    for comment in resp{
                        let data = CommentsResponse(commentJSON: comment.1)
                        self.comments[self.currentIndex] = data
                    }
                    self.isEdit = false
                    self.tableView.reloadData()
                    self.textView.text = "Write Comment..."
                    self.textView.resignFirstResponder()
                    self.sendButton.isEnabled = true
                }else{
                    self.sendButton.isEnabled = true
                    self.loaderView.removeFromSuperview()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.sendButton.isEnabled = true
                self.loaderView.removeFromSuperview()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }

    //MARK: Notification Comments
    func Notification_Comment(post_id : String , type : String, comment_id : String){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "last_id" : "",
            "post_id" : "\(post_id)",
            "type" : "\(type)",
            "comment_id" : "\(comment_id)",
        ]
        self.sendButton.isEnabled = false
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SendComment){ response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let myResp = response["result"]["comments"]
                    for post in myResp{
                        let data = CommentsResponse(commentJSON: post.1)
                        self.comments.append(data)
                    }
                    self.tableView.reloadData()
                    self.removeActivityLoader()
                    self.sendButton.isEnabled = true
                }else{
                    self.sendButton.isEnabled = true
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.sendButton.isEnabled = true
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    //MARK: View All Replies
    func View_Replies(comment_id : String!, index : Int){
        let indPath = IndexPath(row: index, section: 0)
        let cell = self.tableView.cellForRow(at: indPath) as! ReplyCommentTableViewCell
        cell.viewReplies_Btn.isEnabled = false
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "comment_id" : "\(comment_id!)",
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .MoreReply){ response,_ in
              if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        let myResp = response["result"]["comments"]
                        for post in myResp
                        {
                            let data = CommentsResponse(commentJSON: post.1)
                            self.comments.insert(data, at: self.replyIndex)
                          
                        }
                        cell.viewReplies_Btn.isEnabled = false
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


///When Comes from Notifications either its push or inapp....
//MARK: For Top Bar to move on post
extension CommentsViewController{
    
    @IBAction func postButton(_ sender : UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "postNotification") as! NotificationPostsViewController
        
        if self.n_photoId != "0"{
            vc.postId = self.n_photoId
        }else{
            vc.postId = self.n_postId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
