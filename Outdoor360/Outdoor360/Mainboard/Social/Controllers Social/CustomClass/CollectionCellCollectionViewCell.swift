//
//  CollectionCellCollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 08/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
@IBDesignable

class CollectionCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var images: UIImageView!
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
