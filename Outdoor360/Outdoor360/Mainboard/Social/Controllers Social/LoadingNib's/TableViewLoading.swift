//
//  TableViewLoading.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 18/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class TableViewLoading: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
