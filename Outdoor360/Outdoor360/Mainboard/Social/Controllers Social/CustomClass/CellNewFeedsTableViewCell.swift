//
//  CellNewFeedsTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 21/02/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
//import SimpleImageViewer
import Foundation
import SnapKit

protocol CellDelegate {
    func shareImageDetails(_ indexPath : IndexPath , images : String , photo_id : String , data : SocialPost)
}

class CellNewFeedsTableViewCell: UITableViewCell  {
    var delegate : CellDelegate?

    var imageData = SocialPost()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var view: UIView!
//    @IBOutlet weak var singleImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeDate: UILabel!
    @IBOutlet weak var contentOfPost: UILabel!
    @IBOutlet weak var like_btn: ButtonY!
    @IBOutlet weak var comment_btn: ButtonY!
    @IBOutlet weak var share: ButtonY!
    @IBOutlet weak var like_count: ButtonY!
    @IBOutlet weak var comments_count: ButtonY!
    @IBOutlet weak var share_counts: ButtonY!
    
  //  let photoString : String = String()
    var dataSource : String?
    //let dataSource1 = [#imageLiteral(resourceName: "car1"),#imageLiteral(resourceName: "car3")]
    var images : [String] = [String]()
    var photo_ids : [String] = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
          //collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
      // collectionView.reloadData()
       print(images.count)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellNewFeedsTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath)

            //let processor = ResizingImageProcessor(referenceSize: CGSize(width: 220, height: 220))
        
        let imgView : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
            let resourceImage = ImageResource(downloadURL: URL(string: self.images[indexPath.row])!, cacheKey: self.images[indexPath.row])
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(with: resourceImage)//, options: [.transition(.fade(0)),.processor(processor)], completionHandler : nil)
//        let rect = NetworkController.sharedInstance.frame(forImage: cell.images)
//        cell.images.frame = CGRect(x: 0, y: cell.images.frame.origin.y, width: rect.size.width, height: rect.size.height)
//        cell.images.snp.updateConstraints{(make) in
//            make.height.equalTo(cell.images.frame.height)
//        }
        
            return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Tapped")
        delegate?.shareImageDetails(indexPath, images: self.images[indexPath.item], photo_id: self.photo_ids[indexPath.item] , data: imageData)
//        let vc : IndividualImageViewController = UIStoryboard(name : "Feeds" , bundle : nil).instantiateViewController(withIdentifier: "show") as! IndividualImageViewController
//        //  let nav = UIApplication.shar
//        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.present(vc, animated: true, completion: nil)
        //ShowInfo()
//        let configuration = ImageViewerConfiguration { config in
//                let resourceImage = ImageResource(downloadURL: URL(string: self.images[indexPath.row])!, cacheKey: self.images[indexPath.row])
//                //cell.images.kf.indicatorType = .activity
//                //cell.images.kf.setImage(with: resourceImage)
//                config.imageView?.kf.setImage(with: resourceImage)
//            }
//
//            let imageViewerController = ImageViewerController(configuration: configuration)
//
//        self.window?.inputViewController?.present(imageViewerController, animated: true, completion: nil)

    }
    

    
    
    

}


