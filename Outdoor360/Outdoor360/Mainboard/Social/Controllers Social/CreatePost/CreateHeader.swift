//
//  CreateHeader.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 04/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SnapKit
import ReadabilityKit
import Kingfisher
import TLPhotoPicker


protocol CreateHeaderDelegate {
    func present(viewController : UIViewController)
    func ImagesAssets(data : [TLPHAsset])
    func SendPostHeader()
    func linkDismissed()
    func PerformSegueHeader(identifier : String, type : String)
//    func CloseLinkPreview()
//    func Content(album_title : String , capiton : String)
}




class CreateHeader: UIView ,TLPhotosPickerViewControllerDelegate {
    
    
    var delegate : CreateHeaderDelegate!

    var images : [PickedImages] = []
    @IBOutlet weak var user_image: ImageViewX!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var album_title: UITextField!
    @IBOutlet weak var post_caption: UITextView!
    @IBOutlet weak var cameraBtn : UIButton!
    @IBOutlet weak var postTagCount : UILabel!
    
    //LinkPreview.....
    @IBOutlet weak var linkView : UIView!
    @IBOutlet weak var linkImage : UIImageView!
    @IBOutlet weak var linkTitle : UILabel!
    @IBOutlet weak var linkDescription : UILabel!
    @IBOutlet weak var linkURL : UILabel!
    @IBOutlet weak var linkClose : UIButton!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        post_caption.delegate = self
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "header"
    }
    

    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.delegate.ImagesAssets(data: withTLPHAssets)
        
    }
    
    @IBAction func camera(_ sender: Any) {

       
        let picker = TLPhotosPickerViewController()

        picker.delegate = self
        var configure = TLPhotosPickerConfigure()

        configure.usedCameraButton = true
        configure.maxSelectedAssets = 10
        configure.allowedLivePhotos = true
        configure.allowedVideo = true
        configure.autoPlay = true
        self.delegate.present(viewController: picker)
    
    }
    
    @IBAction func CloseLink(_ sender : UIButton){
        self.updateContraintsFor(show: false)
        self.delegate.linkDismissed()
    }
    
    

    //Tag people Button....
    @IBAction func to_see(_ sender: Any) {
        self.delegate.PerformSegueHeader(identifier: "add_tag", type: "post")
    }
    
    @IBAction func send_post(_ sender: Any) {
        self.delegate.SendPostHeader()
    }
    
    func updateContraintsFor(show : Bool){
        if show{
            self.linkView.snp.updateConstraints { (make) in
                make.height.equalTo(70)
                make.top.equalTo(self.post_caption.snp.bottom).offset(8)
            }
            self.linkClose.isHidden = !show
            self.linkURL.isHidden = !show
            self.linkTitle.isHidden = !show
            self.linkImage.isHidden = !show
            self.linkDescription.isHidden = !show
            self.linkView.isHidden = !show
            self.cameraBtn.isEnabled = !show
            
        }else{
            self.linkView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
                make.top.equalTo(self.post_caption.snp.bottom).offset(0)
            }
            self.linkClose.isHidden = !show
            self.linkURL.isHidden = !show
            self.linkTitle.isHidden = !show
            self.linkImage.isHidden = !show
            self.linkDescription.isHidden = !show
            self.linkView.isHidden = !show
            self.cameraBtn.isEnabled = !show
        }
    }
    
}
