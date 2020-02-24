//
//  FollowerListTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 12/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class FollowerListTableViewCell: UITableViewCell {

    var data : Follower!
    
    @IBOutlet weak var follow_btn: ButtonY!
    @IBOutlet weak var pro_Img: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Configure(cellData : Follower){
        self.data = cellData
       
        if self.data.front_user_id! == NetworkController.front_user_id{
            self.follow_btn.isHidden = true
        }else{
            self.follow_btn.isHidden = false
        }
        let res = ImageResource(downloadURL: URL(string: (self.data.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: self.data.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        self.pro_Img.kf.indicatorType = .activity
        self.pro_Img.kf.setImage(with: res, placeholder: #imageLiteral(resourceName: "placeholderImage"))
        self.user_name.text = "\(self.data.first_name!) \(self.data.last_name!)" 
    }
    
    
    
    
    
}
extension FollowerListTableViewCell{
    
}
