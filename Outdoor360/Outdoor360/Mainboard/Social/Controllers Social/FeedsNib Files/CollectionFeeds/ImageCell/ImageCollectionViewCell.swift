//
//  ImageCollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 27/06/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    func ConfigureCell(imagess : Photo) {
        
//        let imgRes = ImageResource(downloadURL: URL(string: image.small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! , cacheKey : image.small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
//        self.image.kf.indicatorType = .activity
//        self.image.kf.setImage(with: imgRes)

        let process = BlurImageProcessor(blurRadius: 5.0)
        let resource1 = ImageResource(downloadURL: URL(string: (imagess.small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (imagess.small_photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        self.image.kf.indicatorType = .activity
        
        self.image.kf.setImage(with: resource1, options : [.processor(process)]) { (result) in
            switch result{
            case .success(let val):
                let resource2 = ImageResource(downloadURL: URL(string: (imagess.photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (imagess.photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                self.image.kf.indicatorType = .activity
                self.image.kf.setImage(with: resource2, placeholder : val.image)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}
