//
//  E_photo_CollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 14/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit

protocol EditPhotoDelegate {
    func DeletePhoto(index : Int!)
    func PresentPhoto(photoViewController viewController : UIViewController)
}
class E_photo_CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img : ImageViewX!
    @IBOutlet weak var delete_Btn : UIButton!
    

    
    var index : Int!
    var delegate : EditPhotoDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func deletePhoto(_ sender : UIButton){
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
            self.delegate?.DeletePhoto(index: self.index)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.delegate?.PresentPhoto(photoViewController: alert)

    }
}
