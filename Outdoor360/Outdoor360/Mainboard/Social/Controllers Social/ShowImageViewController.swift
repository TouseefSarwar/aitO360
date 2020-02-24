//
//  ShowImageViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 31/10/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher


class ShowImageViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var loaderView : UIView!
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var bottomView : UIView!
    var isHideViews : Bool = false
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var pro_image: ImageViewX!
    @IBOutlet weak var like_count: LabelX!
    @IBOutlet weak var comment_count: LabelX!
    @IBOutlet weak var tag_count: LabelX!
    @IBOutlet weak var like_Btn: UIButton!
    @IBOutlet weak var tag_Btn: UIButton!
    @IBOutlet weak var comment_Btn: UIButton!
    @IBOutlet weak var popLikeHeart : UIImageView!
    
    
    //MARK: Variables...
    var like_flage : Int!
//    var photos : [String] = []
//    var photo_ids : [String] = []
    var post : SocialPost!
    var resp : Bool!
    var photo : [Photo] = []
    var index : Int!
    //pushNotification for closing window
    var pushNotification = false
    
    var doubletapImage : UITapGestureRecognizer!
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    @IBAction func close(_ sender: Any) {
        if self.pushNotification{let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            tab_Crtl.modalTransitionStyle = .crossDissolve
            tab_Crtl.modalPresentationStyle = .fullScreen
            self.present(tab_Crtl, animated: true, completion: nil)
        }else{
            self.photo.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    //MARK: People Who like this
    @IBAction func peopleLiked(_ sender : ButtonY){
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PeopleLikedViewController") as! PeopleLikedViewController
        vc.postId = self.photo[index].id!
        vc.content_type = "photo"
        let navigationControlr = UINavigationController(rootViewController: vc)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: false, completion: nil)
        
    }
    
    //MARK : Info Image button....
    
    @IBAction func ImageInfo_Btn(_ sender: Any) {
       
        performSegue(withIdentifier: "infoImage", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isPagingEnabled = true
        let pagesize = self.view.bounds.size
        let contentOffset = CGPoint(x: pagesize.width * CGFloat(index), y: 0)
        self.collectionView.setContentOffset(contentOffset, animated: false)
        self.like_count.text = self.photo[index].fav_count!
        self.comment_count.text = self.photo[index].comment_count!
        self.tag_count.text = self.photo[index].tag_count!
        let img = ImageResource(downloadURL: URL(string: (self.photo[index].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.photo[index].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        self.pro_image.kf.indicatorType = .activity
        self.pro_image.kf.setImage(with: img)
        self.user_name.text = self.photo[index].first_name! + " " + self.photo[index].last_name!
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.Tapped(sender:)))
        self.pro_image.isUserInteractionEnabled = true
        self.pro_image.addGestureRecognizer(tapImage)
        
        let tapName = UITapGestureRecognizer(target: self, action: #selector(self.Tapped(sender:)))
        self.user_name.isUserInteractionEnabled = true
        self.user_name.addGestureRecognizer(tapName)
        
        collectionView.register(UINib(nibName: "SingleImage", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "ShowVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
        if self.photo.count == 1  {
            if NetworkController.others_front_user_id == "0"{
                Scroll_Comments(front_user_id: NetworkController.front_user_id, photo_id: self.photo[0].id!, original_owner_id: "", type: "photo")
            }else{
                Scroll_Comments(front_user_id: NetworkController.others_front_user_id, photo_id: self.photo[0].id!, original_owner_id: "", type: "photo")
            }
            
        }else{
            if NetworkController.others_front_user_id == "0" {
                Scroll_Comments(front_user_id: NetworkController.front_user_id, photo_id: self.photo[index].id!, original_owner_id: "", type: "photo")
            }else{
                Scroll_Comments(front_user_id: NetworkController.others_front_user_id, photo_id: self.photo[index].id!, original_owner_id: "", type: "photo")
            }
            
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)   
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showtags"{
            let nav = segue.destination as! UINavigationController
            let VC : TagUsersViewController = nav.topViewController as! TagUsersViewController
            VC.delegate = self
            VC.index = self.index
            VC.photo = self.photo[index]
            
        }else if segue.identifier == "showComment"{
            let nav = segue.destination as! UINavigationController
            let vc : CommentsViewController = nav.topViewController as! CommentsViewController
            vc.delegate = self
            vc.index = self.index
            vc.photo = self.photo[index]
            
        }else if segue.identifier == "infoImage"{
            let nav = segue.destination as! UINavigationController
            let vc : ImageInfoViewController = nav.topViewController as! ImageInfoViewController
            vc.title = "Info"
            vc.photo = self.photo[self.index]
            vc.indexOfPhoto = self.index
        }
        
    }
}

extension ShowImageViewController : CommentsCountDelegate , TagDelegate {
    
    func TagCount(count: Int, index: Int) {
        self.tag_count.text = "\(count)"
    }
    
    func UpdatedCount(count: Int, index: Int, comment : CommentsResponse?) {
        self.comment_count.text = "\(count)"
    }
    
}



extension ShowImageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.photo[indexPath.row].type == "photo"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleImage
            
            // ScrollView
//            let tapScroller = UITapGestureRecognizer(target: self, action: #selector(self.TapToHideViews(sender:)))
//            tapScroller.cancelsTouchesInView = false
//            tapScroller.numberOfTapsRequired = 1
//            cell.scrollView.isUserInteractionEnabled = true
//            cell.scrollView.addGestureRecognizer(tapScroller)
            
            
            let process = BlurImageProcessor(blurRadius: 5.0)
            
            if let small = self.photo[indexPath.row].small_photo{
                let resource1 = ImageResource(downloadURL: URL(string: (small.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (small.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                cell.img_view.kf.indicatorType = .activity
                cell.img_view.kf.setImage(with: resource1, options : [.processor(process)]) { (result) in
                    switch result{
                    case .success(let val):
                        if let photo = self.photo[indexPath.row].photo{
                            let resource2 = ImageResource(downloadURL: URL(string: (photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                            cell.img_view.kf.indicatorType = .activity
                            cell.img_view.kf.setImage(with: resource2, placeholder : val.image)
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }else{
                if let photo = self.photo[indexPath.row].photo{
                    let resource2 = ImageResource(downloadURL: URL(string: (photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                    cell.img_view.kf.indicatorType = .activity
                    cell.img_view.kf.setImage(with: resource2, placeholder : #imageLiteral(resourceName: "placeholderImage"))
                }
            }
            
           
            
            
            self.doubletapImage = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped(sender:)))
            doubletapImage.numberOfTapsRequired = 2
            cell.img_view.isUserInteractionEnabled = true
            cell.img_view.addGestureRecognizer(doubletapImage)
            
            let img = ImageResource(downloadURL: URL(string: (self.photo[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.photo[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            self.pro_image.kf.indicatorType = .activity
            self.pro_image.kf.setImage(with: img)
            self.user_name.text = self.photo[indexPath.row].first_name! + " " + self.photo[indexPath.row].last_name!
            if self.photo[indexPath.row].is_favorite == "yes"{
                self.like_Btn.setImage(#imageLiteral(resourceName: "big_like"), for: .normal)
            }else{
                self.like_Btn.setImage(#imageLiteral(resourceName: "big_unlike"), for: .normal)
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! ShowVideoCollectionViewCell
            
           
            
            cell.ConfigureCell(VideoURL: self.photo[indexPath.row].photo!)
            let img = ImageResource(downloadURL: URL(string: (self.photo[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.photo[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            self.pro_image.kf.indicatorType = .activity
            self.pro_image.kf.setImage(with: img)
            self.user_name.text = self.photo[indexPath.row].first_name! + " " + self.photo[indexPath.row].last_name!
            if self.photo[indexPath.row].is_favorite == "yes"{
                self.like_Btn.setImage(#imageLiteral(resourceName: "big_like") , for: .normal)
            }else{
                self.like_Btn.setImage(#imageLiteral(resourceName: "big_unlike") , for: .normal)
            }
            
            return cell
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
 
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
//        print("Current Page : \(currentPage)")
        self.index = currentPage
        if currentPage == self.photo.count - 1   {
//            self.like_count.text = self.photo[currentPage].fav_count!
//            self.comment_count.text = self.photo[currentPage].comment_count!
//            self.tag_count.text = self.photo[currentPage].tag_count!
//            let img = ImageResource(downloadURL: URL(string: (self.photo[currentPage].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.photo[currentPage].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
//            self.pro_image.kf.indicatorType = .activity
//            self.pro_image.kf.setImage(with: img)
//            self.user_name.text = self.photo[currentPage].first_name! + " " + self.photo[currentPage].last_name!
//            if self.photo[currentPage].is_favorite == "yes"{
//                self.like_Btn.setImage(#imageLiteral(resourceName: "big_like"), for: .normal)
//            }else{
//                self.like_Btn.setImage(#imageLiteral(resourceName: "big_unlike"), for: .normal)
//            }

            Scroll_Comments(front_user_id: NetworkController.front_user_id, photo_id: self.photo[currentPage].id!, original_owner_id: "", type: "photo")
        }else if currentPage == self.photo.count{
            
        }else{
            Scroll_Comments(front_user_id: NetworkController.front_user_id, photo_id: self.photo[currentPage].id!, original_owner_id: "", type: "photo")
        }

        
        
    }
    
}



extension ShowImageViewController{
    
    @objc func TapToHideViews(sender : UITapGestureRecognizer){
        if self.isHideViews == false{
            /// hideWithAnimation is the extension of uiview
            self.topView.hideWithAnimation(hidden: true)
            self.bottomView.hideWithAnimation(hidden: true)
            self.isHideViews = true
        }else{
            self.topView.hideWithAnimation(hidden: false)
            self.bottomView.hideWithAnimation(hidden: false)
            self.isHideViews = false
        }
    }
    
    @objc func Tapped(sender : UITapGestureRecognizer){
        NetworkController.others_front_user_id = self.photo[index].front_user_id!
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        let navigationController = UINavigationController(rootViewController: profileView)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func doubleTapped(sender : UITapGestureRecognizer){
        print("Double Tap Working")
        self.LikePhoto()
    }
    
    @IBAction func like(_ sender: UIButton) {
       self.LikePhoto()
    }
    
    @IBAction func tagBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TagUsersViewController") as! TagUsersViewController
        vc.delegate = self
        vc.index = self.index
        vc.photo = self.photo[index]
        vc.content_type = "photo"
        let navigationControlr = UINavigationController(rootViewController: vc)
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    
    @IBAction func comment(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "comment") as! CommentsViewController
        vc.delegate = self
        vc.index = self.index
        vc.photo = self.photo[index]
        vc.content_type = "photo"
        let navigationControlr = UINavigationController(rootViewController: vc)
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    
    @IBAction func share(_ sender: UIButton) {
        let shareAlert = UIAlertController(title: "Share Post", message: "Select the social network you wish to share post on.", preferredStyle: .actionSheet)
        
        if NetworkController.front_user_id != "0"{
            shareAlert.addAction(UIAlertAction(title: "Share on Outdoors360", style: .default , handler: {_ in
                let alert = UIAlertController(title: "Share", message: "Share Post on Outdoors360", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Share Now", style: .default, handler: { _ in
                    let txtFeild = alert.textFields![0] as UITextField
                    self.Share(postid: self.photo[self.index].id! , caption: txtFeild.text!)
                }))
                alert.addTextField(configurationHandler: {(txtF)-> Void in
                    txtF.placeholder = "Add Caption"
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }))
        }
        shareAlert.addAction(UIAlertAction(title: "Share to Socail Network", style: .default , handler: {_ in
            let num = NetworkController.shared.random(digits: 8)
            let activityVC =  UIActivityViewController(activityItems: ["\(NetworkController.shareURL)\(NetworkController.photo_id)p\(String(num))\(NetworkController.photo_id)"], applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.mail, UIActivity.ActivityType.message]
            
            self.present(activityVC, animated: true, completion: nil)
            
            
        }))
        shareAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(shareAlert, animated: true, completion: nil)
    }
}

//MARK: API's

extension ShowImageViewController {
    
    func Share(postid : String, caption : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(postid)",
            "type" : "photo",
            "share_caption" : "\(caption)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){ response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    
                    let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared", preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func Scroll_Comments(front_user_id : String,  photo_id : String, original_owner_id : String, type : String) {
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "original_owner_id" : "\(original_owner_id)",
            "photo_id" : "\(photo_id)",
            "type" : "\(type)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SinglePostComments){response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    self.resp = true
                    print(response["result"])
                    self.like_count.text = response["result"]["total_favourites"].stringValue
                    if response["result"]["is_favourites"].intValue == 0{
                        self.like_Btn.setImage(#imageLiteral(resourceName: "big_unlike"), for: .normal)
                    }else{
                        self.like_Btn.setImage(#imageLiteral(resourceName: "big_like"), for: .normal)
                    }
                    self.tag_count.text = response["result"]["total_tagged"].stringValue
                    self.comment_count.text = response["result"]["total_comments"].stringValue
//                    print(response["result"]["is_favourites"].intValue)
//                    print(response["result"]["total_comments"])
//                    print(response["result"]["total_tagged"])
                }
                else {
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func LikePhoto(){
        if NetworkController.front_user_id != "0"{
            if (self.like_Btn.currentImage?.isEqual(UIImage(named: "big_like")))!{
                self.doubletapImage.isEnabled = false
                self.like_Btn.isEnabled = false
                self.popLikeHeart.image = #imageLiteral(resourceName: "big_unlike")
                self.likeAnimation()
                UIView.transition(with: self.like_Btn , duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.like_Btn.setImage(#imageLiteral(resourceName: "big_unlike"), for: .normal)
                }, completion: nil)
                let parameters : [String: Any] = [
                    "post_id" : "\( self.photo[index].id!)",
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : "photo",
                    "state" : "unlike"
                ]

                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                    if response != JSON.null{
                        if response["result"]["status"].boolValue == true{
                            self.like_count.text = "\(response["result"]["like_count"].stringValue)"
                            self.like_Btn.isEnabled = true
                            self.doubletapImage.isEnabled = true
                        }
                        else {
                            self.like_Btn.isEnabled = true
                            self.doubletapImage.isEnabled = true
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                    }else{
                        self.like_Btn.isEnabled = true
                        self.doubletapImage.isEnabled = true
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            else{
                self.like_Btn.isEnabled = false
                self.doubletapImage.isEnabled = false
                self.popLikeHeart.image = #imageLiteral(resourceName: "big_like")
                self.likeAnimation()
                UIView.transition(with: self.like_Btn, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.like_Btn.setImage(#imageLiteral(resourceName: "big_like"), for: .normal)
                }, completion: nil)
                
                let parameters : [String: Any] = [
                    "post_id" : "\(self.photo[index].id!)",
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "type" : "photo",
                    "state" : "like"
                ]

                NetworkController.shared.Service(parameters: parameters, nameOfService: .LikePost){ response,_ in
                    if response != JSON.null{
                        
                        if response["result"]["status"].boolValue == true{
                            self.like_count.text = "\(response["result"]["like_count"].stringValue)"
                            self.like_Btn.isEnabled = true
                            self.doubletapImage.isEnabled = true
                        }
                        else {
                            self.like_Btn.isEnabled = true
                            self.doubletapImage.isEnabled = true
                            let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                    }else{
                        self.like_Btn.isEnabled = true
                        self.doubletapImage.isEnabled = true
                        let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self.present(alert, animated: true, completion: nil)
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
}

//Like ANimations func
extension ShowImageViewController{
    
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
