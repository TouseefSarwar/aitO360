//
//  AlbumPhotosViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 13/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher
//import YPImagePicker

protocol AlbumPhotosDelegate {
    func Update_Count(count : Int , index : Int)
}

class AlbumPhotosViewController: UIViewController {

    var delegate : AlbumPhotosDelegate?
    
    var albumDetailResp : JSON = JSON.null
    var albumPhotoResp : JSON = JSON.null
    
    var albumDetailData : ALbumDetail? = nil
    var albumPhotoData : [Photo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var loaderView: UIView!
    
    
    //MARK: Count variables
    
    var likeCount : String = "0"
    var commentCount : String = "0"
    var tagCount : String = "0"
    
    // ************Deletetion************
    //Selection Variables and Bar Button Variables
    var isSelected = false
    var selectedPhotos : [String] = []
    var cancel : UIBarButtonItem!
    var delete : UIBarButtonItem!
    var unselectAll : UIBarButtonItem!
    
    
    
    //************* [ AddPhoto ] ********
    var imagesToAdd : [UIImage] = []
    
    var album_id : String!
    var index : Int = 0
    var backIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if NetworkController.others_front_user_id != "0"{
            Get_Album(front_user_id: NetworkController.others_front_user_id)
        }else{
             Get_Album(front_user_id: NetworkController.front_user_id)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "AlbumVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "albumVideo")
        collectionView.register(UINib(nibName: "Header", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
        if EditViewController.isDelete {
            self.albumPhotoData.removeAll()
            if NetworkController.others_front_user_id != "0"{
                Get_Album(front_user_id: NetworkController.others_front_user_id)
            }else{
                Get_Album(front_user_id: NetworkController.front_user_id)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if EditViewController.isDelete{
            self.delegate?.Update_Count(count: self.albumPhotoData.count, index: self.backIndex)
            EditViewController.isDelete = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"{
           
        }
        else if segue.identifier == "showTags"{
            let nav = segue.destination as! UINavigationController
            let VC : TagUsersViewController = nav.topViewController as! TagUsersViewController
            VC.type = "post"
            VC.album = self.albumDetailData
            
        }
        else if segue.identifier == "showComments"{
            let nav = segue.destination as! UINavigationController
            let vc : CommentsViewController = nav.topViewController as! CommentsViewController
            
            vc.album = self.albumDetailData
            
//            vc.front_user_id = self.albumDetailData?.user_id!
//            vc.post_id = self.albumDetailData?.original_post_id!
        }else if segue.identifier == "singleImage"{
            let VC = segue.destination as! ShowImageViewController
            VC.photo = self.albumPhotoData
            VC.index = self.index
        }
    }
    
}


// MARK: - CollectionView Delegate And DataSource

extension AlbumPhotosViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumPhotoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.albumPhotoData[indexPath.row].type! == "photo"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumPhotoCollectionViewCell
            
            if isSelected == true{
                
                cell.layer.borderColor = UIColor.blue.cgColor
                cell.selectCell.isHidden = false
                cell.selectCell.image = #imageLiteral(resourceName: "uncheck")
                
                let process = BlurImageProcessor(blurRadius: 5.0)
                let resource1 = ImageResource(downloadURL: URL(string: (self.albumPhotoData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.albumPhotoData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                cell.photo.kf.indicatorType = .activity
                cell.photo.kf.setImage(with: resource1, options: [.processor(process)]) { (result) in
                    switch result {
                    case .success(let val):
                        let resource2 = ImageResource(downloadURL: URL(string: (self.albumPhotoData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.albumPhotoData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                        cell.photo.kf.indicatorType = .activity
                        cell.photo.kf.setImage(with: resource2, placeholder : val.image)
                    case .failure(let error):
                        print(error)
                    }
                }
            }else{
                
                
                let process = BlurImageProcessor(blurRadius: 5.0)
                let resource1 = ImageResource(downloadURL: URL(string: (self.albumPhotoData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.albumPhotoData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                cell.photo.kf.indicatorType = .activity
                cell.photo.kf.setImage(with: resource1, options: [.processor(process)]) { (result) in
                    switch result {
                        case .success(let val):
                            let resource2 = ImageResource(downloadURL: URL(string: (self.albumPhotoData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.albumPhotoData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                            cell.photo.kf.indicatorType = .activity
                            cell.photo.kf.setImage(with: resource2, placeholder : val.image)
                            break
                        case .failure(let error):
                            print(error)
                            break
                    }
                }
                cell.selectCell.isHidden = true
                cell.layer.borderWidth = 0.0
                
            }
            return cell
        }else{
            let video = collectionView.dequeueReusableCell(withReuseIdentifier: "albumVideo", for: indexPath) as! AlbumVideoCollectionViewCell
            
            
            if isSelected == true{
                
                video.layer.borderColor = UIColor.blue.cgColor
                video.selectCell.isHidden = false
                video.selectCell.image = #imageLiteral(resourceName: "uncheck")

                
            }else{
                video.selectCell.isHidden = true
                video.layer.borderWidth = 0.0
                
            }
            return video
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//        switch kind {
//        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! Header
            if self.albumDetailData?.user_image != nil{
                
                headerView.ConfigureHeader(albumDetail: self.albumDetailData!)
                headerView.delegate = self
              
            }
        return headerView

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let main = UIScreen.main.bounds
            let width = main.width / 3
            let size = CGSize(width: width - 2 , height: width - 2)
            return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? Header {
            // Layout to get the right dimensions
            headerView.layoutIfNeeded()
            
            // Automagically get the right height
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
            
        
            // return the correct size
            return CGSize(width: collectionView.frame.width, height: height)
        }
    
        return CGSize(width: self.view.bounds.width, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelected == true{
            if self.albumPhotoData[indexPath.row].type == "photo"{
                let cell = collectionView.cellForItem(at: indexPath) as! AlbumPhotoCollectionViewCell
                cell.layer.borderWidth = 1.5
                cell.layer.borderColor = UIColor.blue.cgColor
                cell.selectCell.isHidden = false
                cell.selectCell.image = #imageLiteral(resourceName: "check")
                self.selectedPhotos.append(self.albumPhotoData[indexPath.row].id!)
                //            self.collectionView.reloadData()
                if self.selectedPhotos.count > 0{
                    delete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(Delete(sender: )))
                    delete.tintColor = UIColor.red
                    
                    unselectAll = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel(sender:)))
                    unselectAll.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    self.navigationItem.rightBarButtonItems = [delete , unselectAll]
                    //                delete.
                    //                self.navigationItem.rightBarButtonItem = delete
                }else{
//                    self.navigationItem.rightBarButtonItem = unselectAll!
                }
            }else{
                let cell = collectionView.cellForItem(at: indexPath) as! AlbumVideoCollectionViewCell
                cell.layer.borderWidth = 1.5
                cell.layer.borderColor = UIColor.blue.cgColor
                cell.selectCell.isHidden = false
                cell.selectCell.image = #imageLiteral(resourceName: "check")
                self.selectedPhotos.append(self.albumPhotoData[indexPath.row].id!)
                //            self.collectionView.reloadData()
                if self.selectedPhotos.count > 0{
                    delete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(Delete(sender: )))
                    delete.tintColor = UIColor.red
                    
                    unselectAll = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel(sender:)))
                    unselectAll.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                    self.navigationItem.rightBarButtonItems = [delete , unselectAll]
                    //                delete.
                    //                self.navigationItem.rightBarButtonItem = delete
                }else{
//                    self.navigationItem.rightBarButtonItem = unselectAll!
                }
            }
            
            
            
        }else{
            index = indexPath.row
//            NetworkController.photo_id = self.albumPhotoData[indexPath.row].id!
//            print(self.albumPhotoData[index])
            performSegue(withIdentifier: "singleImage", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelected == true{
          
            if self.albumPhotoData[indexPath.row].type == "photo" {
                let cell = collectionView.cellForItem(at: indexPath) as! AlbumPhotoCollectionViewCell
                cell.layer.borderWidth = 0.0
                cell.selectCell.image = #imageLiteral(resourceName: "uncheck")
                if let index = self.selectedPhotos.firstIndex(of: self.albumPhotoData[indexPath.row].id!){
                    self.selectedPhotos.remove(at: index)
                    if self.selectedPhotos.count == 0{
                        unselectAll = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel(sender:)))
//                        self.navigationItem.rightBarButtonItem = unselectAll
                    }
                }
            }else{
                let cell = collectionView.cellForItem(at: indexPath) as! AlbumVideoCollectionViewCell
                cell.layer.borderWidth = 0.0
                cell.selectCell.image = #imageLiteral(resourceName: "uncheck")
                if let index = self.selectedPhotos.firstIndex(of: self.albumPhotoData[indexPath.row].id!){
                    self.selectedPhotos.remove(at: index)
                    if self.selectedPhotos.count == 0{
                        unselectAll = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel(sender:)))
//                        self.navigationItem.rightBarButtonItem = unselectAll
                    }
                }
            }
           
            
//            self.collectionView.reloadData()
        }
    }

}


//MARK: Bar Button Actions

extension AlbumPhotosViewController {
    
    @objc func Cancel(sender : UIBarButtonItem){
        isSelected = false
        self.collectionView.reloadSections(IndexSet(0 ..< 1))
        self.selectedPhotos.removeAll()
        self.navigationItem.rightBarButtonItems = nil
    }

    @objc func Delete(sender : UIBarButtonItem){
    
        isSelected = false
        let selectedIDs : String = self.selectedPhotos.joined(separator: ",")
        for i in 0..<self.albumPhotoData.count{
            if selectedPhotos.contains(self.albumPhotoData[i].id!){
                // Remove items from array and also delete with api..
                self.albumPhotoData.remove(at: i)
            }
        }
        self.DeletePhotos(ids: selectedIDs)
        self.navigationItem.rightBarButtonItems = nil
    }
}


//MARK: - More Controls
extension AlbumPhotosViewController : AlbumHeaderDelegate {
    func update(count: CountUpdate) {
        if count.type == "tag"{
          self.albumDetailData?.tagged_count = String(count.count)
        }else{
          self.albumDetailData?.feed_comments = String(count.count)
        }
        self.collectionView.reloadData()
    }
    
    
    func pushAlbum(view: UIViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func AddPhoto() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editAlbum") as? EditViewController
        vc?.old_photos = self.albumPhotoData
        vc?.detail = self.albumDetailData
        let navigation = UINavigationController(rootViewController: vc!)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    func Delete(isSelected: Bool) {
        self.isSelected = isSelected
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.reloadSections(IndexSet(0 ..< 1))
        
    }
    
    func PerformSegue(albumDet : ALbumDetail , identifier : String) {
        performSegue(withIdentifier: identifier, sender: self)
        
    }
    
    func AlertController(alert: UIViewController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShareToYentna(album_id: String, shareCaption: String) {
        self.Share(postid: album_id , caption: shareCaption)
    }
    
    func SocialShare(album_id: String) {
        let num = NetworkController.shared.random(digits: 8)
        
        let activityVC =  UIActivityViewController(activityItems: ["\(NetworkController.shareURL)\(String(num))\(album_id)"], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.mail, UIActivity.ActivityType.message]
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func DismissController(animated : Bool){
        self.dismiss(animated: animated , completion: nil)
    }
    
}

//MARK:API Calls

extension AlbumPhotosViewController {
    
    func Get_Album(front_user_id : String){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "post_id" : "\(self.album_id!)",
            "last_id" : ""
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UserAlbumsPhoto){
            response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.albumDetailResp = response["result"]["album"]
                    let data = ALbumDetail(albumDetail: self.albumDetailResp)
                    self.albumDetailData = data
                    self.albumPhotoResp = response["result"]["photos"]
                    for post in self.albumPhotoResp{
                        let data = Photo(photoData: post.1)
                        self.albumPhotoData.append(data)
                    }
                    
                    self.collectionView.reloadSections(IndexSet(0..<1))
                    self.collectionView.reloadData()
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
    
    func Share(postid : String, caption : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(postid)",
            "type" : "post",
            "share_caption" : "\(caption)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SharePost){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let alert =  UIAlertController(title : "Share Alert" , message : "Successfully Post Shared to Yentna", preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }

    //FIXME: Load More data.
    //MARK: LoadMore Album Photos.
    func LoadMore_Album_Photos(front_user_id : String, post_id : String, last_id : String){
        let parameters : [String: Any] = [
            
            "front_user_id" : "\(front_user_id)",
            "post_id" : "\(self.album_id!)",
            "last_id" : "\(last_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UserAlbumsPhoto){
            response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.albumDetailResp = response["result"]["album"]
                    let data = ALbumDetail(albumDetail: self.albumDetailResp)
                    
//                    print(data.original_post_id!)
                    self.albumDetailData = data
                    self.albumPhotoResp = response["result"]["photos"]
                    print(self.albumPhotoResp)
                    for post in self.albumPhotoResp
                    {
                        let data = Photo(photoData: post.1)
                        print(data)
                        self.albumPhotoData.append(data)
                    }
                    self.collectionView.reloadSections(IndexSet(0..<1))
                    self.collectionView.reloadData()
                    
                }else{
                    self.loaderView.removeFromSuperview()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.loaderView.removeFromSuperview()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    func DeletePhotos(ids : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : "\(ids)",
            "type" : "photo"
        ]
       
        NetworkController.shared.Service(parameters: parameters, nameOfService: .DeletePost){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    self.collectionView.reloadSections(IndexSet(0 ..< 1))
                    let alert =  UIAlertController(title : "Successfully Deleted" , message : "", preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
        
    }
    
}
