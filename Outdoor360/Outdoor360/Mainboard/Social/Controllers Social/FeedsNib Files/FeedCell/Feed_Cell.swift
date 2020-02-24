//
//  Feed_Cell.swift
//  SnapKitTest
//
//  Created by Apple on 17/12/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher
import SwiftyJSON
import SafariServices
import ActiveLabel
import SwiftSoup

struct CountUpdate{
    var type : String!
    var index : Int!
    var count : Int!
    var favID : Int?
    var comment : CommentsResponse?
}

protocol Feed_CellDelegate : class {
    func delete(index : Int)
    func share(post : SocialPost)
    func push(VC : UIViewController)
    func present(VC : UIViewController)
    func update(count : CountUpdate)
}

class Feed_Cell: UITableViewCell {
    
    static var identifier = "Feed_Cell"
    
    //variables...
    var post : SocialPost!
    var index : Int!
    weak var delegate : Feed_CellDelegate?
    
    
    //Top Section
    @IBOutlet weak var topView : UIView!
    
    @IBOutlet weak var proImage : UIImageView!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var time : UILabel!
    @IBOutlet weak var moreBtn : UIButton!
    
    @IBOutlet weak var albumName : UILabel!
    @IBOutlet weak var sharedCaption : ActiveLabel!
    
    ///Middle Section
    
    //single
    @IBOutlet weak var singleImage : UIImageView!
    @IBOutlet weak var popLikeHeart : UIImageView!
    var doubleGestureRecognizer : UITapGestureRecognizer!
    
    //multiple
    @IBOutlet weak var collectionView : UICollectionView!
    var imagesToShow : [Photo] = []
    
    //video
    @IBOutlet weak var videoView : AGVideoPlayerView!
    //URL
    @IBOutlet weak var urlView : UIView! //remaining should be under neath...
    @IBOutlet weak var urlTitle: UILabel!
    @IBOutlet weak var urlLink: UILabel!
    @IBOutlet weak var urlDesc: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var clickUrlButton : UIButton!

    //Link
    @IBOutlet weak var linkView : UIView! //remaining should be under neath...
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var linkTitle : UILabel!
    @IBOutlet weak var clickLinkButton : UIButton!
    
    
    ///Lower Section
    
    @IBOutlet weak var likeBtn : UIButton!
    @IBOutlet weak var likeCount : UILabel!
    @IBOutlet weak var commentBtn : UIButton!
    @IBOutlet weak var commentCount : UILabel!
    @IBOutlet weak var tagBtn : UIButton!
    @IBOutlet weak var tagCount : UILabel!
    @IBOutlet weak var shareBtn : UIButton!
    
    
    ///Last Section...
    @IBOutlet weak var viewLikesBtn : UIButton!
    @IBOutlet weak var caption : ActiveLabel!
    
    @IBOutlet weak var viewCommentBtn : UIButton!
    @IBOutlet weak var commentLike : UIButton!
    @IBOutlet weak var commentView : UIView!
    @IBOutlet weak var commentLabel : UILabel!
    
    @IBOutlet weak var shadowView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(cellData : SocialPost, index : Int){
        self.post = cellData
        self.index = index
        
        ///Top Section
        ///Adding Tap
        if self.post.is_shared == "yes"{
            self.name.text = "\(self.post.first_name!) \(self.post.last_name!) shared \(self.post.shared_first_name!)'s post"
            
        }else{
            self.name.text = "\(self.post.first_name!) \(self.post.last_name!)"
        }
        
        self.name.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.name.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.name.changeFont(ofText: "\(self.post.first_name!) \(self.post.last_name!)", with: UIFont.systemFont(ofSize: 14, weight: .bold))
        self.name.changeFont(ofText: "\(self.post.shared_first_name!)'s", with: UIFont.systemFont(ofSize: 14, weight: .bold))
        
        self.name.changeTextColor(ofText: "\(self.post.first_name!) \(self.post.last_name!)", with: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        self.name.changeTextColor(ofText: "\(self.post.shared_first_name!)'s", with: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tabNameLabel(_:)))
        self.name.isUserInteractionEnabled = true
        self.name.addGestureRecognizer(tap)
        
        // Ending Tap
        
        
        //More button
        if NetworkController.front_user_id == "0"{
            self.moreBtn.isHidden = true
        }else{
            self.moreBtn.isHidden = false
        }
        
        self.time.text = NetworkController.shared.dateConverter(dateString:  self.post.created!)
        if let pImg = self.post.user_image{
            let resource = ImageResource(downloadURL: URL(string: (pImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))!, cacheKey: pImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            self.proImage.kf.indicatorType = .activity
            self.proImage.kf.setImage(with: resource , placeholder : #imageLiteral(resourceName: "placeholderImage"))
        }
        
        
        let tapProfileImg = UITapGestureRecognizer(target: self, action: #selector(tapGoToProfile(_:)))
        self.proImage.isUserInteractionEnabled = true
        self.proImage.addGestureRecognizer(tapProfileImg)
        
        //shared
        if (self.post.is_shared == "yes") && (self.post.share_caption != nil || self.post.share_caption! != ""){
            self.sharedUpated(ishide: false)
        }else{
            self.sharedUpated(ishide: true)
        }
        self.sharedCaption.text = self.post.share_caption ?? ""
        // Share label HashTag Handling
        self.sharedCaption.handleHashtagTap{  [weak self]  text in

            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "hashTag") as! HashTagViewController
            vc.hashtagString = text
            self!.delegate!.push(VC : vc)
        }
        // Share label URL Handling.....
        self.sharedCaption.handleURLTap{ [weak self]  urlText in
            let safariViewController = SFSafariViewController(url: URL(string : "\(urlText)")!)
            safariViewController.modalPresentationStyle = .fullScreen
            self!.delegate!.present(VC: safariViewController)
        }
        
        
        //album
        if self.post.album_title != ""{
            albumUpated(ishide: false)
        }else{
            albumUpated(ishide: true)
        }
        self.albumName.text = self.post.album_title ?? ""
        ///Middle Section
//        self.singleImage.image = #imageLiteral(resourceName: "1")
        if self.post.view_type == "single"{
            SingleSetup()
        }else if self.post.view_type == "multiple"{
            MultipleSetup()
        }else if self.post.view_type == "content"{
            CaptionSetup()
        }else if self.post.view_type == "video"{
            VideoSetup()
        }else if self.post.view_type == "url"{
            URLSetup()
            self.clickUrlButton.addTarget(self, action: #selector(clickUrl(_:)), for: .touchUpInside)
        }else if self.post.view_type == "link"{
            LinkSetup()
            self.clickLinkButton.addTarget(self, action: #selector(clickLink(_:)), for: .touchUpInside)
        }
        
        ///Lower Section
        
        //like button
        if Int(self.post.feed_favourites!)! > 0{
            likeBtnUpated(ishide: false)
        }else{
            likeBtnUpated(ishide: true)
        }
        if self.post.favourite_id! > 0 {
            self.likeBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }else{
            self.likeBtn.setImage(#imageLiteral(resourceName: "Unlike"), for: .normal)
        }
        self.likeCount.text = self.post.feed_favourites ?? ""
        self.commentCount.text = self.post.feed_comments ?? ""
        self.tagCount.text = "\(self.post.tags_count!)"
        
        //Actions for like , comment , tag  and share....
        self.moreBtn.addTarget(self, action: #selector(moreAction(_:)) , for: .touchUpInside)
        self.likeBtn.addTarget(self, action: #selector(likeAction(_:)) , for: .touchUpInside)
        self.commentBtn.addTarget(self, action: #selector(commentAction(_:)) , for: .touchUpInside)
        self.tagBtn.addTarget(self, action: #selector(tagAction(_:)) , for: .touchUpInside)
        self.shareBtn.addTarget(self, action: #selector(shareAction(_:)) , for: .touchUpInside)
        self.viewLikesBtn.addTarget(self, action: #selector(viewlikes(_:)) , for: .touchUpInside)
        self.viewCommentBtn.addTarget(self, action: #selector(viewComment(_:)) , for: .touchUpInside)
        self.commentLike.addTarget(self, action: #selector(likeComment(_:)), for: .touchUpInside)
        
        //Tapping  on the comment section on label...... YooOOoo
        let tapCommentLabel = UITapGestureRecognizer(target: self, action: #selector(viewComment(_:)))
        self.commentLabel.isAccessibilityElement = true
        self.commentLabel.accessibilityIdentifier = "commentLabel"
        self.commentLabel.isUserInteractionEnabled = true
        
        self.commentLabel.addGestureRecognizer(tapCommentLabel)
        
        
        //caption
        if self.post.feed_content == "" || self.post.feed_content == nil {
            captionUpated(ishide: true)
        }else{
            captionUpated(ishide: false)
        }
        self.caption.text = self.post.feed_content ?? ""
        // Share label HashTag Handling
        self.caption.handleHashtagTap{  [weak self]  text in
            
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "hashTag") as! HashTagViewController
            vc.hashtagString = text
            self!.delegate!.push(VC : vc)
        }
        // Share label URL Handling.....
        self.caption.handleURLTap{ [weak self]  urlText in
            let safariViewController = SFSafariViewController(url: URL(string : "\(urlText)")!)
            self!.delegate!.present(VC: safariViewController)
        }
        
        //comment  section
        if Int(self.post.feed_comments!)! <= 0  {
            self.commentBtnUpated(ishide: true)
            self.commentUpated(ishide: true)
        }else{
            if Int(self.post.feed_comments!)! > 1{
                self.commentBtnUpated(ishide: false)
                self.commentUpated(ishide: false)
            }else{
                self.commentBtnUpated(ishide: true)
                self.commentUpated(ishide: false)
            }
            if (self.post.comment?.count)! > 0{
                self.commentLabel.text =  "   \(self.post.comment?.first!.comment! ?? "")"
                self.swiftsoup(text: (self.post.comment?.first!.comment!)!)
                if self.post.comment?.first!.is_favorite! == "yes"{
                    self.commentLike.setImage(UIImage(named: "comment_like"), for: .normal)
                }else{
                    self.commentLike.setImage(UIImage(named: "comment_unlike"), for: .normal)
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    
    deinit{
        print("Feed New Cell Deallocated....")
    }
}

//Common Functions forr all...

extension Feed_Cell {
    @objc func tabNameLabel(_ sender : UITapGestureRecognizer){
        if self.post.is_shared == "yes"{
            guard let range1 = self.name.text?.range(of: "\(self.post.first_name!) " )?.nsRange else {  return  }
            guard let range2 = self.name.text?.range(of: "ared \(self.post.shared_first_name!)'s")?.nsRange else { return  }
            
            if sender.didTapAttributedTextInLabel(label : self.name, inRange: range1) {
                if NetworkController.front_user_id != self.post.user_id!{
                    NetworkController.others_front_user_id = self.post.user_id!
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
                self.delegate?.push(VC: vc)
            }
            if sender.didTapAttributedTextInLabel(label : self.name, inRange: range2){
                if NetworkController.front_user_id != self.post.original_post_owner!{
                    NetworkController.others_front_user_id = self.post.original_post_owner!
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
                self.delegate?.push(VC: vc)
            }
        }else{
            if NetworkController.front_user_id != self.post.user_id!{
                NetworkController.others_front_user_id = self.post.user_id!
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
            
            self.delegate?.push(VC: vc)
        }
    }
    
    @objc func likeAction(_ sender : UIButton){
        self.Like(postId: self.post.id!, type: "post", likeBtn: self.likeBtn, likeImage: #imageLiteral(resourceName: "like"), unlikeImage : #imageLiteral(resourceName: "Unlike"))
    }
    
    @objc func commentAction(_ sender : UIButton){
        if NetworkController.front_user_id != "0" {
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AnimatedComment_VC") as! AnimatedComment_VC
            vc.modalPresentationStyle = .overCurrentContext
            vc.post = self.post
            vc.delegate = self
            self.delegate?.present(VC : vc)
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.delegate?.present(VC : vc)
        }
       
    }
    
    @objc func tagAction(_ sender : UIButton){
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TagUsersViewController") as! TagUsersViewController
        vc.delegate = self
        vc.index = self.index
        vc.post = self.post
        vc.content_type = "post"
        self.delegate?.push(VC: vc)
    }
    
    @objc func shareAction(_ sender : UIButton){
        
        let shareAlert = UIAlertController(title: "Select the social network you wish to share post on.", message: nil , preferredStyle: .actionSheet)
        shareAlert.modalPresentationStyle = .popover
        shareAlert.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        shareAlert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        if NetworkController.front_user_id != "0"{
            shareAlert.addAction(UIAlertAction(title: "Share on Outdoors360", style: .default , handler: {_ in
                let alert = UIAlertController(title: "Share Post on Outdoors360", message: nil, preferredStyle: .alert)
                alert.modalPresentationStyle = .popover
                alert.addAction(UIAlertAction(title: "Share Now", style: .default, handler: { _ in
                    
                    let txtFeild = alert.textFields![0] as UITextField
                    self.Share(caption: txtFeild.text!)
//                    self.delegate?.ShareToYentna(post: self.data!, shareCaption: txtFeild.text!)
                    
                }))
                alert.addTextField(configurationHandler: {(txtF)-> Void in
                    txtF.placeholder = "Add Share Caption"
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                self.delegate?.present(VC: alert)
            }))
        }
        
        shareAlert.addAction(UIAlertAction(title: "Share to Social Network", style: .default , handler: {_ in
            
            let num = NetworkController.shared.random(digits: 8)
            let activityVC =  UIActivityViewController(activityItems: ["\(NetworkController.shareURL)\(String(num))\(self.post.id!)", self.singleImage?.image as Any], applicationActivities: nil)
            activityVC.modalPresentationStyle = .popover
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.mail, UIActivity.ActivityType.message]
            self.delegate?.present(VC: activityVC)
        }))
        
        shareAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: {_ in
            
        }))
        self.delegate?.present(VC: shareAlert)
    }
    
    @objc func viewlikes(_ sender : UIButton){
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PeopleLikedViewController") as! PeopleLikedViewController
        vc.postId = self.post.id!
        vc.content_type = "post"
        self.delegate?.push(VC: vc)
    }
    
    @objc func likeComment(_ sender : UIButton){
        if (self.post.comment?.count)! > 0{
            self.Like(postId: (self.post.comment?[0].id!)!, type: "comment", likeBtn: self.commentLike , likeImage : UIImage(named: "comment_like")! , unlikeImage : UIImage(named: "comment_unlike")!)
        }
    }
    
    @objc func viewComment(_ sender : Any){
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "comment") as! CommentsViewController
        vc.delegate = self
        vc.index = self.index
        vc.post = self.post
        self.delegate?.push(VC: vc)
    }
    
    @objc func moreAction(_ sender : UIButton){
        let actionSheet = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .actionSheet)
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.sourceView = self.viewContainingController()?.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        if self.post.user_id! == NetworkController.front_user_id  || NetworkController.front_user_id == NetworkController.Anthony || NetworkController.front_user_id == NetworkController.Colby || NetworkController.front_user_id == NetworkController.Blair || NetworkController.front_user_id == NetworkController.Rob || NetworkController.front_user_id == NetworkController.Mark{
            
            actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler:{ alert -> (Void) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "editAlbum") as? EditViewController
                vc?.post = self.post
                let navigation = UINavigationController(rootViewController: vc!)
                navigation.modalPresentationStyle = .fullScreen
                self.delegate?.present(VC : navigation)
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
                    self.Delete_Post()
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.delegate?.present(VC: alert)
                
                
            }))
        }else{
            actionSheet.addAction(UIAlertAction(title: "Flag Post", style: .destructive, handler: { _ in
                let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "FlagViewController") as! FlagViewController
                vc.postId = self.post.id!
                self.delegate?.push(VC : vc)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.delegate?.present(VC: actionSheet)
    }
    
    @objc func tapGoToProfile(_ sender : UITapGestureRecognizer){
        if NetworkController.front_user_id != self.post.user_id!{
            NetworkController.others_front_user_id = self.post.user_id!
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        self.delegate?.push(VC: vc)
    }
    
    @objc func double_Tap(_ sender : UITapGestureRecognizer){
        self.Like(postId: self.post.id!, type: "post", likeBtn: self.likeBtn, likeImage: #imageLiteral(resourceName: "like") , unlikeImage : #imageLiteral(resourceName: "Unlike"))
    }
    
}

// Comment Tag delegates
extension Feed_Cell : AnimatedCommentDelegate, CommentsCountDelegate , TagDelegate{
    
    //Animated Comment
    func UpdateComment(comment: CommentsResponse? , count : Int?) {
        let updates = CountUpdate(type: "comment", index: self.index, count: count, favID : nil, comment: comment)
        self.delegate?.update(count: updates)
    }
    
    //tag Delegate
    func TagCount(count: Int, index: Int) {
        let updates = CountUpdate(type: "tag", index: self.index, count: count, favID : nil, comment: nil)
        self.delegate?.update(count: updates)
    }
    
    //Comment Delegate
    func UpdatedCount(count: Int, index: Int, comment : CommentsResponse?){
        let updates = CountUpdate(type: "comment", index: self.index, count: count, favID : nil, comment: comment)
        self.delegate?.update(count: updates)
    }
}


extension Feed_Cell : UICollectionViewDelegate ,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.post.photos!.count > 0 {
            return self.post.photos!.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.post!.photos![indexPath.row].type! == "photo"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ImageCollectionViewCell
            cell.ConfigureCell(imagess : self.post.photos![indexPath.row])
            return cell
        }else{
            
            let video = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell
            video.Configure(videoURL: self.post!.photos![indexPath.row].photo!)
            return video
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
        VC.post = self.post
        VC.photo = self.post.photos!
        VC.index = indexPath.row
        VC.modalPresentationStyle = .fullScreen
        self.delegate?.present(VC: VC)
    }
}

//Setting Up Cells
extension Feed_Cell {
    
    func SingleSetup(){
        
        self.singleImage.isHidden = false
        self.popLikeHeart.isHidden = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapImage(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.singleImage.isUserInteractionEnabled = true
        self.singleImage.addGestureRecognizer(tapGestureRecognizer)
        
        doubleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(double_Tap(_:)))
        doubleGestureRecognizer.numberOfTapsRequired = 2
        self.singleImage.isUserInteractionEnabled = true
        self.singleImage.addGestureRecognizer(doubleGestureRecognizer)
        tapGestureRecognizer.require(toFail: doubleGestureRecognizer)
        
        
        if self.post.is_cover! != "no"{
            tapGestureRecognizer.isEnabled = false
            let ratio = CGFloat(1500 / 415)
            let newHeight =  UIScreen.main.bounds.width / ratio
            self.singleImage.snp.updateConstraints { (update) in
                update.height.equalTo(newHeight)
//                self.delegate?.refreshRow?(index: self.index)
            }
            
            let res = ImageResource(downloadURL: URL(string: (self.post.link_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.post.link_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            self.singleImage.kf.indicatorType = .activity
            self.singleImage.kf.setImage(with: res)
            
        }else{
            tapGestureRecognizer.isEnabled = true
            let ratio = CGFloat( self.post.photos!.first!.width! / self.post.photos!.first!.height!)
            let newHeight = self.contentView.frame.width / ratio
            self.singleImage.snp.updateConstraints { (update) in
                update.height.equalTo(newHeight)
            }
            
            let process = BlurImageProcessor(blurRadius: 5.0)
            if let sImg = self.post.photos?.first?.small_photo{
                let resource1 = ImageResource(downloadURL: URL(string: (sImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (sImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                self.singleImage.kf.indicatorType = .activity
                self.singleImage.kf.setImage(with: resource1, options : [.processor(process)]) {(result) in
                    switch result{
                    case .success(let val):
                        if let img = self.post.photos?.first?.photo{
                            let resource2 = ImageResource(downloadURL: URL(string: (img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                            self.singleImage.kf.indicatorType = .activity
                            self.singleImage.kf.setImage(with: resource2, placeholder : val.image)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            
        }
        
        
        self.collectionView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.collectionView.isHidden = true
        }
        self.linkView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.linkView.isHidden = true
            self.linkImage.isHidden = true
            self.linkTitle.isHidden = true
            self.clickLinkButton.isHidden = true
        }
        self.urlView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.urlView.isHidden = true
            self.urlImage.isHidden = true
            self.urlDesc.isHidden = true
            self.urlTitle.isHidden = true
            self.urlLink.isHidden = true
            self.clickUrlButton.isHidden = true
        }
        self.videoView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.videoView.isHidden = true
        }
        
    }
    
    func MultipleSetup(){
        self.collectionView.snp.updateConstraints { (update) in
            update.height.equalTo(250)
            self.collectionView.isHidden = false
        }
        
        self.singleImage.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.singleImage.isHidden = true
            self.popLikeHeart.isHidden = true
        }
        
        self.linkView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.linkView.isHidden = true
            self.linkImage.isHidden = true
            self.linkTitle.isHidden = true
            self.clickLinkButton.isHidden = true
        }
        
        self.urlView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.urlView.isHidden = true
            self.urlImage.isHidden = true
            self.urlDesc.isHidden = true
            self.urlTitle.isHidden = true
            self.urlLink.isHidden = true
            
        }
        
        self.videoView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.videoView.isHidden = true
        }
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    func LinkSetup(){
        
        let resource1 = ImageResource(downloadURL: URL(string: (self.post.link_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.post.link_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        self.linkImage.kf.indicatorType = .activity
        self.linkImage.kf.setImage(with: resource1)
        self.linkTitle.text = self.post.link_title ?? ""
        
        self.linkView.snp.updateConstraints { (update) in
            update.height.equalTo(230)
            self.linkView.isHidden = false
            self.linkImage.isHidden = false
            self.linkTitle.isHidden = false
            self.clickLinkButton.isHidden = false
            
        }
        self.singleImage.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.singleImage.isHidden = true
            self.popLikeHeart.isHidden = true
        }
        self.collectionView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.collectionView.isHidden = true
        }
        self.urlView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.urlView.isHidden = true
            self.urlImage.isHidden = true
            self.urlDesc.isHidden = true
            self.urlTitle.isHidden = true
            self.urlLink.isHidden = true
        }
        self.videoView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.videoView.isHidden = true
        }
        
    }
    
    func URLSetup(){
        
        self.singleImage.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.singleImage.isHidden = true
            self.popLikeHeart.isHidden = true
        }
        self.collectionView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.collectionView.isHidden = true
        }
        self.linkView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.linkView.isHidden = true
            self.linkImage.isHidden = true
            self.linkTitle.isHidden = true
            self.clickLinkButton.isHidden = true
        }
        self.videoView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.videoView.isHidden = true
        }
        self.urlView.snp.updateConstraints { (update) in
            update.height.equalTo(150)
            self.urlView.isHidden = false
            self.urlImage.isHidden = false
            self.urlDesc.isHidden = false
            self.urlTitle.isHidden = false
            self.urlLink.isHidden = false
            self.clickUrlButton.isHidden = false
        }
        
        /// Check it out...
        self.caption.text = self.post.feed_content
        let linkImg = ImageResource(downloadURL: URL(string: (self.post.link_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)!, cacheKey: self.post.link_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.urlImage.kf.indicatorType = .activity
        self.urlImage.kf.setImage(with: linkImg, placeholder : #imageLiteral(resourceName: "no_image"))
        self.urlLink.text = self.post.link_url!
        self.urlTitle.text = self.post.link_title!
        self.urlDesc.text = self.post.link_desc!
        
        
    }
    
    func VideoSetup(){
        
        self.videoView.snp.updateConstraints { (update) in
            update.height.equalTo(250)
            self.videoView.isHidden = false
        }
        self.videoView.videoUrl = URL(string: "\(self.post.photos?.first!.photo! ?? "")")
        self.videoView.shouldAutoplay = false
        self.videoView.shouldAutoRepeat = false
        
        self.singleImage.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.singleImage.isHidden = true
            self.popLikeHeart.isHidden = true
        }
        self.collectionView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.collectionView.isHidden = true
        }
        self.linkView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.linkView.isHidden = true
            self.linkImage.isHidden = true
            self.linkTitle.isHidden = true
            self.clickLinkButton.isHidden = true
        }
        self.urlView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.urlView.isHidden = true
            self.urlImage.isHidden = true
            self.urlDesc.isHidden = true
            self.urlTitle.isHidden = true
            self.urlLink.isHidden = true
        }
        
    }
    
    func CaptionSetup(){
        self.singleImage.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.singleImage.isHidden = true
            self.popLikeHeart.isHidden = true
        }
        self.collectionView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.collectionView.isHidden = true
        }
        self.linkView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.linkView.isHidden = true
        }
        self.urlView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.urlView.isHidden = true
        }
        self.videoView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
            self.videoView.isHidden = true
        }
        
    }
}

//Actions for Link, SingleImage And URL....
extension Feed_Cell{
    ///Click (URLView) LinkPreview
    @objc func clickUrl(_ sender : Any){

        if let content = self.post.link_url{
            let safariViewController = SFSafariViewController(url: URL(string : "\(content)")!)
            self.delegate?.present(VC: safariViewController)
        }
        
    }
    
    ///Click (LinkView) Shared Reports,Trips etc...
    @objc func clickLink(_ sender : Any){
        if let content = self.post.feed_content{
            let safariViewController = SFSafariViewController(url: URL(string : "\(content)")!)
            self.delegate?.present(VC: safariViewController)
        }
    }
    
    //Click  (SingleImage) image To show
    @objc func TapImage(_ sender : Any){
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
        VC.post = self.post
        VC.photo.append(self.post!.photos!.first!)
        VC.index = 0
        VC.modalPresentationStyle = .fullScreen
        self.delegate?.present(VC : VC)
    }
    
}

/// Layout extension: Function for each element Album, sher
extension Feed_Cell {
    
    func sharedUpated(ishide : Bool){
        if ishide{
            self.sharedCaption.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self.albumName.snp.top).offset(0)
            }
            self.sharedCaption.isHidden = true
        }else{
            self.sharedCaption.isHidden = false
            self.sharedCaption.snp.remakeConstraints { (make) in
                make.height.greaterThanOrEqualTo(17)
                make.bottom.equalTo(self.albumName.snp.top).offset(-8)
            }
        }
    }
    
    func albumUpated(ishide : Bool){
        
        if ishide{
            self.albumName.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self.singleImage.snp.top).offset(0)
            }
            self.albumName.isHidden = true
        }else{
            self.albumName.snp.remakeConstraints { (make) in
                make.height.equalTo(17)
                make.bottom.equalTo(self.singleImage.snp.top).offset(-8)
            }
            self.albumName.isHidden = false
        }
    }
    
    func likeBtnUpated(ishide : Bool){
        if ishide{
            self.viewLikesBtn.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self.caption.snp.top).offset(0)
            }
            self.viewLikesBtn.isHidden = true
        }else{
            self.viewLikesBtn.snp.remakeConstraints { (make) in
                make.height.equalTo(17)
                make.bottom.equalTo(self.caption.snp.top).offset(-8)
            }
            self.viewLikesBtn.isHidden = false
        }
    }
    
    func captionUpated(ishide : Bool){
        if ishide{
            self.caption.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self.commentView.snp.top).offset(0)
            }
            self.caption.isHidden = true
        }else{
            self.caption.snp.remakeConstraints { (make) in
                make.height.greaterThanOrEqualTo(17)
                make.bottom.equalTo(self.commentView.snp.top).offset(-8)
            }
            self.caption.isHidden = false
        }
    }
    
    func commentUpated(ishide : Bool){
        if ishide{
            self.commentView.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self.viewCommentBtn.snp.top).offset(0)
            }
            self.commentLabel.isHidden = true
            self.commentLike.isHidden = true
        }else{
            self.commentView.snp.remakeConstraints{ (make) in
                make.height.greaterThanOrEqualTo(17)
                make.bottom.equalTo(self.viewCommentBtn.snp.top).offset(-8)
            }
            self.commentLabel.isHidden = false
            self.commentLike.isHidden = false
        }
    }
    
    func commentBtnUpated(ishide : Bool){
        if ishide{
            self.viewCommentBtn.snp.remakeConstraints { (make) in
                make.height.equalTo(0)
                make.bottom.equalTo(self.shadowView.snp.top).offset(0)
            }
            self.viewCommentBtn.isHidden = true
        }else{
            self.viewCommentBtn.snp.remakeConstraints { (make) in
                make.height.equalTo(17)
                make.bottom.equalTo(self.shadowView.snp.top).offset(-8)
            }
            self.viewCommentBtn.isHidden = false
        }
    }
    
}

//API Calls
extension Feed_Cell {
    
    func Delete_Post(){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(self.post.id!)",
            "type" : "post"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost){
            response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    let alert =  UIAlertController(title : "Successfully Deleted" , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.present(VC: alert)
                    self.delegate?.delete(index: self.index)
                    
                }else{
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.present(VC: alert)
                }
            }else{
                
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.delegate?.present(VC: alert)
            }
        }
        
    }
    
    func Edit_Post(feed_caption :String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(self.post.id!)",
            "feed_content" : "\(feed_caption)",
            "type" : "post"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UpdatePostCaption){  resp,_ in
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    
                    self.post.feed_content = feed_caption
                    self.caption.text = feed_caption
                    let alert =  UIAlertController(title : "Successfully Updated" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.modalPresentationStyle = .popover
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.present(VC: alert)
                    
                    
                }else{
                    let alert =  UIAlertController(title : "\(resp["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.modalPresentationStyle = .popover
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.delegate?.present(VC: alert)
                }
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.modalPresentationStyle = .popover
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.delegate?.present(VC: alert)
            }
            
            
        }
    }
    
    func Like(postId : String, type : String, likeBtn : UIButton, likeImage : UIImage , unlikeImage : UIImage) {
        if NetworkController.front_user_id != "0"{
            if (likeBtn.currentImage?.isEqual(likeImage))!{
                self.popLikeHeart.image = unlikeImage
                self.popLikeHeart.tintColor = .white
                if likeBtn != commentLike{
                    self.likeAnimation()
                }
                
                UIView.transition(with: likeBtn, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    likeBtn.setImage(unlikeImage, for: .normal)
                }, completion: nil)
                let parameters : [String: Any] = [
                    "post_id" : postId,
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" :  type,
                    "state" : "unlike"
                ]
                likeBtn.isEnabled = false
                self.doubleGestureRecognizer?.isEnabled = false
                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                    if response != JSON.null{
                        if response["result"]["status"].boolValue == true{
                            if likeBtn == self.commentLike{
                                
                                let updates = CountUpdate(type: "commentLike", index: self.index, count: 0 , favID : nil, comment: nil)
                                self.delegate?.update(count: updates)
                                
                            }else{
                                self.likeCount.text = "\(response["result"]["like_count"].stringValue)"
                                let updates = CountUpdate(type: "like", index: self.index, count: response["result"]["like_count"].intValue, favID : response["result"]["favourite_id"].intValue, comment: nil)
                                self.delegate?.update(count: updates)
                                self.doubleGestureRecognizer?.isEnabled = true
                            }
                            likeBtn.isEnabled = true
                        }else{
                            likeBtn.isEnabled = true
                            self.doubleGestureRecognizer?.isEnabled = true
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                            self.delegate?.present(VC: alert)
                        }
                    }else{
                        likeBtn.isEnabled = true
                        self.doubleGestureRecognizer?.isEnabled = true
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.present(VC: alert)
                    }
                }
                
            }
            else{
                self.popLikeHeart.image = likeImage
                if likeBtn != commentLike{
                    self.likeAnimation()
                }
                UIView.transition(with: likeBtn, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    likeBtn.setImage(likeImage, for: .normal)
                }, completion: nil)
                let parameters : [String: Any] = [
                    "post_id" : postId,
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : type,
                    "state" : "like"
                ]
                likeBtn.isEnabled = false
                self.doubleGestureRecognizer?.isEnabled = false
                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                    if response != JSON.null{
                        if response["result"]["status"].boolValue == true{
                            if likeBtn == self.commentLike{
                                let updates = CountUpdate(type: "commentLike", index: self.index, count: 1 , favID : nil, comment: nil)
                                self.delegate?.update(count: updates)
                                
                            }else{
                                self.likeCount.text = "\(response["result"]["like_count"].stringValue)"
                                let updates = CountUpdate(type: "like", index: self.index, count: response["result"]["like_count"].intValue, favID : response["result"]["favourite_id"].intValue, comment: nil)
                                self.delegate?.update(count: updates)
                            }
                            likeBtn.isEnabled = true
                            self.doubleGestureRecognizer?.isEnabled = true
                        }
                        else {
                            likeBtn.isEnabled = true
                            self.doubleGestureRecognizer?.isEnabled = true
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                            self.delegate?.present(VC: alert)
                        }
                    }else{
                        likeBtn.isEnabled = true
                        self.doubleGestureRecognizer?.isEnabled = true
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.delegate?.present(VC: alert)
                    }
                }
            }
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.delegate?.present(VC: vc)
        }
    }

    func Share(caption : String){
        if InternetAvailabilty.isInternetAvailable(){
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "post_id" : "\(self.post.id!)",
                "type" : "post",
                "share_caption" : "\(caption)"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){[weak self] response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        self?.delegate?.share(post: self!.post!)
                        let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared", preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self?.delegate?.present(VC: alert)
                    }else{
                        let alert =  UIAlertController(title : "\(String(describing: "\(response["result"]["description"].stringValue)"))" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self?.delegate?.present(VC: alert)
                    }
                }else{
                    let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self?.delegate?.present(VC: alert)
                }
            }
        }else{
            let alert =  UIAlertController(title : "No Internet Connection" , message : nil, preferredStyle :UIAlertController.Style.alert )
            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
            self.delegate?.present(VC: alert)
        }
    }
    
    func likeAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
            self.popLikeHeart.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popLikeHeart.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                self.popLikeHeart.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                    self.popLikeHeart.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.popLikeHeart.alpha = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                    self.popLikeHeart.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }
}

extension Feed_Cell{
    
    func mentionTapped( textView : UILabel, mentionText : [String], regularText : String, id : [String]){
        
        let regularText = NSMutableAttributedString(string: regularText)
        
        var locArr : [NSRange] = []
        let attribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3607843137, green: 0.6666666667, blue: 1, alpha: 1),
        ]
       
        for i in 0..<id.count {
            
            let tappableText = NSMutableAttributedString(string: mentionText[i])
            if let  textt = tappableText.string.first{
                if textt == "#"{
                    tappableText.addAttributes(attribute, range: NSMakeRange(0, tappableText.length))
                }else{
                    tappableText.addAttributes(attribute, range: NSMakeRange(0, tappableText.length))
                }
            }
            let tp = tappableText.string
            if tp != ""{
                let loc = regularText.mutableString.range(of: tp)
                if !locArr.contains(loc){
                    locArr.append(loc)
                    regularText.replaceCharacters(in: loc, with: tappableText)
                }
            }
            
        }
        let startVal = NSMutableAttributedString(string:"\(self.post.comment!.first!.first_name!) \(self.post.comment!.first!.last_name!)  ")
        startVal.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold)], range: NSMakeRange(0, startVal.length))
        regularText.insert(startVal, at: 0)
        commentLabel.attributedText = regularText
    }
    
    func swiftsoup( text : String){
        do{
            let html: String = commentLabel.text!
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
            
            //            self.hashTag(regularText: text, hashTag: hashTags)
            self.mentionTapped(textView: commentLabel, mentionText: mentions, regularText : text , id: ids)
        }catch Exception.Error(let type, let message){
            print("\(message) \n \(type)")
        }catch{
            print("error")
        }
    }
}
