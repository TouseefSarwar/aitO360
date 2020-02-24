//
//  AddCaptionTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 13/04/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class AddCaptionTableViewCell: UITableViewCell {

    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var caption_textField: UITextField!
    @IBOutlet weak var location_Btn: UIButton!
    @IBOutlet weak var addSpecies: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func ConfigureTextField (text : String , placeholderText : String)
    {
        self.caption_textField.text = text
        self.caption_textField.placeholder = placeholderText
        
        self.accessibilityValue = text
        self.accessibilityLabel = placeholderText
    }

}
