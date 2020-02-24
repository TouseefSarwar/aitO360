//
//  MentionTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 11/12/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class MentionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: ImageViewX!
    
    @IBOutlet weak var name: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
