//
//  IndiviualTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 25/06/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class IndiviualTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var current_Image: ImageViewX!
    
    @IBOutlet weak var pro_Image: ImageViewX!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var like_Btn: ButtonY!
    @IBOutlet weak var comment_Btn: ButtonY!
    @IBOutlet weak var share_Btn: ButtonY!
    
    @IBOutlet weak var tag_Btn: UIButton!
    
    @IBOutlet weak var like_Count: ButtonY!
    @IBOutlet weak var comment_Count: ButtonY!
    @IBOutlet weak var tag_Count: ButtonY!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
