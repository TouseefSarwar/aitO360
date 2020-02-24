//
//  SuggestedCollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 22/04/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class SuggestedCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var pro_img : ImageViewX!
    @IBOutlet weak var followBtn : ButtonY!
    @IBOutlet weak var name : UILabel!
    
    
    
    var index = -1
    var collection : UICollectionView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func ConfigureCell(index : Int, collectionView : UICollectionView){
        self.index = index
        self.collection = collectionView
        let resource1 = ImageResource(downloadURL: URL(string: (Guides.suggestedUsers[index].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: (Guides.suggestedUsers[index].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        self.pro_img.kf.indicatorType = .activity
        self.pro_img.kf.setImage(with: resource1, placeholder: UIImage(named: "placeholderImage"))
        self.name.text = Guides.suggestedUsers[index].first_name! + " " + Guides.suggestedUsers[index].last_name!
        
    }
    
    @IBAction func followBtn(_ sender : ButtonY){
        print(index)
        
        let parameters : [String: Any] = [
            "front_user_id" : "\(Guides.suggestedUsers[index].front_user_id!)",
            "my_id" : "\(NetworkController.front_user_id)",
            "type" : "follow"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .FollowUnfollow){ resp,_ in
            
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    Guides.suggestedUsers.removeAll()
                    self.Suggested()
                    
                }
                
            }else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                //                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

}


extension SuggestedCollectionViewCell{
    
    func Suggested(){
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UserSuggestions){response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["user_suggestions"]
                    for user in resp{
                        let data = Suggested_User(suggestedJSON: user.1)
                        Guides.suggestedUsers.append(data)
                    }
                    self.collection?.reloadData()
                }
                else {
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                    //                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : nil))
                //                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


