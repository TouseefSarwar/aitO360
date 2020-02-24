//
//  CellFollower.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 11/08/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher

class CellFollower: UITableViewCell {

    var index : Int!
    var isSearching : Bool!
    
    @IBOutlet weak var user_img: ImageViewX!
    @IBOutlet weak var user_name: UILabel!
    
    
    var  tags : SearchGuides!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    func Configure(cellData : SearchGuides , selected_tags : [String]){
        self.tags = cellData
        let res = ImageResource(downloadURL: URL(string: (cellData.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)! , cacheKey: cellData.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        self.user_img.kf.indicatorType = .activity
        self.user_img.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
        self.user_name.text = cellData.first_name!  + " " + cellData.last_name!
        
        
        
        if selected_tags.count > 0{
            
        }
       
        

    }
    
}
