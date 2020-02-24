//
//  TagMorePopup.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 11/08/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import  Kingfisher


protocol TagMoreDelegate {
    func Total_Tag(count : Int!,index : Int)
}

class TagMorePopup: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var loaderView: UIView!
    
    //Variables
    var followerDataResp : JSON = JSON.null
    var followrs : [SearchGuides] = [SearchGuides]()
    var filterFollowers : [SearchGuides] = [SearchGuides]()
    var isSearching : Bool = false
    var delegate : TagMoreDelegate?
    var index : Int!
    // Array from Tag list...
    var tagUser : [TaggedUsers] = [TaggedUsers]()
    
    
    //editing for album
    var album : ALbumDetail? = nil
    //end editing
    var photo : Photo? = nil
    var post : SocialPost? = nil
    
    //Create Post
    var type : String?
    var viewType : String?
    
    
    static var selectedTags : [String] = [String]()
    
    var s_Tags : [String] = []
    var isLoadMore : Bool = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TagPeople(front_user_id: NetworkController.front_user_id)
        self.tableView.register(UINib(nibName: "CellFollower", bundle: nil), forCellReuseIdentifier: "cell")
        searchBar.delegate = self
        self.tableView.allowsMultipleSelection = true
        tableView.keyboardDismissMode = .onDrag
        
        if viewType == "createPost"{
            if self.type == "post" {
                self.title = "Post Tags"
                let p_tag = PostUpdateGlobal.post_tags.split(separator: ",")
                for item in p_tag{
                    self.s_Tags.append(String(item))
                }
            }else{
                self.title = "Photo Tags"
                let ph_tag = PostUpdateGlobal.photo_tags[index!].split(separator: ",")
                for i in ph_tag{
                     self.s_Tags.append(String(i))
                }
            }
        }else if viewType == "album"{
            self.title = "Photo Tags"
            let ph_tag = PostUpdateGlobal.photo_tags[index!].split(separator: ",")
            for i in ph_tag{
                self.s_Tags.append(String(i))
            }
        }else{
            for i in 0..<self.tagUser.count{
                self.s_Tags.append(self.tagUser[i].front_user_id!)
            }
        }

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    
    @IBAction func AddTag_btn(_ sender: UIBarButtonItem) {
        if self.viewType == "createPost"{
            if self.type == "post" {
                for item in self.s_Tags{
                    if PostUpdateGlobal.post_tags == "" {
                        PostUpdateGlobal.post_tags =  item
                    }else{
                        if !PostUpdateGlobal.post_tags.contains(item){
                            PostUpdateGlobal.post_tags = PostUpdateGlobal.post_tags + "," + item
                        }
                    }
                }
            }else{
                
                let str = self.s_Tags.joined(separator: ",")
                PostUpdateGlobal.photo_tags[index!] = str
                self.delegate?.Total_Tag(count: self.s_Tags.count,index: self.index)
            }
            self.dismiss(animated: true, completion: nil)
        }else if self.viewType == "album"{
            let str = self.s_Tags.joined(separator: ",")
            PostUpdateGlobal.photo_tags[index!] = str
            self.delegate?.Total_Tag(count: self.s_Tags.count,index: self.index)
            self.dismiss(animated: true, completion: nil)
        }else{
            
            if self.photo != nil {
                self.type = "photo"
                Add_Tags(id: self.photo!.id!)
                
            }else if self.post != nil{
                self.type = "post"
                Add_Tags(id: self.post!.id!)
            }else if self.album != nil{
                self.type = "post"
                Add_Tags(id: self.album!.id!)
            }
            
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
}

//MARK:

extension TagMorePopup : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         print("begin")
        self.searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         print("ends")
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if self.searchBar.text == nil || searchBar.text == "" {
//            isSearching = false
//            // to dismiss keyboard
//            view.endEditing(true)
//            self.tableView.reloadData()
//        }else{
//            isSearching = true
////            let lower = self.searchBar.text!.lowercased()
//            print(self.followrs.count)
//            filterFollowers = self.followrs.filter({ (guides) -> Bool in
//                print(guides.first_name!)
//                print(searchText)
//                return (guides.first_name?.lowercased().contains(searchText))!
//            })
//            print(filterFollowers.count)
//            self.tableView.reloadData()
//        }
//
        
//         guard  !searchText.isEmpty else {
//            self.filterFollowers = self.followrs
//            self.tableView.reloadData()
//            return
//        }
//        filterFollowers = followrs.filter({ (guides) -> Bool in
//            (guides.first_name?.contains(searchText))!
//        })
        
        filterFollowers = searchText.isEmpty ? followrs : followrs.filter({(dataString: SearchGuides) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.full_name!.range(of: searchText, options: .caseInsensitive) != nil
        })
        
//        filterFollowers = followrs.filter { $0.first_name!.range(of: searchText, options: .caseInsensitive) != nil}
        if self.searchBar.text == nil || searchBar.text == "" {
//            isSearching = false
            view.endEditing(true)
            self.tableView.reloadData()
        }else{
            isSearching = true
            self.tableView.reloadData()
        }
        
//
//        filterFollowers = followrs.filter({$0.first_name!.prefix(searchText.count) == searchText})
//
//        if self.searchBar.text == nil || searchBar.text == "" {
//            isSearching = false
//            // to dismiss keyboard
//            view.endEditing(true)
//            self.tableView.reloadData()
//        }else{
//        isSearching = true
//            self.tableView.reloadData()
//
//        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
}


//MARK: PhotoCellDelegate

extension TagMorePopup : UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
             return self.filterFollowers.count
            
        }else{
            return self.followrs.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellFollower
        if isSearching{
            cell.Configure(cellData: filterFollowers[indexPath.row], selected_tags: self.s_Tags)
           
            if s_Tags.contains(filterFollowers[indexPath.row].front_user_id!)
            {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
           cell.isSearching = self.isSearching
            
            
        }else{
            
            cell.Configure(cellData: followrs[indexPath.row], selected_tags: self.s_Tags)
            if s_Tags.contains(followrs[indexPath.row].front_user_id!)
            {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            cell.isSearching = self.isSearching
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == self.followrs.count - 1 && !self.isLoadMore{
//            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//            spinner.startAnimating()
//            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//            self.tableView.tableFooterView = spinner
//            self.tableView.tableFooterView?.isHidden = false
//            self.LoadMoreData(last_id : "\(self.followrs.count)")
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching{
            if s_Tags.contains(filterFollowers[indexPath.row].front_user_id!){
                let index = self.s_Tags.firstIndex(of: self.filterFollowers[indexPath.row].front_user_id!)
                if PostUpdateGlobal.post_tags.contains(s_Tags[index!]){
                   PostUpdateGlobal.post_tags.removeAll()
                }
                self.s_Tags.remove(at: index!)
                self.tableView.reloadData()
                
            }else{
                self.s_Tags.append(filterFollowers[indexPath.row].front_user_id!)
                self.tableView.reloadData()
            }
            
        }else{
            
            if s_Tags.contains(self.followrs[indexPath.row].front_user_id!){
                
                let index = self.s_Tags.firstIndex(of: self.self.followrs[indexPath.row].front_user_id!)
                if PostUpdateGlobal.post_tags.contains(s_Tags[index!]){
                    PostUpdateGlobal.post_tags.removeAll()
                }
                self.s_Tags.remove(at: index!)
                self.tableView.reloadData()
                
            }else{
                self.s_Tags.append(self.followrs[indexPath.row].front_user_id!)
                self.tableView.reloadData()
            }
            
        }
    }

}

//API Calls
extension TagMorePopup {
    
    func TagPeople(front_user_id : String){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SearchGuides){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.followerDataResp = response["result"]["comments"]
                    
                    for post in self.followerDataResp{
                        let data = SearchGuides(searchGuides: post.1)
                        self.followrs.append(data)
                    }
                    self.followrs.removeAll(where: {$0.front_user_id! == NetworkController.front_user_id})
                    for i in  0..<self.tagUser.count {
                        self.followrs.removeAll(where: {$0.front_user_id! == self.tagUser[i].front_user_id})
                    }
                    
                    self.followrs = self.followrs.sorted(by: { $0.first_name! < $1.first_name! })
                    self.tableView.reloadData()
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
    
    func Add_Tags(id : String){
        
        var users = ""
        for item in self.s_Tags{
            if users == ""{
                users =  item
            }else{
                 users = users + "," + item
            }
        }
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(id)",
            "type" : "\(self.type!)",
            "users" : "\(users)"
        ]
        self.addActivityLoader()
        NetworkController.shared.Service(parameters: parameters, nameOfService: .AddTaggedUsers){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.removeActivityLoader()
                    self.dismiss(animated: true, completion: nil)
                    
                    
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

}
