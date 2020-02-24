//
//  SuggestedTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 22/04/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

protocol SuggestedTableViewCellDelegate : class{
    func pushController(withNavigation viewController : UIViewController)
}

class SuggestedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var suggested : [Suggested_User] = []
    var index = -1
    
    weak var delegate : SuggestedTableViewCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SuggestedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "suggested")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ConfigureSuggestions(suggestedUsers : [Suggested_User]){
            self.suggested = suggestedUsers
    }
    
}


//MARK: Collection View Delegates and dataSource

extension SuggestedTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Guides.suggestedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggested", for: indexPath) as! SuggestedCollectionViewCell
        cell.ConfigureCell(index: indexPath.row, collectionView : collectionView)
       
         return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkController.others_front_user_id = Guides.suggestedUsers[indexPath.row].front_user_id!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "showProfile") as? UINavigationController
        self.delegate?.pushController(withNavigation: vc!)
    }
  
    
}
