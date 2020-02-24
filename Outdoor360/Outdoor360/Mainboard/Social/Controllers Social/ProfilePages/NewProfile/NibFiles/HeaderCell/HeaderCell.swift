//
//  HeaderCell.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 18/10/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import CropViewController

@objc protocol HeaderCellDelegate {
    func push(viewController : UIViewController)
    func present(viewController : UIViewController)
    @objc optional func CropperDelegation(isProfile : Bool, image : UIImage)
}


class HeaderCell: UITableViewCell {

    @IBOutlet weak var userImage : ImageViewX!
    @IBOutlet weak var userButton : UIButton!
    @IBOutlet weak var coverImage : UIImageView!
    @IBOutlet weak var coverButton : UIButton!
    
    @IBOutlet weak var userName : UILabel!
    @IBOutlet weak var followersLabel : UILabel!
    @IBOutlet weak var followersCount : UILabel!
    @IBOutlet weak var followingLabel : UILabel!
    @IBOutlet weak var followingCount : UILabel!
    @IBOutlet weak var postsLabel : UILabel!
    @IBOutlet weak var postsCount : UILabel!
    @IBOutlet weak var about : UILabel!
    @IBOutlet weak var viewMoreAbout : UIButton!
    
    ///This Button is for follow/Following and editProfile.... Condition Basedd....
    @IBOutlet weak var mainButton : ButtonY!
    
    ///Follower Section
    @IBOutlet weak var follower_CV : UICollectionView!
    @IBOutlet weak var viewMoreFollowers : UIButton!
    @IBOutlet weak var noFollowers : UILabel!
    ///Photo Section
    
    @IBOutlet weak var photos_CV : UICollectionView!
    @IBOutlet weak var viewMorePhotos : UIButton!
    @IBOutlet weak var noPhotos : UILabel!
    ///Videos Section
    
    @IBOutlet weak var videos_CV : UICollectionView!
    @IBOutlet weak var viewMoreVideos : UIButton!
    @IBOutlet weak var noVideos : UILabel!
    
    ///Albums Section
    @IBOutlet weak var albums_CV : UICollectionView!
    @IBOutlet weak var viewMoreAlbums : UIButton!
    @IBOutlet weak var noAlbums : UILabel!
    ///Photo Mapss
    @IBOutlet weak var viewMorePhotoMap : UIButton!
    @IBOutlet weak var photoMapImage : UIImageView!
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    weak var delegate : HeaderCellDelegate?
    
    var profileData : ProfileResponse!
    var imagePicker = UIImagePickerController()
    var pickerFlag : Bool = false /// true mean "Pro Image" false for "Cover"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        follower_CV.delegate = self
        follower_CV.dataSource = self

        photos_CV.delegate = self
        photos_CV.dataSource = self

        videos_CV.delegate = self
        videos_CV.dataSource = self

        albums_CV.delegate = self
        albums_CV.dataSource = self
        
        follower_CV.register(UINib(nibName: "FollowersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        photos_CV.registerNib(PhotoCell.self)
        videos_CV.registerNib(VideoCell.self)
        albums_CV.registerNib(AlbumCell.self)
       
    }
    
   

    deinit {
        print("Header Deallocated,,,,")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ConfigureHeader(with profile : ProfileResponse){
        
        self.profileData = profile
        if profile.followers != nil{
            if profile.followers!.count > 0{
                self.noFollowers.isHidden = true
                self.follower_CV.isHidden = false
            }else{
                self.noFollowers.isHidden = false
                self.follower_CV.isHidden = true
            }
        }
        if profile.photos != nil{
            if profile.photos!.count > 0{
                self.noPhotos.isHidden = true
                self.photos_CV.isHidden = false
            }else{
                self.noPhotos.isHidden = false
                self.photos_CV.isHidden = true
            }
        }
        if profile.albums != nil{
            if profile.albums!.count > 0{
                self.noAlbums.isHidden = true
                self.albums_CV.isHidden = false
            }else{
                self.noAlbums.isHidden = false
                self.albums_CV.isHidden = true
            }

        }
        if profile.videos != nil{
            if profile.videos!.count > 0{
                self.noVideos.isHidden = true
                self.videos_CV.isHidden = false
            }else{
                self.noVideos.isHidden = false
                self.videos_CV.isHidden = true
            }
            
            
        }
        
        self.userButton.isHidden = true
        self.coverButton.isHidden = true

        if NetworkController.others_front_user_id == "0" {
            // Tap action to upload user image
            let tapUserImage = UITapGestureRecognizer(target: self, action: #selector(editProfileImage(_:)))
            self.userImage.isUserInteractionEnabled = true
            tapUserImage.numberOfTapsRequired = 1
            self.userImage.addGestureRecognizer(tapUserImage)
            self.userButton.isHidden = false
            self.userButton.addTarget(self, action: #selector(editProfileImage(_:)), for: .touchUpInside)
            
            // Tap action to upload cover image
            let tapCoverImage = UITapGestureRecognizer(target: self, action: #selector(editCoverImage(_:)))
            self.coverImage.isUserInteractionEnabled = true
            tapCoverImage.numberOfTapsRequired = 1
            self.coverImage.addGestureRecognizer(tapCoverImage)
            self.coverButton.isHidden = false
            self.coverButton.addTarget(self, action: #selector(editCoverImage(_:)), for: .touchUpInside)
        }
        
        
        
        
        //Followers
        let tapFollowerCount = UITapGestureRecognizer(target: self, action: #selector(viewFollowers(_:)))
        self.followersCount.isUserInteractionEnabled = true
        self.followersCount.text = self.profileData.follower!
        self.followersCount.addGestureRecognizer(tapFollowerCount)
        
        let tapFollowerLabel = UITapGestureRecognizer(target: self, action: #selector(viewFollowers(_:)))
        self.followersLabel.isUserInteractionEnabled = true
        self.followersLabel.addGestureRecognizer(tapFollowerLabel)
        
        //Following
        let tapFollowingLabel = UITapGestureRecognizer(target: self, action: #selector(TapFollowing(_:)))
        self.followingLabel.isUserInteractionEnabled = true
        self.followingLabel.addGestureRecognizer(tapFollowingLabel)
        
        let tapFollowingCount = UITapGestureRecognizer(target: self, action: #selector(TapFollowing(_:)))
        self.followingCount.text = self.profileData.following!
        self.followingCount.addGestureRecognizer(tapFollowingCount)
        
        let tapPhotoMap = UITapGestureRecognizer(target: self, action: #selector(viewMaps(_:)))
        tapPhotoMap.numberOfTapsRequired = 1
        self.photoMapImage.isUserInteractionEnabled = true
        self.photoMapImage.addGestureRecognizer(tapPhotoMap)
        
        let tapAbout = UITapGestureRecognizer(target: self, action: #selector(viewAbout(_:)))
        tapAbout.numberOfTapsRequired = 1
        self.about.isUserInteractionEnabled = true
        self.about.addGestureRecognizer(tapAbout)
        
        
        
        self.postsCount.text = self.profileData.post!
        self.userName.text = self.profileData.first_name! + " " + self.profileData.last_name!
        let proRes = ImageResource(downloadURL: URL(string: (self.profileData.user_image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.profileData.user_image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.userImage.kf.indicatorType = .activity
        self.userImage.kf.setImage(with: proRes, placeholder: #imageLiteral(resourceName: "placeholderImage"))
        
        let covRes = ImageResource(downloadURL: URL(string: (self.profileData.social_cover_image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.profileData.social_cover_image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.coverImage.kf.indicatorType = .activity
        self.coverImage.kf.setImage(with: covRes , placeholder: #imageLiteral(resourceName: "placeholderImage"))
        self.about.text = self.profileData.user_description!
    }

}


extension HeaderCell : UICollectionViewDelegate, UICollectionViewDataSource{
   
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == follower_CV{
            if self.profileData.followers!.count == 10{
                return 10
            }else{
                return (self.profileData.followers?.count)!
            }
            
        }else if collectionView == photos_CV{
            return (self.profileData.photos?.count)!
        }else if collectionView == videos_CV{
            return (self.profileData.videos?.count)!
        }else if collectionView == albums_CV{
            return (self.profileData.albums?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == follower_CV{
            let follower = follower_CV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FollowersCollectionViewCell
            if self.profileData.followers!.count > 0{
            
                if self.profileData.followers!.count == 10{
                    if indexPath.row == 9 {
                        follower.stack.isHidden = false
                        follower.image.image = nil
                        let num : Int = Int(self.profileData.follower!)! - 9
                        follower.countLabel.text = String(num)
                    }else{
                        follower.stack.isHidden = true
                        let res = ImageResource(downloadURL: URL(string: (self.profileData.followers![indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.profileData.followers![indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                        follower.image.kf.indicatorType = .activity
                        follower.image.kf.setImage(with: res , placeholder: #imageLiteral(resourceName: "placeholderImage"))

                    }
                }else{
                    follower.stack.isHidden = true
                    let res = ImageResource(downloadURL: URL(string: (self.profileData.followers![indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.profileData.followers![indexPath.row].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                    follower.image.kf.indicatorType = .activity
                    follower.image.kf.setImage(with: res , placeholder: #imageLiteral(resourceName: "placeholderImage"))
                    
                }

                
            }

            return follower
        }else if collectionView == photos_CV{
            let photo : PhotoCell = photos_CV.dequeueReusableCell(for: indexPath)
            if self.profileData.photos!.count > 0{
                let process = BlurImageProcessor(blurRadius: 5.0)
                let resource1 = ImageResource(downloadURL: URL(string: (self.profileData.photos![indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.profileData.photos![indexPath.row].small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)

                photo.photoImage.kf.indicatorType = .activity
                photo.photoImage.kf.setImage(with: resource1, options: [.processor(process)]) { (result) in
                    switch result{
                    case .success(let val):
                        let resource2 = ImageResource(downloadURL: URL(string: (self.profileData.photos![indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (self.profileData.photos![indexPath.row].thumb_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                        photo.photoImage.kf.indicatorType = .activity
                        photo.photoImage.kf.setImage(with: resource2, placeholder : val.image)

                    case .failure(let error):
                        print(error)
                    }
                }
            }
            return photo
        }else if collectionView == videos_CV{
            let video : VideoCell = videos_CV.dequeueReusableCell(for: indexPath)
            if self.profileData.videos!.count > 0{
                video.videoView.videoUrl = URL(string: "\(self.profileData.videos![indexPath.row].video!)")
                video.videoView.showsCustomControls = true
            }
            return video

        }else{

            let album : AlbumCell = albums_CV.dequeueReusableCell(for: indexPath)
            if self.profileData.albums!.count > 0{

                album.albumName.text = self.profileData.albums![indexPath.row].album_title!
                let resource = ImageResource(downloadURL: URL(string: (self.profileData.albums![indexPath.row].photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.profileData.albums![indexPath.row].photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                album.albumImage.kf.indicatorType = .activity
                album.albumImage.kf.setImage(with: resource)

            }
            return album

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        if collectionView == follower_CV{
            if indexPath.row == 9 {
                let vc = self.storyBoard.instantiateViewController(withIdentifier: "followers") as! FollowersListViewController
                vc.flag = false
                vc.title = "Followers"
                self.delegate?.push(viewController: vc)
            }else{
                if NetworkController.front_user_id != self.profileData.followers![indexPath.row].front_user_id!{
                    NetworkController.others_front_user_id = self.profileData.followers![indexPath.row].front_user_id!
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "othersProfile") as! OthersViewController
                    self.delegate?.push(viewController: vc)
                }
            }
            
        }else if collectionView == photos_CV{
            let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "singleImage") as! ShowImageViewController
            VC.photo = self.profileData.photos!
            VC.index = indexPath.row
            VC.modalPresentationStyle = .fullScreen
            self.delegate?.present(viewController: VC)
        }else if collectionView == videos_CV{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "video") as! VideoViewController
            self.delegate?.push(viewController: vc)
        }else if collectionView == albums_CV{
            
            let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "AlbumPhotosViewController") as! AlbumPhotosViewController
            VC.album_id  = self.profileData.albums![indexPath.row].id
            VC.backIndex = indexPath.row
            self.delegate?.push(viewController: VC)
        }
    }
    
}


extension HeaderCell{
    @objc func editProfileImage(_ sender : Any){
        self.pickImageFor(isProfile: true)
    }
    
    @objc func editCoverImage(_ sender : Any){
        self.pickImageFor(isProfile: false)
    }
    
    func pickImageFor(isProfile : Bool){
        let actionSheet = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = false
            }
            if isProfile {
                self.pickerFlag = true
                self.delegate?.present(viewController: self.imagePicker)
            }else{
                self.pickerFlag = false
                self.delegate?.present(viewController: self.imagePicker)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false
            }
            if isProfile{
                    self.pickerFlag = true
                    self.delegate?.present(viewController: self.imagePicker)
            }else{
                self.pickerFlag = false
                self.delegate?.present(viewController: self.imagePicker)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.delegate?.present(viewController: actionSheet)
        
    }

}

extension HeaderCell{
    @IBAction func viewAbout(_ sender : UIButton){
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "view_more") as! ViewMoreViewController
            vc.profileData = self.profileData
        self.delegate?.push(viewController: vc)
        
    }
    
    @IBAction func viewFollowers(_ sender : UIButton){
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "followers") as! FollowersListViewController
        vc.flag = false
        vc.title = "Followers"
        self.delegate?.push(viewController: vc)
    }
    
    @IBAction func viewPhotos(_ sender : UIButton){
        let vc = storyBoard.instantiateViewController(withIdentifier: "photos") as! PhotoViewController
        self.delegate?.push(viewController: vc)
        
    }
    
    @IBAction func viewVideo(_ sender : UIButton){
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "video") as! VideoViewController
        self.delegate?.push(viewController: vc)
    }
    
    @IBAction func viewAlbums(_ sender : UIButton){
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "album") as! AlbumsViewController
        self.delegate?.push(viewController: vc)
    }
    
    @IBAction func viewMaps(_ sender : UIButton){
        
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "map") as! PhotoMapsViewController
        self.delegate?.push(viewController: vc)
    }
    
    ///MainButton
    @IBAction func mainAction(_ sender : ButtonY){
        if sender.currentTitle == "Edit Profile"{
            let editVC = self.storyBoard.instantiateViewController(withIdentifier: "profile_edit") as? ProfileEditViewController
            editVC?.title = "Edit Profile"
            editVC?.profileData = self.profileData
            self.delegate?.push(viewController: editVC!)
            
        }else{
            if NetworkController.front_user_id != "0"{
                if profileData?.is_followed == "yes"{
                    self.Follow_Unfollow(other_front_user_id: (profileData?.front_user_id)!, followStatus: "unfollow")
                }else{
                    self.Follow_Unfollow(other_front_user_id: (profileData?.front_user_id)!, followStatus: "follow")
                }
            }else{
                let vc = self.storyBoard.instantiateViewController(withIdentifier: "login") as! UINavigationController
                self.delegate?.present(viewController: vc)
            }
        }
    }
    
}

///Tap Gestures..
extension HeaderCell{
    
    @objc func TapFollowing(_ sender : UITapGestureRecognizer){
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "followers") as! FollowersListViewController
        vc.flag = true
        vc.title = "Following"
        self.delegate?.push(viewController: vc)
    }
    
}


extension HeaderCell :  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        if self.pickerFlag{
//            self.userImage.image = image
//            self.delegate?.updateProfileCover(croped: image, isProfile: self.pickerFlag)
//
//        }else{
//            self.coverImage.image = image
//            self.delegate?.updateProfileCover(croped: image, isProfile: self.pickerFlag)
//        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
            if self.pickerFlag{
                picker.dismiss(animated: true){
                    self.delegate?.CropperDelegation!(isProfile: self.pickerFlag, image: img!)
                }
            }else{
                picker.dismiss(animated: true){
                    self.delegate?.CropperDelegation!(isProfile: self.pickerFlag, image: img!)
                }
            }
        }
    }
}

//API Calls

extension HeaderCell{
    func Follow_Unfollow( other_front_user_id : String , followStatus : String ){
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(other_front_user_id)",
            "my_id" : "\(NetworkController.front_user_id)",
            "type" : "\(followStatus)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .FollowUnfollow){ resp,_ in
            
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    if followStatus == "follow"{
                        self.profileData?.is_followed = "yes"
                        //                        self.follow_btn.setTitle("Following", for: .normal)
                        UIView.transition(with: self.mainButton as UIView, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve , animations: {
                            self.mainButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                            self.mainButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                            self.mainButton.setTitle("Following", for: .normal)
                            
                        }, completion: nil)
                    }else if followStatus == "unfollow"{
                        //                        self.follow_btn.setTitle("Following", for: .normal)
                        self.profileData?.is_followed = "no"
                        UIView.transition(with: self.mainButton as UIView, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve , animations: {
                            self.mainButton.backgroundColor = UIColor.clear
                            self.mainButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
                            self.mainButton.setTitle("Follow +", for: .normal)
                        }, completion: nil)
                    }
                }else{
                    print("\(resp["result"]["description"].stringValue)")
                }
            }else{
                print("Response Null")
            }
        }
    }
}

