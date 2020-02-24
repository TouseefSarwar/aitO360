//
//  ImageTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 18/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var user_image : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
