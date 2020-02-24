//
//  AlbumCollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 11/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var album_title: UILabel!
//    @IBOutlet weak var album_caption: UILabel!
    @IBOutlet weak var images_count: LabelX!
    @IBOutlet weak var image: ImageViewX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
