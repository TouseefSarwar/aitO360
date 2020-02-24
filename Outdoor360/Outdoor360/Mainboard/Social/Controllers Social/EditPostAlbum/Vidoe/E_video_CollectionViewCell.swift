//
//  E_video_CollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 14/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON

protocol EditVideoDelegate {
    func DeleteVideo(index : Int!)
    func PresentVideo(videoViewController viewController : UIViewController)
}


class E_video_CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var delete_Btn : UIButton!
    var index : Int!
    var delegate : EditVideoDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    @IBAction func deleteVideo(_ sender : UIButton){
        
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
            self.delegate?.DeleteVideo(index: self.index)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.delegate?.PresentVideo(videoViewController: alert)
    }
}

