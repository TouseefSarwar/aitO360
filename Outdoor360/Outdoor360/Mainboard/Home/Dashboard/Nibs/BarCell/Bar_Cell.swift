//
//  Bar_Cell.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit

class Bar_Cell: UITableViewCell {

    @IBOutlet weak var storyButton : ButtonY!
    @IBOutlet weak var tripButton : ButtonY!
    @IBOutlet weak var reportButton : ButtonY!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
