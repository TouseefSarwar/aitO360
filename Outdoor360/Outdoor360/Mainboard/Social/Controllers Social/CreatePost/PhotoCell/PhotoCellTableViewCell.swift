//
//  PhotoCellTableViewCell.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 04/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
import CropViewController

 protocol PhotoCellDelegate : class {
    func performSeguePhoto(identifier : String , type : String, index : Int)
    func setCropedImage(at index : Int, croppedImage : UIImage)
    func presentPhoto(viewController : UIViewController)
    func dismissViewController()
    func returnLocation(item : String , index : Int)
    func returnSpecies(item : String , index : Int)
    func returnGames(item : String , index : Int)
    func returnTags(item : String , index : Int)
}

class PhotoCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var location_lbl: UILabel!
    @IBOutlet weak var species_lbl: UILabel!
    @IBOutlet weak var tag_lbl: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    //Croping
    @IBOutlet weak var crop_lbl : UILabel!
    @IBOutlet weak var crop_Btn : UIButton!
    
    //Variables
    var loc : String!
    var index : Int!
    
    weak var delegate : PhotoCellDelegate! = nil
//
//    let tagDelegate : TagMorePopup! = nil
//    let speciesDelegate : PopupViewController! = nil
    let autocompleteController = GMSAutocompleteViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autocompleteController.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func ConfigureCell(pickedIamge : PickedImages , index : Int){
        
        
        self.img_View.image = pickedIamge.image
        self.index = index
       
        if pickedIamge.type == "image" {
            
            let tapCrop =  UITapGestureRecognizer(target: self, action: #selector(TapCrop(_:)))
            self.crop_lbl.isUserInteractionEnabled = true
            self.crop_lbl.addGestureRecognizer(tapCrop)
            self.crop_Btn.isEnabled = true
        }else{
            self.crop_Btn.isEnabled = false
        }
        
        let tapLoc =  UITapGestureRecognizer(target: self, action: #selector(TapLocation(_:)))
        self.location_lbl.isUserInteractionEnabled = true
        self.location_lbl.addGestureRecognizer(tapLoc)
        
        let tapTags =  UITapGestureRecognizer(target: self, action: #selector(TapTag(_:)))
        self.tag_lbl.isUserInteractionEnabled = true
        self.tag_lbl.addGestureRecognizer(tapTags)
        
        let tapSpecies =  UITapGestureRecognizer(target: self, action: #selector(TapSpecies(_:)))
        self.species_lbl.isUserInteractionEnabled = true
        self.species_lbl.addGestureRecognizer(tapSpecies)

        
    }
}


//MARK: Tap Guestures
extension PhotoCellTableViewCell{
    
    @objc func TapLocation(_ sender : UITapGestureRecognizer){
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
        PostUpdateGlobal.indx = self.index
        self.delegate.presentPhoto(viewController: autocompleteController)
    }
    @objc func TapTag(_ sender : UITapGestureRecognizer){
        PostUpdateGlobal.indx = self.index
        self.delegate.performSeguePhoto(identifier: "add_tag", type: "photo",index: self.index)
    }
    @objc func TapSpecies(_ sender : UITapGestureRecognizer){
        PostUpdateGlobal.indx = self.index
        
    
//        let actionSheet = UIAlertController(title: "Select Fish or Game", message: nil, preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Fish", style: .default, handler: { _ in
            self.delegate.performSeguePhoto(identifier: "popup", type: "species",index: self.index)
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Game", style: .default, handler: {_ in
//            self.delegate.performSeguePhoto(identifier: "popup", type: "games",index: self.index)
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.delegate.presentPhoto(viewController: actionSheet)
    }
    @objc func TapCrop(_ sender : UITapGestureRecognizer){
        
        let cropper  = CropViewController(croppingStyle: .default, image: self.img_View.image!)
        cropper.delegate = self
        self.delegate.presentPhoto(viewController: cropper)
        
    }
    
}

//Cropper Delegate
extension PhotoCellTableViewCell: CropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.img_View!.image = image
        self.delegate.setCropedImage(at: self.index, croppedImage: image)
//        let vc = CreatePostViewController()
//        self.delegate.dismissViewController()
//        cropViewController.dismissAnimatedFrom(vc, toView: self.img_View, toFrame: .zero, setup: nil){ () -> (Void) in
//        }
    }
    
}


//Mark : - Location Tag Species

extension PhotoCellTableViewCell {
    
    @IBAction func location_Btn(_ sender: Any) {
        PostUpdateGlobal.indx = self.index
        self.delegate.presentPhoto(viewController: autocompleteController)
        
    }
    
    @IBAction func tag_Btn(_ sender: Any) {
        PostUpdateGlobal.indx = self.index
        self.delegate.performSeguePhoto(identifier: "add_tag", type: "photo",index: self.index)
    }
    
    @IBAction func add_Species(_ sender: Any) {
        PostUpdateGlobal.indx = self.index
        self.delegate.performSeguePhoto(identifier: "popup", type: "species",index: self.index)
    }
    
    
    @IBAction func cropRotate(_ sender: Any) {
        let cropper  = CropViewController(croppingStyle: .default, image: self.img_View.image!)
        cropper.delegate = self
        self.delegate.presentPhoto(viewController: cropper)
    }
    

}



//MARK: GooglePlaces
extension PhotoCellTableViewCell: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.delegate.returnLocation(item: place.formattedAddress!, index: self.index!)
//        self.location_lbl.text  = place.formattedAddress!
        self.delegate.dismissViewController()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.delegate.dismissViewController()
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
