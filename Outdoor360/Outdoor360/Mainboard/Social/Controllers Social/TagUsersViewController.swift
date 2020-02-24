//
//  TagUsersViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 05/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import  SwiftyJSON
import  Kingfisher


protocol TagDelegate {
    func TagCount(count : Int, index : Int)
}


class TagUsersViewController: UIViewController {
    
    
    
    var delegate : TagDelegate?
    
    // IBOutlets...!
    
    @IBOutlet weak var add_tag: UIBarButtonItem!
    @IBOutlet weak var close : UIBarButtonItem!
    @IBOutlet weak var no_tags: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tag_index : Int!
    @IBOutlet var loaderView: UIView!
    // Variables.....!
    
    var post_id : String = ""
    var taggedUser : [TaggedUsers] = [TaggedUsers]()
    var myRes : JSON = JSON.null
    var type : String?
    var photo_id : String = ""
    
    
    //Post, Album and photo Tags
    var album : ALbumDetail!
    var photo : Photo!
    var post : SocialPost!
    var index : Int!
    
    
    //Back button Check
    var content_type : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        if self.album != nil{
            if  NetworkController.front_user_id == "0" || self.album?.front_user_id! != NetworkController.front_user_id {
                self.add_tag.isEnabled = false
            }
        }else if self.post != nil {
            if  NetworkController.front_user_id == "0" || self.post?.user_id! != NetworkController.front_user_id {
                self.add_tag.isEnabled = false
            }
        }else if self.photo != nil{
            if NetworkController.front_user_id == "0" || self.photo?.front_user_id! != NetworkController.front_user_id {
                self.add_tag.isEnabled = false
            }
        }
        
        if self.content_type == "photo"{
            self.navigationItem.leftBarButtonItems = [close]
        }else{
            self.navigationItem.leftBarButtonItem = nil
        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.taggedUser.removeAll()
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
        if self.photo != nil{
            self.TaggedUser(type: self.photo.type!, id: self.photo.id!)
        }else if self.post != nil{
            self.TaggedUser(type: "post", id: self.post.id!)
        }else if self.album != nil{
            self.TaggedUser(type: "post", id: self.album.id!)
        }
        
//        if NetworkController.front_user_id == "0" && post.user_id! != NetworkController.front_user_id{
//            self.add_tag.isEnabled = false
//        }else{
//            self.add_tag.isEnabled = true
//        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.content_type == "photo"{
            self.delegate?.TagCount(count: self.taggedUser.count , index: self.index)
        }else if self.content_type == "post"{
            self.delegate?.TagCount(count: self.taggedUser.count , index: self.index)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add_more"{
            let nav = segue.destination as! UINavigationController
            let VC : TagMorePopup = nav.topViewController as! TagMorePopup
            
            VC.tagUser = self.taggedUser
            VC.type = self.type
            VC.photo = self.photo
            VC.post = self.post
            VC.album = self.album
        
        }
    }
 
    @IBAction func Close_Btn(_ sender: UIBarButtonItem) {
        
        if self.content_type == "photo"{
            self.delegate?.TagCount(count: self.taggedUser.count , index: self.index)
            dismiss(animated: false)
        }
        
    }
    
    @IBAction func Tag_Users(_ sender: Any) {
        self.performSegue(withIdentifier: "add_more", sender: self)
        
    }
    
    @objc func deleteTag(sender: UIButton){
        
        self.index = sender.tag
        print(self.taggedUser[sender.tag].front_user_id! + " " + self.post_id)
        
        if self.photo != nil{
            self.DeleteTag(post_id: self.photo.id!, user_id: self.taggedUser[sender.tag].front_user_id!, type: self.photo.type!)
        }else if self.post != nil{
            self.DeleteTag(post_id: self.post.id!, user_id: self.taggedUser[sender.tag].front_user_id!, type: "post" )
        }else if self.album != nil{
            self.DeleteTag(post_id: self.album.id!, user_id: self.taggedUser[sender.tag].front_user_id!, type: "post")
        }
        
        if let superview = sender.superview {
            if let cell = superview.superview as? TagTableViewCell {
                if let indexPath = self.tableView.indexPath(for: cell){
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                    self.taggedUser.remove(at: self.index)
                    self.tableView.endUpdates()
                }
            }
        }
        
        
    }
    
    @objc func TappedUser(sender : UITapGestureRecognizer){
        
        print(sender.view?.tag)
//        if NetworkController.front_user_id != self.post.user_id!{
//            NetworkController.others_front_user_id = self.taggedUser[tag_index!].front_user_id!
//        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TagUsersViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.taggedUser.count == 0{
            self.tableView.isHidden = true
            self.no_tags.isHidden = false
            return 0
        }else{
            self.tableView.isHidden = false
            self.no_tags.isHidden = true
            return self.taggedUser.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TagTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TagTableViewCell
        
        cell.name.text = "\(self.taggedUser[indexPath.row].first_name!) \(self.taggedUser[indexPath.row].last_name!)"
//        let tapName = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
//        tapName.view?.tag = indexPath.row
//        cell.name.isUserInteractionEnabled = true
//        cell.name.addGestureRecognizer(tapName)
        
        let resource = ImageResource(downloadURL: URL(string: (self.taggedUser[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.taggedUser[indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        cell.profileImag.kf.indicatorType = .activity
        cell.profileImag.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholderImage"))
        
        //Tap Guesture to go on the profile....
//        let tapProfileImg = UITapGestureRecognizer(target: self, action: #selector(TappedUser(sender:)))
//        tapName.view?.tag = indexPath.row
//        cell.profileImag.isUserInteractionEnabled = true
//        cell.profileImag.addGestureRecognizer(tapProfileImg)
        
        if NetworkController.front_user_id != "0"{
            if self.album != nil{
                if self.album?.front_user_id! == NetworkController.front_user_id {
                    cell.delete_Btn.isHidden = false
                }else{
                    cell.delete_Btn.isHidden = true
                }
            }else if self.post != nil {
                if self.post?.user_id! == NetworkController.front_user_id {
                    cell.delete_Btn.isHidden = false
                }else{
                    cell.delete_Btn.isHidden = true
                }
            }else if self.photo != nil{
                if self.photo?.front_user_id! == NetworkController.front_user_id {
                    cell.delete_Btn.isHidden = false
                }else{
                    cell.delete_Btn.isHidden = true
                }
            }
            cell.delete_Btn.tag = indexPath.row
            cell.delete_Btn.addTarget(self, action: #selector(deleteTag(sender:)), for: .touchUpInside)
        }else{
            cell.delete_Btn.isHidden = true
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if NetworkController.front_user_id != self.taggedUser[indexPath.row].front_user_id!{
            NetworkController.others_front_user_id = self.taggedUser[indexPath.row].front_user_id!
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// API Calls

extension TagUsersViewController {
    
    //Mark:- Tagged Users
    func TaggedUser (type : String , id : String){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(id)",
            "type" : "\(type)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .TaggedUser){response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    self.myRes = response["result"]["tagged_people"]
                    for post in self.myRes{
                        let data = TaggedUsers(tagJSON: post.1)
                        self.taggedUser.append(data)
                    }
                    self.removeActivityLoader()
                    self.tableView.reloadData()
                    
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

    // Mark:- Delete Tagged User
    
    func DeleteTag(post_id : String!, user_id : String! , type : String!){
     
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(post_id!)",
            "type" : "\(type!)",
            "user" : "\(user_id!)"
        ]
        self.addActivityLoader()
        NetworkController.shared.Service(parameters: parameters , nameOfService: .DeleteTaggedUser){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    self.tableView.reloadData()
                    self.removeActivityLoader()
//                    let alert =  UIAlertController(title : "Tag Deleted Successfully" , message : nil, preferredStyle :UIAlertController.Style.alert )
//                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
//
//                    self.present(alert, animated: true, completion: nil)
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
