
import UIKit
import SwiftyJSON
import Kingfisher
import AVFoundation
import DateToolsSwift
import JJFloatingActionButton
import Social
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit

class NewFeedsViewController: UIViewController {
    
    
   //Outlets
    @IBOutlet weak var tableView: UITableView!
    //Login Float bar
    @IBOutlet weak var loginFloat : UIView!
    //Share Float bar
    @IBOutlet weak var shareRef : UIView!
    @IBOutlet weak var shareLabel : UILabel!
    var previousController: UIViewController?
    
    //MARK: Variables....
    var postData : [SocialPost] = []
    //Refresh Control....
    let refreshControl = UIRefreshControl()
    var load_more = false // For load more.. Checked in Scrolling tableview
    //Float Button
    let floatBtn = JJFloatingActionButton()
    //UserDefaults...
    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
    
    var cellHeights = [IndexPath: CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(Refresh_Feeds(_:)) , for: .valueChanged)
        self.setImageForNavigation(imageFor: #imageLiteral(resourceName: "navigationHeader"))
        
        tableView.register(UINib( nibName: "SuggestedTableViewCell", bundle: nil), forCellReuseIdentifier: "suggestTableCell")
        tableView.register(UINib(nibName: "Feed_Cell", bundle: nil), forCellReuseIdentifier: Feed_Cell.identifier)
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "feedsList"
        //Share App Link Label
        let tapShare = UITapGestureRecognizer(target: self, action: #selector(shareRef(_:)))
        tapShare.numberOfTapsRequired = 1
        self.shareLabel.isUserInteractionEnabled = true
        self.shareLabel.addGestureRecognizer(tapShare)
        
        if dic == nil{
            NetworkController.front_user_id = "0"
            UIApplication.shared.unregisterForRemoteNotifications()
            self.tabBarController?.tabBar.items?[2].isEnabled = false
            self.tabBarController?.tabBar.items?[3].isEnabled = false
            self.shareRef.isHidden = true
            
            self.shareRef.snp.updateConstraints {(mk) in
                mk.height.equalTo(0)
            }
            self.loginFloat.isHidden = false
        }else{
            NetworkController.front_user_id = dic!["front_user_id"] as! String
//            NetworkController.user_image = dic!["user_image"] as! String
//            NetworkController.user_name = dic!["user_name"] as! String

            UIApplication.shared.registerForRemoteNotifications()
            self.tabBarController?.tabBar.items?[2].isEnabled = true
            self.tabBarController?.tabBar.items?[3].isEnabled = true
            self.shareRef.isHidden = false
            self.loginFloat.isHidden = true
            AddCreateBtn()
        }
        
        SocialPosts(front_user_id: "\(NetworkController.front_user_id)" )
        self.tableView.estimatedRowHeight = 500
        self.tableView.rowHeight = UITableView.automaticDimension
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.delegate = self
        self.AddNavLeftRightButtonItem()
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        NetworkController.others_front_user_id = "0"
        if dic != nil{
            if let img = dic!["user_image"]{
                NetworkController.user_image = img as! String
            }else{
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.shareRef.snp.updateConstraints { [weak self]  (make) in
            make.height.equalTo(0)
            self!.shareRef.isHidden = true
        }
    }
    
    deinit{
        print("NewFeeds deallocated....")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func Refresh_Feeds(_ sender : Any){
        self.Refresh_Feeds(front_user_id: "\(NetworkController.front_user_id)")
    }
    
    func AddCreateBtn(){
        
        floatBtn.accessibilityLabel = "Plus Button"
        floatBtn.isAccessibilityElement = true
    
        floatBtn.buttonColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        floatBtn.buttonImageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        let post_btn = floatBtn.addItem()
        post_btn.accessibilityLabel = "Create Post"
        post_btn.isAccessibilityElement = true
        
        post_btn.titleLabel.text = "Create Post"
        post_btn.imageView.image = #imageLiteral(resourceName: "post")
        post_btn.buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        post_btn.buttonImageColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        post_btn.action = { item in
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
            vc.title = "Create Post"
            let navigationControlr = UINavigationController(rootViewController: vc)
            navigationControlr.modalPresentationStyle = .fullScreen
            self.present(navigationControlr, animated: true, completion: nil)
        }
        
        let album_btn = floatBtn.addItem()
        post_btn.accessibilityLabel = "Create Album"
        album_btn.isAccessibilityElement = true
        
        album_btn.titleLabel.text = "Create Album"
        album_btn.imageView.image = #imageLiteral(resourceName: "image")
        album_btn.buttonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        album_btn.buttonImageColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        album_btn.action = { item in
        
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
            vc.title = "Create Album"
            let navigationControlr = UINavigationController(rootViewController: vc)
            navigationControlr.modalPresentationStyle = .fullScreen
            self.present(navigationControlr, animated: true, completion: nil)
        }
        floatBtn.display(inViewController: self)
    }
    
    func AddNavLeftRightButtonItem(){
        if NetworkController.front_user_id != "0"{
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let imageview = UIImageView(frame: CGRect(x: 8, y: 5, width: 34, height: 34))
            imageview.contentMode = UIView.ContentMode.scaleAspectFill
            imageview.layer.borderColor = UIColor.white.cgColor
            imageview.layer.masksToBounds = true
            imageview.accessibilityIdentifier = "profile"
            imageview.isAccessibilityElement = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            imageview.addGestureRecognizer(tapGesture)
            imageview.isUserInteractionEnabled = true
            
            containView.addSubview(imageview)
            let rightBarButton = UIBarButtonItem(customView: containView)
            self.navigationItem.rightBarButtonItem = rightBarButton
            if let img = dic!["user_image"]{
                NetworkController.user_image = img as! String
                imageview.layer.cornerRadius = 17
                imageview.layer.borderWidth = 0.5
                
            }else{
                imageview.image = #imageLiteral(resourceName: "logo_1")
                return
            }
//            if NetworkController.user_image != ""{
//                let res = ImageResource(downloadURL:  URL(string: NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! , cacheKey: NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
//                imageview.kf.indicatorType = .activity
//                imageview.kf.setImage(with: res)
//            }
            ImageDownloader.default.downloadImage(with: URL(string: NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) {(result) in
                switch result{
                case .success(let val):
                    imageview.image = val.image
                case .failure(let err):
                    print("\(err)")
                }
            }
            
            
        }else{
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let imageview = UIImageView(frame: CGRect(x: 8, y: 2, width: 34, height: 34))
            imageview.image = #imageLiteral(resourceName: "logo_1")
//            imageview.layer.borderWidth = 0.5
//            imageview.layer.borderColor = UIColor.white.cgColor
            imageview.contentMode = UIView.ContentMode.scaleAspectFill
            imageview.layer.cornerRadius = 17
            imageview.layer.masksToBounds = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            imageview.addGestureRecognizer(tapGesture)
            imageview.isUserInteractionEnabled = true
            
            containView.addSubview(imageview)
            let rightBarButton = UIBarButtonItem(customView: containView)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    ///Right Image Object Navigation
    @objc func imageTapped(_ sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        weak var vc = storyboard.instantiateInitialViewController() as? SettingsViewController
        self.tabBarController?.tabBar.isHidden = true
        vc?.modalPresentationStyle = .overCurrentContext

        vc?.delegate = self
        self.present(vc!, animated: true)
    }
    
}

//MARK: Float and sharing Bar extension
extension NewFeedsViewController{
    ///Login sign up Bar....
    
    @IBAction func signinBtn(_ sender : ButtonY){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        weak var vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? UINavigationController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc! , animated: true, completion: nil)
    }
    
    @IBAction func signupBtn (_ sender : ButtonY){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        weak var vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as? UINavigationController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc! , animated: true, completion: nil)
    }
    
    @IBAction func closeShare(_ sender : ButtonY){
        self.shareRef.snp.updateConstraints { [weak self] (make) in
            make.height.equalTo(0)
            self!.shareRef.isHidden = true
        }
        
    }
    
    @objc func shareRef(_ sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReferralVC") as? ReferralVC
        vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension NewFeedsViewController : SettingsViewControllerDelegate{
    func closed() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

//MARK: tabBar controller
extension NewFeedsViewController : UITabBarControllerDelegate {
   
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? NewFeedsViewController {
                
                if vc.isViewLoaded && (vc.view.window != nil) {
                    // viewController is visible
                    vc.tableView.setContentOffset(.zero, animated: true)
                }
            }
        }else{
        }
        
        previousController = viewController
        return true
    }
}

//MARK: - TableView Delegate and DataSource
extension NewFeedsViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.postData.count > 0 {
                return self.postData.count
            }else{
                return 0
            }
        }else if section == 1 && load_more{
            return  0
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.postData.count > 0 {
            let feed = tableView.dequeueReusableCell(withIdentifier: Feed_Cell.identifier, for: indexPath) as! Feed_Cell
            feed.isAccessibilityElement = true
            feed.accessibilityIdentifier = "cell_no_\(indexPath.row)"
            feed.configureCell(cellData: self.postData[indexPath.row], index: indexPath.row)
            feed.delegate = self
            return feed
        }else{
            let suggestCell = tableView.dequeueReusableCell(withIdentifier: "suggestTableCell", for: indexPath) as! SuggestedTableViewCell
            suggestCell.delegate = self
            suggestCell.ConfigureSuggestions(suggestedUsers: Guides.suggestedUsers)
            return suggestCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
        if indexPath.row == self.postData.count - 1 && self.load_more == false{
            self.tableView.tableFooterView = self.LazyLoader()
            self.tableView.tableFooterView?.isHidden = false
            let index = self.postData.count - 1
            LoadMoreData(other_front_user: "0", last_post_id: self.postData[index].id!)

        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
}

//MARK: FeedCell Delegate....
extension NewFeedsViewController : Feed_CellDelegate{
    func delete(index : Int){
        let indexPath =  IndexPath(row: index, section: 0)
        self.postData.remove(at: index)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func share(post: SocialPost) {
        self.postData.insert(post, at: 0)
    }
    
    func push(VC: UIViewController) {
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func present(VC: UIViewController) {
        self.present(VC, animated: true, completion: nil)
    }
    
    func update(count: CountUpdate) {
        if count.type == "tag"{
            self.postData[count.index].tags_count! = count.count
        }else if count.type == "like"{
            self.postData[count.index].favourite_id = count.favID!
            self.postData[count.index].feed_favourites = "\(count.count ?? 0)"
        }else if count.type == "commentLike"{
            if count.count == 0{
                self.postData[count.index].comment!.first?.is_favorite = "no"
            }else{
                self.postData[count.index].comment!.first?.is_favorite = "yes"
            }
            
        }else{
            if count.comment != nil {
                if self.postData[count.index].comment != nil && self.postData[count.index].comment!.count == 0{
                    self.postData[count.index].comment!.insert(count.comment!, at: 0)
                }else{
                    self.postData[count.index].comment!.insert(count.comment!, at: 0)
                }
                self.postData[count.index].feed_comments! = String(count.count)
            }else{
                self.postData[count.index].feed_comments! = String(count.count)
            }
        }
//        self.tableView.reloadData()
        let indexPath = IndexPath(row: count.index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - API Network Calls
extension NewFeedsViewController {
    
    func LoadMoreData(other_front_user : String , last_post_id : String){
        
        self.load_more = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(other_front_user)",
            "feed_id" : "\(last_post_id)",
            "hashtag" : "",
            "my_id" : "\(NetworkController.front_user_id)"
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .LoadMorePosts){ [weak self] response,_ in
            
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["data"]
                    for post in resp{
                        let data = SocialPost(postJSON: post.1)
                        self!.postData.append(data)
                        print(" Name : \(data.first_name!) \(data.last_name!), ID:  \(data.user_id!)")
                        
                    }
                    self?.load_more = false
                     self?.tableView.tableFooterView?.isHidden = true
                    self?.tableView.reloadData()
                    
                }else{
                    self?.load_more = false
                    self?.tableView.tableFooterView?.isHidden = true
                }
            }else{
                self?.load_more = false
                self?.tableView.tableFooterView?.isHidden = true
            }
        }
        
        
    }
    
    //MARK: RefreshFeeds
    func Refresh_Feeds(front_user_id : String) {
        if InternetAvailabilty.isInternetAvailable(){
            self.postData.removeAll()
            let parameters : [String: Any] = [
                "front_user_id" : "\(front_user_id)",
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .SocialPosts){ [weak self] response,_ in
                
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        let resp = response["result"]["data"]
//                        self?.postData.append(contentsOf: resp.array)
                        for post in resp{
                            let data = SocialPost(postJSON: post.1)
                            self!.postData.append(data)
                        }
                        self?.refreshControl.endRefreshing()
                        self?.tableView.reloadData()
                        
                    }
                    else {
                        self?.refreshControl.endRefreshing()
                        let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    self?.refreshControl.endRefreshing()
                    let alert =  UIAlertController(title : "Something went wrong. Please try again." , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
        
        
    }

    //MARK: SocialPosts
    func SocialPosts(front_user_id : String) {
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "front_user_id" : "\(front_user_id)",
            ]
            
            NetworkController.shared.Service(parameters: parameters, nameOfService: .SocialPosts){ [weak self]  response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        let resp = response["result"]["data"]
                        for post in resp{
                            let data = SocialPost(postJSON: post.1)
                            self?.postData.append(data)
                        }
                        if (self?.postData.count)! <= 0{
                            self?.Suggested()
                        }
                        self?.fetch_Search_Guides()
                        self?.tableView.reloadData()
                        self?.removeActivityLoader()
                    }else{
                        self?.removeActivityLoader()
                        self?.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                    }
                }else{
                    self?.removeActivityLoader()
                    self?.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
        
    }
    
    
    func Suggested(){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UserSuggestions){ [weak self]  response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["user_suggestions"]
                    Guides.suggestedUsers.removeAll()
                    for user in resp{
                        let data = Suggested_User(suggestedJSON: user.1)
                        Guides.suggestedUsers.append(data)
                    }
                }else{
                    self?.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self?.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }

    func Share(postid : String, caption : String, post : SocialPost){
        if InternetAvailabilty.isInternetAvailable(){
            let parameters : [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "post_id" : "\(postid)",
                "type" : "post",
                "share_caption" : "\(caption)"
            ]
            NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){[weak self] response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
                        self?.postData.insert(post, at: 0)
                        let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared", preferredStyle :UIAlertController.Style.alert )
                        alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                        self?.present(alert, animated: true, completion: nil)
                    }else{
                        self?.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                    }
                }else{
                    self?.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
    
    //MARK: Search Guides...
    func fetch_Search_Guides(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SearchGuides){ [weak self] response,_ in
            if response != JSON.null {
                
                if response["result"]["status"].boolValue == true {
                    let searchDataResp = response["result"]["comments"]
                    Guides.Users.removeAll()
                    for post in searchDataResp{
                        let data = SearchGuides(searchGuides: post.1)
                        Guides.Users.append(data)
                    }
                    Guides.Users = Guides.Users.sorted(by: { $0.first_name! < $1.first_name! })
                    self?.removeActivityLoader()
                    
                }else{
                    self?.removeActivityLoader()
                    self?.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self?.removeActivityLoader()
                self?.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
        
    }

}

//MARK: Suggested User
extension NewFeedsViewController : SuggestedTableViewCellDelegate{
    func pushController(withNavigation viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}
