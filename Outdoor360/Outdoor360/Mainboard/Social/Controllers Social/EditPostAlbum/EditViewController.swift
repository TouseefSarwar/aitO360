//
//  EditViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 04/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher
import Alamofire
import SwiftyJSON
import SnapKit
import TLPhotoPicker

class EditViewController: UIViewController {
 
    @IBOutlet weak var albumTitle : UITextField!
    @IBOutlet weak var caption : TextViewX!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var no_photos_yet : UILabel!
    @IBOutlet weak var add_btn : UIButton!
    //Loaders..... Progress etc
    @IBOutlet var loader: UIView!
    @IBOutlet var progressLoader: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    /// Flag for deleted item or not....
    static var isDelete : Bool = false
    
    //variables for collectionView Data and caption and title of Album...
    
    var detail : ALbumDetail?
    var old_photos : [Photo] = []
    var post : SocialPost?
    var indexToDelete : Int = -1
    
    //Variables For TableView.....
    var newImages : [PickedImages] = []


    // Variables to edit.....
    var sg_type : String!
    var species : [String] = []
    var game : [String] = []
    var selectedIndex : Int!
    
    
    // Tag and species updating count
    var selectedTagIndexes : [Int ] = []
    var tagCounts : [Int ] = []
    var selectedSpeciesIndex : [Int] = []
    var speciesCount : [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetSpecies()
        GetGames()
        self.caption.dataDetectorTypes = .all
        if self.post != nil{
            self.title = "Edit Post"
            
            
            if self.post?.is_shared == "yes"{
                self.add_btn.isEnabled = false
                self.albumTitle.isEnabled = false
                self.caption.text = self.post?.share_caption!
            }else{
                self.add_btn.isEnabled = true
                self.albumTitle.isEnabled = true
                self.caption.text = self.post?.feed_content!
            }
            
            for i in (self.post?.photos)!{
                self.old_photos.append(i)
            }
            if self.post?.is_album == "no"{
                self.albumTitle.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }else{
                self.albumTitle.text = self.post?.album_title!
            }
            
        }else{
            self.caption.text = self.detail?.feed_content!
            self.albumTitle.text = self.detail?.album_title!
        }
        
        tableView.register(UINib(nibName: "PhotoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "E_video_CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
        collectionView.register(UINib(nibName: "E_photo_CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photo")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.NavigationBackBtn()
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    func NavigationBackBtn(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.closeBackButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.Update))
    }
    
   
    
    @objc func closeBackButtonPressed(){
        PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
        PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
        PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
        PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
        PostUpdateGlobal.post_tags = ""
        PostUpdateGlobal.indx = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    // Save Changes Here.... Upload all new things.....
    
    @objc func Update(){
        if self.post == nil {
            self.Save_Changes(post_id: (self.detail?.id)!, share_caption: "", caption: self.caption.text! , is_album : "yes")
            
            
        }else{
            
            if self.post?.is_shared == "yes"{
                self.Save_Changes(post_id: (self.post?.id)!, share_caption: self.caption.text!, caption: "", is_album : (self.post?.is_album!)!)
            }else{
                self.Save_Changes(post_id: (self.post?.id)!, share_caption: "" , caption: self.caption.text!, is_album : (self.post?.is_album!)!)
            }
            
        }
        
    }

    @IBAction func AddPhotoBtn(_ sender : UIButton){
        let picker = TLPhotosPickerViewController()
        
        picker.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = true
        configure.allowedLivePhotos = true
        configure.allowedVideo = true
        configure.autoPlay = true
        configure.singleSelectedMode = true
        configure.maxSelectedAssets = 10
        
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
}


///
extension EditViewController : TLPhotosPickerViewControllerDelegate{
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        for i in withTLPHAssets{
            if i.type == .video{
                i.exportVideoFile(options: nil, progressBlock: nil, completionBlock: { (url, str) in
                    let video = PickedImages(image: i.fullResolutionImage, url: url.absoluteURL, type: "video")
                    self.newImages.append(video)
                })
            }else if i.type == .photo{
                let image = PickedImages(image: i.fullResolutionImage, url: nil, type: "image")
                self.newImages.append(image)
            }else{
                let image = PickedImages(image: i.fullResolutionImage, url: nil, type: "image")
                self.newImages.append(image)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.reloadData()
            self.removeActivityLoader()
        }
    }
}

/// TableView Delegate and DataSource

extension EditViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoCellTableViewCell
        let countT = PostUpdateGlobal.photo_tags[indexPath.row].split(separator: ",")
        cell.tag_lbl.text = "\(countT.count) People Tagged"
        let countG = PostUpdateGlobal.g_games[indexPath.row].split(separator: ",")
        let countS = PostUpdateGlobal.g_species[indexPath.row].split(separator: ",")
        cell.species_lbl.text = "\(countS.count + countG.count) Species"
        if PostUpdateGlobal.loction[indexPath.row] != ""{
            cell.location_lbl.text = PostUpdateGlobal.loction[indexPath.row]
        }else{
            cell.location_lbl.text = "Not Location Specified"
        }
        cell.ConfigureCell(pickedIamge: self.newImages[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
}

// TableViewCell Nib Delegates.....
extension EditViewController : PhotoCellDelegate{
    func setCropedImage(at index: Int, croppedImage: UIImage) {
        self.newImages[index].image = croppedImage
        dismiss(animated: true, completion: nil)
    }
    
    func performSeguePhoto(identifier: String, type: String, index: Int) {
        
        self.selectedIndex = index
        if type == "photo"{
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "add_tag") as? TagMorePopup
            vc?.delegate = self
            vc?.type = type
            vc?.viewType = "album"
            vc?.index = self.selectedIndex
            let navigation = UINavigationController(rootViewController: vc!)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "popup") as? PopupViewController
            vc?.delegate = self
            vc?.index = self.selectedIndex
            if type == "species"{
//                vc?.title = "Species"
//                vc.data = self.species
            }else if type == "games"{
//                vc?.title = "Game"
//                vc.data = self.game
            }
            let navigation = UINavigationController(rootViewController: vc!)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }

    }
    
    func presentPhoto(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func returnLocation(item: String, index: Int) {
        if PostUpdateGlobal.loction.first! == "" {
            PostUpdateGlobal.loction[index] = item
            for i in 0..<self.newImages.count {
                if i != index{
                    PostUpdateGlobal.loction[i] = item
                }
            }
        }else{
            PostUpdateGlobal.loction[index] = item
        }
        self.tableView.reloadData()
    }
    
    func returnSpecies(item: String, index: Int) {
        
    }
    
    func returnGames(item: String, index: Int) {
        
    }
    
    func returnTags(item: String, index: Int) {
        
    }
    
    
}
//Delegates Tag and species.....

extension EditViewController : TagMoreDelegate, SpeciesDelegates {
    func Total_Tag(count: Int!, index: Int) {
        if !self.selectedTagIndexes.contains(index) {
            self.selectedTagIndexes.append(index)
            self.tagCounts.append(count)
        }
        else{
            let indd = self.selectedTagIndexes.firstIndex(of: index)!
            self.tagCounts[indd] = count
        }
        self.tableView.reloadData()
    }
    
    func Total_Games_Species(count: Int, index: Int) {
        
        if !self.selectedSpeciesIndex.contains(index){
            self.selectedSpeciesIndex.append(index)
            self.speciesCount.append(count)
        }else{
            let ind = self.selectedSpeciesIndex.firstIndex(of: index)!
            self.speciesCount[ind] = count
        }
        self.tableView.reloadData()
        
    }
    
    func ChangeOccur() {
        
    }
    
    
}

//....
extension EditViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.old_photos.count <= 0{
            self.collectionView.isHidden = true
            self.no_photos_yet.isHidden = false
            return 0
        }else{
            self.no_photos_yet.isHidden = true
            self.collectionView.isHidden = false
            return self.old_photos.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if self.old_photos[indexPath.row].type! == "photo" {
           let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as! E_photo_CollectionViewCell
            photoCell.index = indexPath.row
            if self.post != nil {
                if self.post?.is_shared! == "yes"{
                    photoCell.delete_Btn.isHidden = true
                }
                else{
                    photoCell.delete_Btn.isHidden = false
                }
            }
            
            photoCell.delegate = self
            let process = BlurImageProcessor(blurRadius: 5.0)
            let resource1 = ImageResource(downloadURL: URL(string: (self.old_photos[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.old_photos[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
            photoCell.img.kf.indicatorType = .activity
            photoCell.img.kf.setImage(with: resource1, options : [.processor(process)]) { (result) in
                switch result{
                case .success(let val):
                    let resource2 = ImageResource(downloadURL: URL(string: (self.old_photos[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.old_photos[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                    photoCell.img.kf.indicatorType = .activity
                    photoCell.img.kf.setImage(with: resource2, placeholder : val.image)
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            return photoCell
        }else {
           let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! E_video_CollectionViewCell
            if self.post != nil {
                if self.post?.is_shared! == "yes"{
                    videoCell.delete_Btn.isHidden = true
                }
                else{
                    videoCell.delete_Btn.isHidden = false
                }
            }
            videoCell.index = indexPath.row
            videoCell.delegate = self
            
            return videoCell
        }
        
    }
    
}

// MARK: Photo Video Delegatesssss.....

extension EditViewController : EditPhotoDelegate, EditVideoDelegate{
    
    func PresentVideo(videoViewController viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func PresentPhoto(photoViewController viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func DeletePhoto(index: Int!) {
        self.DeletePhotos(ids: self.old_photos[index].id!)
        let indexPath = IndexPath(item: index, section: 0)
        self.old_photos.remove(at: index)
        self.collectionView.deleteItems(at: [indexPath])
    }
    
    func DeleteVideo(index: Int!) {
        self.DeletePhotos(ids: self.old_photos[index].id!)
        let indexPath = IndexPath(item: index, section: 0)
        self.old_photos.remove(at: index)
        self.collectionView.deleteItems(at: [indexPath])
    }
}


extension EditViewController{
    
    func DeletePhotos(ids : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(ids)",
            "type" : "photo"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost){response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    EditViewController.isDelete = true
                    self.collectionView.reloadData()
                    let alert =  UIAlertController(title :"Successfully Deleted"  , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    func GetSpecies(){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Species){ response,_ in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["data"]
                    for post in resp
                    {
                        let data = Species_Games(SpeciesGamesResponse: post.1)
                        self.species.append(data.name!)
                    }
                    
                }else{

                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil , preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func GetGames(){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Games){ response,_ in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["data"]
                    for post in resp
                    {
                        let data = Species_Games(SpeciesGamesResponse: post.1)
                        self.game.append(data.name!)
                    }
                    
                }else{
                    //                    self.loaderView.removeFromSuperview()
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                        //                        self.dismiss(animated: true, completion: nil)
                    }))
                    //                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                //                self.loaderView.removeFromSuperview()
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                    //                    self.dismiss(animated: true, completion: nil)
                }))
                //                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func Save_Changes (post_id : String , share_caption : String, caption: String, is_album : String){
       
//        var tit : String?
//        if self.title == "Edit Post"{
//            tit = "Post Edited"
//        }else{
//            tit = "Album Edited"
//        }
        
        
        
        
        // Start
        
        let parameters: [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "album_id" : "\(post_id)",
            "album_title" : "\(self.albumTitle.text!)",
            "share_caption" : "\(share_caption)",
            "feed_content" : "\(caption)",
            "photo_tags" : PostUpdateGlobal.photo_tags,
            "species" : PostUpdateGlobal.g_species ,
            "games" :  PostUpdateGlobal.g_games,
            "location":  PostUpdateGlobal.loction,
            "is_album" : is_album,
        ]
        
        if InternetAvailabilty.isInternetAvailable(){
            if self.newImages.count <= 0{
                let parameter: [String: Any] = [
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "album_id" : "\(post_id)",
                    "album_title" : "\(self.albumTitle.text!)",
                    "share_caption" : "\(share_caption)",
                    "feed_content" : "\(caption)",
                    "photo_tags" : PostUpdateGlobal.photo_tags,
                    "species" : PostUpdateGlobal.g_species ,
                    "games" :  PostUpdateGlobal.g_games,
                    "location":  PostUpdateGlobal.loction,
                    "is_album" : is_album,
                    "image[]" : "",
                    "link_url" : "",
                    "link_desc" : "",
                    "link_title" : "",
                    "link_image" : ""
                ]
                self.addActivityLoader()
                
                NetworkController.shared.Service(parameters: parameter, nameOfService: .PostFeed){ response,_ in
                    
                    if response != JSON.null{
                        self.removeActivityLoader()
                        PostUpdateGlobal.post_tags = ""
                        PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
                        PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
                        PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
                        PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
                        if self.post != nil {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                            tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[0]
                            tab_Crtl.modalPresentationStyle = .fullScreen
                            self.present(tab_Crtl, animated: true, completion: nil)
                        }else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                            tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                            tab_Crtl.modalPresentationStyle = .fullScreen
                            self.present(tab_Crtl, animated: true, completion: nil)
                        }
                        
                    }else{
                        self.removeActivityLoader()
                    }
                }
            }else{
                self.addActivityLoader()
                var returned = false
                let group = DispatchGroup()
                var compressedItem  : [PickedImages] = []
                for (index ,item) in self.newImages.enumerated(){
                    if item.type == "video"{
                        group.enter()
                        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + "\(index).m4v")
                        self.compressVideo(inputURL: item.url!, outputURL: compressedURL, handler: { (handler) -> Void in
                            if handler.status == AVAssetExportSession.Status.completed
                            {
                                do{
                                    _ = try Data.init(contentsOf: compressedURL, options : .mappedIfSafe)
                                    compressedItem.append(PickedImages(image: item.image!, url: compressedURL, type: "video"))
                                    returned = true
                                    group.leave()
                                }catch{ print("Error")}
                                
                            }else if handler.status == AVAssetExportSession.Status.failed{
                                returned = true
                                group.leave()
                            }
                        })
                        
                    }else{
                        compressedItem.append(PickedImages(image: item.image!, url: nil, type: "image"))
                        returned = true
                    }
                    
                }
                group.notify(queue: .main, execute: {
                    if returned{
                        self.removeActivityLoader()
                        self.Uploader()
                        //Edited Code
                        NetworkController.shared.uploadImages(parameters: parameters, imagesToUpload: compressedItem, nameOfService: .PostFeed, onComplition: { (prog, error, isCompleted) in
                            if isCompleted!{
                                self.removeActivityLoader()
                                TagMorePopup.selectedTags.removeAll()
                                PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.post_tags = ""
                                PostUpdateGlobal.indx = nil
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }else{
                                if error == nil{
                                    self.uploaderValue(progressValue: Float(prog!.fractionCompleted))
                                    let prog = Int(prog!.fractionCompleted * 100)
                                    if prog == 100{
                                        self.removeUploader()
                                        self.addActivityLoader()
                                    }
                                }else{
                                    self.removeActivityLoader()
                                    self.presentError(massageTilte: "\(error!.localizedDescription)")
                                }
                            }
                            
                            
                            
                        })
                    }else{
                        self.presentError(massageTilte: " There was a problem compressing the video maybe you can try again later. Error")
                    }
                })
                
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
        
        //End
        /*
        let banner = Banner(title: "\(tit)", subtitle: "\(tit) sucessfully!", image: nil, backgroundColor: #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1) , didTapBlock: nil)
        banner.dismissesOnTap = true
        let banner1 = Banner(title: "Something went wrong", subtitle: "Please try again", image: nil, backgroundColor: #colorLiteral(red: 0.08938013762, green: 0.1059873924, blue: 0.2032674253, alpha: 1) , didTapBlock: nil)
        banner1.dismissesOnTap = true
        
        
        
        
        
        
            let url = "\(NetworkController.shared.baseUrl)post_feed" /* your API url */
            let parameters: [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
                "album_id" : "\(post_id)",
                "album_title" : "\(self.albumTitle.text!)",
                "share_caption" : "\(share_caption)",
                "feed_content" : "\(caption)",
                "photo_tags" : PostUpdateGlobal.photo_tags,
                "species" : PostUpdateGlobal.g_species ,
                "games" :  PostUpdateGlobal.g_games,
                "location":  PostUpdateGlobal.loction,
                "is_album" : is_album,
            ]
            
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data"
            ]
            
            
            if self.newImages.count <= 0{
                let parameter: [String: Any] = [
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "share_caption" : "\(share_caption)",
                    "feed_content" : "\(caption)",
                    "album_id" : "\(post_id)",
                    "album_title" : "\(self.albumTitle.text!)",
                    "photo_tags" : PostUpdateGlobal.photo_tags,
                    "species" : PostUpdateGlobal.g_species ,
                    "games" :  PostUpdateGlobal.g_games,
                    "location":  PostUpdateGlobal.loction,
                    "is_album" : is_album,
                    "image[]" : ""
                ]
                
                
                self.loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(loader)
                Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.httpBody).responseString(){ (response) in
                    
                    switch response.result{
                    case.success(let data):
                        let json = JSON(data)
                        if json != JSON.null{
                            self.loader.removeFromSuperview()
                            PostUpdateGlobal.post_tags = ""
                            PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
                            if self.post != nil {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[0]
                                self.present(tab_Crtl, animated: true, completion: nil)
                            }else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                                self.present(tab_Crtl, animated: true, completion: nil)
                            }
    
                        }else{
                            self.loader.removeFromSuperview()
                            let alert = UIAlertController(title: "\(json["result"]["description"])", message: nil , preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        break
                    case.failure( _):
                        self.loader.removeFromSuperview()
                        break
                    }
                }
            }else{
                self.progressLoader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(progressLoader)
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                    for (index ,img) in self.newImages.enumerated(){
                        
                        if img.type! == "video"{
                            var videoData : Data?
                            do{
                                videoData = try Data.init(contentsOf: img.url!, options : .mappedIfSafe)
                                
                            }catch{ print("Error")}
                            multipartFormData.append(videoData!, withName: "image[]", fileName: "video.mp4", mimeType: "video/mp4")
                            
                        }else{
                            let imgData = img.image.jpegData(compressionQuality: 0.5)!
                            multipartFormData.append(imgData, withName: "image[]", fileName: "image\(index).png", mimeType: "image/png")
                        }
                        
                    }
                    
                }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
                    switch result{
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            
                            self.progressBar.setProgress(Float(Progress.fractionCompleted), animated: true)
                            let prog = Int(Progress.fractionCompleted * 100)
                            self.progressLabel.text = "Uploading...\(prog)%"
                        })
                        
                        upload.responseString{ response in
                            
                            if response.result.value != nil {
                                PostUpdateGlobal.post_tags = ""
                                PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
                                PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
                                banner.show()
                                _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {_ in
                                    self.progressLoader.removeFromSuperview()
                                    banner.dismiss()
                                    if self.post != nil {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                        tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[0]
                                        self.present(tab_Crtl, animated: true, completion: nil)
                                    }else {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                        tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                                        self.present(tab_Crtl, animated: true, completion: nil)
                                    }
                                })
                              
                            }
                        }
                    case .failure(let error):
                        
                        banner1.show()
                        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {_ in
                            self.progressLoader.removeFromSuperview()
                            banner.dismiss()
                        })
                        
                        print("Error in upload: \(error.localizedDescription)")
                    }
                }
            } */
        
    }
}


extension EditViewController{
    
    /// Compressing Video
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void){
        let urlAsset = AVURLAsset(url: inputURL as URL, options: nil)
        
        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
        
        exportSession!.outputURL = outputURL
        
        exportSession!.outputFileType = AVFileType.mov
        
        exportSession!.shouldOptimizeForNetworkUse = true
        
        exportSession!.exportAsynchronously { () -> Void in
            handler(exportSession!)
        }
        
        
    }
    
}


