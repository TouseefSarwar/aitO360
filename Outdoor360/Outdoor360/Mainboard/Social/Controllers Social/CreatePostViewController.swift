//
//  CreatePostViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 13/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Alamofire
import ReadabilityKit
import SwiftyJSON
import TLPhotoPicker
import Kingfisher
import AVFoundation
import SnapKit

class CreatePostViewController: UIViewController , UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var user_image : ImageViewX!
    @IBOutlet weak var post_caption : UITextView!
    @IBOutlet weak var album_title : UITextField!
    @IBOutlet weak var postTagCount : UILabel!
    @IBOutlet weak var cameraBtn : UIButton!
    
    //Preview Link Outlets...
    @IBOutlet weak var linkView : UIView!
    @IBOutlet weak var linkImage : UIImageView!
    @IBOutlet weak var linkTitle : UILabel!
    @IBOutlet weak var linkDescription : UILabel!
    @IBOutlet weak var linkURL : UILabel!
    @IBOutlet weak var linkClose : UIButton!
    
    
    /// This var is used to send the url of link image in parameter in service call.
    var linkImageURL : String = ""
    
    
    //Variables for tagCount for each Cell..
    var selectedIndex = -1
//    var tagCount = 0
    var selectedTagIndexes : [Int ] = []
    var tagCounts : [Int ] = []
    
    // Variables for Species and Game
    var selectedSpeciesIndex : [Int] = []
    var speciesCount : [Int] = []
    
    var species : [String] = [String]() // Fetched Species from API
    var games : [String] = [String]() // Fetched games from API
    var selected_Images : [PickedImages] = [PickedImages]()
    
    var type : String! // Type to check game or species
    var tag_type : String! // Type to check post tags or photo tags

    
//    
//    @IBOutlet weak var profile_img: ImageViewX!
//    @IBOutlet weak var user_Name: UILabel!
//    @IBOutlet weak var msg_typed_textView: TextViewX!
    var selectedImage: [PickedImages] = [PickedImages]()
    
//    var videoURL : URL?
//    var headerView : CreateHeader!
    var is_album : String = "no"
    
    
    ///parameters for linkpreview...
//    var linkURL : String = ""
//    var linkImage : String = ""
//    var linkDesc : String = ""
//    var linkTitle : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let total = PostUpdateGlobal.post_tags.split(separator: ",")
        self.postTagCount.text  = String(total.count)
        tableView.reloadData()
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PhotoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //MARK: Fetch species and Games
//        GetSpecies()
//        GetGames()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "CreatePostTable"
        
//        headerView = tableView.tableHeaderView as? CreateHeader
//        headerView.delegate = self
        self.post_caption.delegate = self
//        headerView.updateContraintsFor(show: false)
        let dic = UserDefaults.standard.dictionary(forKey: "userInfo")
        if let img  = dic!["user_image"]{
            NetworkController.user_image = img as! String
            let res = ImageResource(downloadURL: URL(string: (NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                self.user_image.kf.indicatorType = .activity
                self.user_image.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
        }
        
        if self.title == "Create Post"{
            self.is_album = "no"
            self.album_title.isHidden = true
        }else{
            self.is_album = "yes"
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choosePhoto"{

        }else if segue.identifier == "popup"{
            let nav = segue.destination as!  UINavigationController
            let vc : PopupViewController = nav.topViewController as! PopupViewController
            vc.delegate = self
            vc.viewType = "CreatePost"
            vc.index = self.selectedIndex
            if self.type == "species"{
//                vc.data = self.species
                vc.title = "Fish"
            }else if self.type == "games"{
                vc.title = "Game"
//                vc.data = self.games
            }
            
        }else if segue.identifier == "add_tag"{
            let nav = segue.destination as!  UINavigationController
            let vc : TagMorePopup = nav.topViewController as! TagMorePopup
            vc.delegate = self
            vc.viewType = "createPost"
            vc.type = self.tag_type
            vc.index = self.selectedIndex
        }
    }


}


//MARK: Tag and species delegates....!

extension CreatePostViewController : TagMoreDelegate , SpeciesDelegates{
    
    func Total_Tag(count: Int!,index : Int) {
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

//MARK: TextView Delegate....!
extension CreatePostViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.post_caption.text == "Whats on your mind..."{
            self.post_caption.text = ""
        }
        self.post_caption.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.post_caption.text == "" {
            self.post_caption.text = "Whats on your mind..."
        }
        self.post_caption.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: textView.text!, options: [], range: NSRange(location: 0, length: textView.text.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: textView.text!) else { continue }
            let url = textView.text![range]
            let str = String(url)
            if str.isValidURL{
                let urlString = URL(string: str)!
                Readability.parse(url: urlString, completion: { data in
                    self.updateContraintsFor(show: true)
                    self.linkURL.text = str
//                    self.linkURL = str
                    if  data?.topImage != "" && data?.topImage != nil {
                        let res = ImageResource(downloadURL: URL(string: (data?.topImage!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)!)
                        self.linkImage.kf.indicatorType = .activity
                        self.linkImage.kf.setImage(with: res)
                        self.linkImageURL = data?.topImage ?? ""
                        
                    }else{
                        self.linkImage.image = #imageLiteral(resourceName: "no_image")
                    }
                    
                    if data?.title != "" && data?.title != nil{
                        self.linkTitle.text = (data?.title)!
//                        self.linkTitle = (data?.title)!
                    }else{
                        self.linkTitle.text = "No Title Available"
                    }
                    if data?.description != "" && data?.description != nil{
                        self.linkDescription.text = (data?.description)!
//                        self.linkDesc = (data?.description)!
                    }else{
                        self.linkDescription.text = "No Description Available"
                    }
                })
                
                break
            }
            
        }
        
        
        return true
    }

}

// Mark : - UITableViewDataSource and Delegates

extension CreatePostViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoCellTableViewCell
     
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = "cell_no_\(indexPath.row)"
        let countT = PostUpdateGlobal.photo_tags[indexPath.row].split(separator: ",")
        cell.tag_lbl.text = "\(countT.count) People Tagged"
        
        let countG = PostUpdateGlobal.g_games[indexPath.row].split(separator: ",")
        let countS = PostUpdateGlobal.g_species[indexPath.row].split(separator: ",")
//        cell.species_lbl.text = "\(countS.count) Fish,\(countG.count) Game"
        cell.species_lbl.text = "\(countS.count + countG.count) Species"
        
        if PostUpdateGlobal.loction[indexPath.row] != ""{
            cell.location_lbl.text = PostUpdateGlobal.loction[indexPath.row]
        }else{
            cell.location_lbl.text = "No Location Specified"
        }
        
        
        cell.ConfigureCell(pickedIamge: self.selectedImage[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            PostUpdateGlobal.g_games.remove(at: indexPath.row)
            PostUpdateGlobal.g_species.remove(at: indexPath.row)
            PostUpdateGlobal.photo_tags.remove(at: indexPath.row)
            PostUpdateGlobal.loction.remove(at: indexPath.row)
            
            self.selectedImage.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
}


extension CreatePostViewController{
    
    @IBAction func CancelBtn(_ sender: Any) {

        let alert = UIAlertController(title: "Discard Post", message: "Do you want to discard?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: {  (Void) in


            TagMorePopup.selectedTags.removeAll()
            PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
            PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
            PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
            PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
            PostUpdateGlobal.post_tags = ""
            PostUpdateGlobal.indx = nil
            
            self.dismiss(animated: true, completion: nil)
        }))
//        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension CreatePostViewController : PhotoCellDelegate{
    
    func performSeguePhoto(identifier: String, type :  String, index: Int) {
        
        if type == "photo"{
            self.tag_type = type
        }else{
            self.type = type
        }
        self.selectedIndex = index
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    func presentPhoto(viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    func setCropedImage(at index: Int, croppedImage: UIImage) {
        self.selectedImage[index].image = croppedImage
        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func returnLocation(item: String, index: Int) {
        if PostUpdateGlobal.loction.first! == "" {
            PostUpdateGlobal.loction[index] = item
            for i in 0..<self.selectedImage.count {
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
//        print(item)
    }
    
    func returnGames(item: String, index: Int) {
        
    }
    
    func returnTags(item: String, index: Int) {
        
    }
}

extension CreatePostViewController : CreateHeaderDelegate{
    func SendPostHeader() {
        
    }
    
    func linkDismissed() {
    }
    
    
    func present(viewController: UIViewController) {
        
    }
    
    func ImagesAssets(data: [TLPHAsset]) {
    }
    
    func PerformSegueHeader(identifier: String, type: String) {
    }
    

    
}

//MARK: Header  Things are here

extension CreatePostViewController : TLPhotosPickerViewControllerDelegate{
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.addActivityLoader()
        
        for i in withTLPHAssets{
            print(i.type)
            if i.type == .video{
                i.exportVideoFile(options: nil, progressBlock: nil, completionBlock: { (url, str) in
                    let video = PickedImages(image: i.fullResolutionImage, url: url.absoluteURL, type: "video")
                    self.selectedImage.append(video)
                })
            }else if i.type == .photo{
                let image = PickedImages(image: i.fullResolutionImage, url: nil, type: "image")
                self.selectedImage.append(image)
            }else{
                let image = PickedImages(image: i.fullResolutionImage, url: nil, type: "image")
                self.selectedImage.append(image)
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.reloadData()
            self.removeActivityLoader()
        }
//        self.tableView.reloadData()
    }
    
    @IBAction func CloseLink(_ sender : UIButton){
        self.updateContraintsFor(show: false)
    }
    
    @IBAction func camera(_ sender: Any) {
        let picker = TLPhotosPickerViewController()

        picker.delegate = self
        var configure = TLPhotosPickerConfigure()

        configure.usedCameraButton = true
        configure.maxSelectedAssets = 10
        configure.allowedLivePhotos = true
        configure.allowedVideo = true
        configure.autoPlay = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tagPeopleInPost(_ sender: Any) {
        self.tag_type = "post"
        self.performSegue(withIdentifier: "add_tag", sender: "post")
    }
    
    @IBAction func send_post(_ sender: Any) {
           
           if self.album_title.text == "" && !self.album_title.isHidden {
               self.presentError(massageTilte: "Please create an album title")
           }else if self.album_title.text != "" && !self.album_title.isHidden {
               if self.selectedImage.count <= 0{
                   self.presentError(massageTilte: "Attach image(s) to create an album")
               }else{
                   SendPost()
               }
           }else if self.post_caption.text == "Whats on your mind..." && self.selectedImage.count == 0 && self.album_title.isHidden{
               self.presentError(massageTilte: "Share your thoughts before posting")
           }else {
               self.SendPost()
           }
       }
    
    func updateContraintsFor(show : Bool){
        if show{
            self.linkView.snp.updateConstraints { (make) in
                make.height.equalTo(70)
                make.top.equalTo(self.post_caption.snp.bottom).offset(8)
            }
            self.linkClose.isHidden = !show
            self.linkURL.isHidden = !show
            self.linkTitle.isHidden = !show
            self.linkImage.isHidden = !show
            self.linkDescription.isHidden = !show
            self.linkView.isHidden = !show
            self.cameraBtn.isEnabled = !show
            
        }else{
            self.linkView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
                make.top.equalTo(self.post_caption.snp.bottom).offset(0)
            }
            self.linkClose.isHidden = !show
            self.linkURL.isHidden = !show
            self.linkTitle.isHidden = !show
            self.linkImage.isHidden = !show
            self.linkDescription.isHidden = !show
            self.linkView.isHidden = !show
            self.cameraBtn.isEnabled = !show
        }
    }
}



extension CreatePostViewController {
 
    func SendPost(){
  
        if self.post_caption.text == "Whats on your mind..." {
            self.post_caption.text = ""
        }

        let parameters: [String: Any] = [
                "front_user_id" : "\(NetworkController.front_user_id)",
            "feed_content" : "\(self.post_caption.text!)",
                "album_title" : "\(self.album_title.text!)",
                "post_tag" : "\(PostUpdateGlobal.post_tags)",
                "photo_tags" : PostUpdateGlobal.photo_tags,
                "species" : PostUpdateGlobal.g_species ,
                "games" :  PostUpdateGlobal.g_games,
                "location":  PostUpdateGlobal.loction,
                "is_album" : "\(self.is_album)",
            "link_url" : self.linkURL.text ?? "",
                "link_desc" : self.linkDescription.text ?? "",
                "link_title" : self.linkTitle.text ?? "",
                "link_image" : self.linkImageURL
                ]

        if InternetAvailabilty.isInternetAvailable(){
            if self.selectedImage.count <= 0{
                self.addActivityLoader()
                NetworkController.shared.Service(parameters: parameters, nameOfService: .PostFeed){ response,_ in
                    
                    if response != JSON.null{
                        if response["result"]["status"].boolValue == true{
                            self.removeActivityLoader()
                            TagMorePopup.selectedTags.removeAll()
                            PostUpdateGlobal.g_species = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.g_games = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.loction = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.photo_tags = Array.init(repeating: "", count: 150)
                            PostUpdateGlobal.post_tags = ""
                            PostUpdateGlobal.indx = nil
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                            tab_Crtl.modalPresentationStyle = .fullScreen
                            self.present(tab_Crtl, animated: true, completion: nil)
                        }else{
                            self.removeActivityLoader()
                            self.presentError(massageTilte: response["result"]["status"].stringValue)
                        }
                    }else{
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "Something went wrong!")
                    }
                }
            }else{
                self.addActivityLoader()
                var returned = false
                let group = DispatchGroup()
                var compressedItem  : [PickedImages] = []
                for (index ,item) in self.selectedImage.enumerated(){
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
                                    print(prog)
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
        
        
    }

}


extension CreatePostViewController{
    
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
