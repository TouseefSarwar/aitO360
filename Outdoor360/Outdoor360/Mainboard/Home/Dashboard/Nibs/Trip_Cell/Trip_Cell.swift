//
//  Trip_Cell.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit

class Trip_Cell: UITableViewCell {

    
    @IBOutlet weak var coverImage : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var location : UILabel!
    @IBOutlet weak var startFrom : UILabel!
    @IBOutlet weak var guideName : UILabel!
    @IBOutlet weak var guideImage : ImageViewX!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
