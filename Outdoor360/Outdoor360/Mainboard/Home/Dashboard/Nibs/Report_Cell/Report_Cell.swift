//
//  Report_Cell.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit

class Report_Cell: UITableViewCell {

    @IBOutlet weak var coverImage : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var location : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
