//
//  Loader.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 31/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import UIKit

class Loader: UIView {
    
    @IBOutlet weak var gifView : UIImageView!
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let imageGif = UIImage.gifImageWithName("loader")
        self.gifView.image = imageGif
    }
    
}
