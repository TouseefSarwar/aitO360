//
//  ShowVideoCollectionViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 29/11/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit

class ShowVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoView : AGVideoPlayerView!
    @IBOutlet weak var hideView : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func ConfigureCell (VideoURL : String){
        self.videoView.shouldAutoplay = true
        self.videoView.videoUrl = URL(string: "\(VideoURL)")
        self.videoView.shouldSwitchToFullscreen = true
        self.videoView.showsCustomControls = true
        self.videoView.contentMode = .scaleAspectFit
    }
    
}



