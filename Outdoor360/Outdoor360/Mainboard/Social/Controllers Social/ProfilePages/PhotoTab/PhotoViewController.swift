//
//  PhotoViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 10/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class PhotoViewController: UIViewController {

    
    //Variables....
    var photoData : [Photo] = [Photo]()
    
    //IBOutlets...
    @IBOutlet weak var loaderView : UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var no_data : UILabel!
    
    var selectedIndex : Int = -1
    
    //Variables for load more
    
    var isLoadMore : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        collectionView.dataSource = self
        collectionView.delegate = self
        if NetworkController.others_front_user_id != "0"{
            self.UserPhotos(front_user_id: NetworkController.others_front_user_id)
        }else{
            self.UserPhotos(front_user_id: NetworkController.front_user_id)
        }
        self.title = "Photos"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showImage"{
        }else if segue.identifier == "singleImage"{
            let VC = segue.destination as! ShowImageViewController
            VC.photo = self.photoData
            VC.index = self.selectedIndex
        }
    }
    
}


extension PhotoViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnCount = 0
        
        if self.photoData.count > 0{
            returnCount = self.photoData.count
        }else{
            returnCount = 0
        }
        return returnCount
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let img : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let process = BlurImageProcessor(blurRadius: 5.0)
        let resource1 = ImageResource(downloadURL: URL(string: (self.photoData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.photoData[indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        img.kf.indicatorType = .activity
        img.kf.setImage(with: resource1, options : [.processor(process)]) { (result) in
            switch result{
            case .success(let val):
                let resource2 = ImageResource(downloadURL: URL(string: (self.photoData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.photoData[indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                img.kf.indicatorType = .activity
                img.kf.setImage(with: resource2, placeholder : val.image)
                
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let main = UIScreen.main.bounds
        let width = main.width / 3
        let size = CGSize(width: width - 2 , height: width - 2)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.photoData.count - 1 && isLoadMore == false {
            self.isLoadMore = true
//            print(self.photoData[self.photoData.count - 1].id!)
            if NetworkController.others_front_user_id == "0"{
//                print(NetworkController.others_front_user_id)
                if self.photoData.count > 0{
                    self.LoadMore_User_Photos(front_user_id : NetworkController.front_user_id , last_id: String(self.photoData.count))
                }
            }else{
                if self.photoData.count > 0{
                   self.LoadMore_User_Photos(front_user_id: NetworkController.others_front_user_id , last_id: String(self.photoData.count))
                }
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.photoData[indexPath.row].type == "photo"{
            selectedIndex = indexPath.row
            performSegue(withIdentifier: "singleImage", sender: self)

        }
    }
}

//API Calls
extension PhotoViewController{
    
    func UserPhotos(front_user_id : String){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "last_id" : "",
            "photo_id" : "0"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserPhotos){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["photos"]
                    for post in resp{
                        let data = Photo(photoData: post.1)
                        self.photoData.append(data)
                    }
                    if self.photoData.count > 0{
                        self.no_data.isHidden = true
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                    }else{
                        self.no_data.isHidden = false
                        self.collectionView.isHidden = true
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
    
    
    //MARK: Load More...!
    func LoadMore_User_Photos(front_user_id : String ,last_id : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "last_id" : "\(last_id)",
            "photo_id" : "0"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserPhotos){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["photos"]

                    for post in resp{
                        let data = Photo(photoData: post.1)
                        self.photoData.append(data)
                    }
                    self.isLoadMore = false
                    self.collectionView.reloadData()
                }else{
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
        
    }
    
}


