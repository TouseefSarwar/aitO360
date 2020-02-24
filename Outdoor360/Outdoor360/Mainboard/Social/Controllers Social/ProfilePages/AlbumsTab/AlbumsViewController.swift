//
//  AlbumsViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 10/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class AlbumsViewController: UIViewController {
  
    
    //Variables
 
    var albums : [AlbumProfile] = [AlbumProfile]()
    var selectedAlbumIndex : Int!
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var no_album : UILabel!
    
    
    //Updating PhotoCount
    
    var selectedAlbumCount : [Int] = []
    var albumCountArray  : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NetworkController.others_front_user_id != "0"{
            Get_Albums(front_user_id : NetworkController.others_front_user_id)
        }else{
            Get_Albums(front_user_id : NetworkController.front_user_id)
        }
        self.title = "Albums"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "album")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
        if self.selectedAlbumCount.count > 0 {
            collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumPhotos"{
            
           // let nav = segue.destination as! UINavigationController
            let VC : AlbumPhotosViewController = segue.destination as! AlbumPhotosViewController
            VC.album_id  = self.albums[selectedAlbumIndex].id!
            VC.backIndex = self.selectedAlbumIndex
            VC.delegate = self
        }
    }

}

//AlbumPhotoViewController Delegate to updating Counts if anything is changed in album...
extension AlbumsViewController : AlbumPhotosDelegate{
    func Update_Count(count: Int, index: Int) {
        if !self.selectedAlbumCount.contains(index){
            self.selectedAlbumCount.append(index)
            self.albumCountArray.append(count)
        }else{
            let indd = self.selectedAlbumCount.firstIndex(of: index)!
            self.albumCountArray[indd] = count
        }
        self.collectionView.reloadData()
    }
}

//collectionView Delegates and DataSource
extension AlbumsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "album", for: indexPath) as! AlbumCollectionViewCell
        
        
        
        cell.album_title.text = self.albums[indexPath.row].album_title!
        cell.images_count.text = self.albums[indexPath.row].photo_count!

        let resource = ImageResource(downloadURL: URL(string: (self.albums[indexPath.row].photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.albums[indexPath.row].photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: resource)
        if self.selectedAlbumCount.contains(indexPath.row) {
            let ind = self.selectedAlbumCount.firstIndex(of: indexPath.row)
            cell.images_count.text = "\(self.albumCountArray[ind!])"
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedAlbumIndex = indexPath.row
        let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AlbumPhotosViewController") as! AlbumPhotosViewController
        VC.album_id  = self.albums[selectedAlbumIndex].id!
        VC.backIndex = self.selectedAlbumIndex
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
//        performSegue(withIdentifier: "albumPhotos", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let main = UIScreen.main.bounds
        let width = main.width
        let size = CGSize(width: width , height: 220)
        return size
    }
}


// API Calls

extension AlbumsViewController {
    
    func Get_Albums(front_user_id : String){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "last_id" : ""
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserAlbums){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["albums"]
                    for post in resp{
                        let data = AlbumProfile(albumJSON: post.1)
                        self.albums.append(data)
                    }
                    if self.albums.count > 0{
                        self.no_album.isHidden = true
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                    }else{
                        self.no_album.isHidden = false
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

    func LoadMore_Albums(front_user_id : String , last_id : String){
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)",
            "last_id" : "\(last_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ProfileUserAlbums){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["albums"]
                    
                    for post in resp
                    {
                        let data = AlbumProfile(albumJSON: post.1)
                        print(data)
                        self.albums.append(data)
                    }
                    
             
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
    


