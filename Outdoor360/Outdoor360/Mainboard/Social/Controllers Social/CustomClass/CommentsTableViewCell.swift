//
//  CommentsTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 15/03/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImg: ImageViewX!
    @IBOutlet weak var comment_label: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
//    func loadCell(_ data:(String)) {
//        comment_label.text = data
////        comment_label.text = data.lower
//    }

}
