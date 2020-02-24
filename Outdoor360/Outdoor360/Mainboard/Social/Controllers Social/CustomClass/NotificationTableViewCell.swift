//
//  NotificationTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 19/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var imagePro: ImageViewX!
    @IBOutlet weak var user_name: UIButton!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var post: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
