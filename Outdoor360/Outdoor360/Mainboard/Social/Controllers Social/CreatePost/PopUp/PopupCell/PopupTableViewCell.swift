//
//  PopupTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 05/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class PopupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbl : UILabel!
//     var isSearching : Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}
