//
//  SingleImage.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 31/10/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class SingleImage: UICollectionViewCell{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img_view : UIImageView!
    @IBOutlet weak var likeC : ButtonY!
    @IBOutlet weak var commentC : ButtonY!
    @IBOutlet weak var tagC : ButtonY!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
  
}

extension SingleImage : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img_view
    }
    

}


extension  SingleImage{
    

    
    @IBAction func Like_Btn(_ sender : ButtonY){
        print("like Pressed...")
        
    }
    @IBAction func Comment_Btn(_ sender : ButtonY){
        print("comment")
    }
    @IBAction func Tag_Btn(_ sender : UIButton){
        print("tag")
    }
    
    @IBAction func Share_Btn(_ sender : UIButton){
        print("share")
    }
  
    
    
}
