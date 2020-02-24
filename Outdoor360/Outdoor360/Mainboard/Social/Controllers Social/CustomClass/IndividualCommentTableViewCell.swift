//
//  IndividualCommentTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 17/04/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class IndividualCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var pro_img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
