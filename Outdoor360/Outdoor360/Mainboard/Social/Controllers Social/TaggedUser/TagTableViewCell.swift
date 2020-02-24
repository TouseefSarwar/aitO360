//
//  TagTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 05/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {


    @IBOutlet weak var profileImag: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var delete_Btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
