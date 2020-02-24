//
//  SearchViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 29/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import JJFloatingActionButton


//Changed : this delegate is removed  , UISearchResultsUpdating
class SearchViewController: UIViewController , UISearchBarDelegate {
    
    //API Variables
    @IBOutlet var loaderView: UIView!
    
    var searchDataResp : JSON = JSON.null
    var searchData : [Photo] = []
    
    var filterGuides : [SearchGuides] = []
    var index : Int = 0
    
    //MARK: Load More Variables
    var isLoadMore : Bool = false
    var sendList : [String] = []
    var previousController: UIViewController?
    // Ends
    
    
    // MARK: Create Post Variables
    let floatBtn = JJFloatingActionButton()
    var createTitle : String!
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView : UICollectionView!
    
    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if NetworkController.front_user_id != "0"{
         AddCreateBtn()
        }
        self.filterGuides = Guides.Users
        fetch_Search_Data()
        
        
        self.tableView.isHidden = true
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search People"
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.placeholder = "Search People"
        searchController.searchBar.text = ""
        self.tabBarController?.delegate = self
        tableView.reloadData()
        if dic != nil{
            if dic!["user_image"] != nil{
                NetworkController.user_image = dic!["user_image"] as! String
            }
        }
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    //MARK: CreatePost Button
    
    func AddCreateBtn(){
        
        
        floatBtn.buttonColor = #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1)
        floatBtn.buttonImageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let post_btn = floatBtn.addItem()
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
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collectionView.isHidden = true
        self.tableView.isHidden = false
        self.filterGuides = Guides.Users
        self.tableView.reloadData()
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.collectionView.isHidden = false
        self.tableView.isHidden = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterGuides = searchText.isEmpty ? Guides.Users : Guides.Users.filter({(dataString: SearchGuides) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.full_name!.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"{
        }else if segue.identifier == "singleImage"{
            let VC = segue.destination as! ShowImageViewController
            VC.photo = self.searchData
            VC.index = self.index
        }
    }

}

//TabbarCOntroller Delegate
extension SearchViewController : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? SearchViewController {
                
                if vc.isViewLoaded && (vc.view.window != nil) {
                    // viewController is visible
                    vc.collectionView.setContentOffset(.zero, animated: true)
                }
            }
        }else{
        }
        previousController = viewController
        return true
    }
}

// TableView Delegates implementation....
extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGuides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchGuideTableViewCell
            let res = ImageResource(downloadURL: URL(string : (filterGuides[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (filterGuides[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.pro_img.kf.indicatorType = .activity
            cell.pro_img.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
            cell.full_name.text = filterGuides[indexPath.row].full_name!
            
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if NetworkController.front_user_id != self.filterGuides[indexPath.row].front_user_id!{
                NetworkController.others_front_user_id = self.filterGuides[indexPath.row].front_user_id!
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
    }
}


// CollectionView Delegates implementation....

extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.searchData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.searchData[indexPath.row].type == "photo" {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let img : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
            
            let process = BlurImageProcessor(blurRadius: 5.0)
            let resource1 = ImageResource(downloadURL: URL(string: (self.searchData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.searchData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            img.kf.indicatorType = .activity
            img.kf.setImage(with: resource1, options : [.processor(process)]) { (result) in
                switch result{
                case .success(let val):
                    let resource2 = ImageResource(downloadURL: URL(string: (self.searchData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.searchData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                    img.kf.indicatorType = .activity
                    img.kf.setImage(with: resource2, placeholder : val.image)
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            return cell
        }else{
            let video = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! VideoCollectionViewCell

//            video.Configure(videoURL: self.searchData[indexPath.row].)
            return video
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.searchData.count - 1 && isLoadMore == false{
            print("Now called...!")
//            self.collectionView.tableFooterView = spinner
//            self.collectionView.?.isHidden = false
            self.isLoadMore = true
            let count_total = String(self.searchData.count)
            self.LoadMore_Search(count_total: count_total, sendlist: self.sendList)
            
           
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "singleImage", sender: self)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let main = UIScreen.main.bounds
        let width = main.width / 3
        let size = CGSize(width: width - 2 , height: width - 2)
        return size
    }
}


//API Calling

extension SearchViewController {

    func fetch_Search_Data(){
        self.addActivityLoader()
        self.searchController.isActive = false
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "last_id" : "",
            "sendlist" : ""
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SearchDataTab){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.searchController.isActive = false
                    self.searchDataResp = response["result"]["search_posts"]
                    for post in self.searchDataResp{
                        let data = Photo(photoData: post.1)
                        self.sendList.append(data.id!)
                        self.searchData.append(data)
                    }
                    self.removeActivityLoader()
                    self.collectionView.reloadData()
                    
                }else{
                    self.searchController.isActive = false
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.searchController.isActive = false
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    
    }
    
    //MARK: Load More Data....
    
    func LoadMore_Search(count_total : String, sendlist : [String]){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "last_id" : "\(count_total)",
            "sendlist" : "\(sendList)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SearchDataTab){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.searchDataResp = response["result"]["search_posts"]
                    for post in self.searchDataResp
                    {
                        let data = Photo(photoData: post.1)
                        self.sendList.append(data.id!)
                        self.searchData.append(data)
                    }
                    
               
                    self.collectionView.reloadData()
                    self.isLoadMore = false
                }else{  
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    
}

