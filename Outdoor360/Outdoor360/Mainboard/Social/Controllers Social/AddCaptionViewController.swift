//
//  AddCaptionViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 13/04/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import RSSelectionMenu
import GooglePlaces
import SnapKit

class AddCaptionViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet var loaderView: UIView!
    
    var selected_imgs : [UIImage] = [UIImage]()
    var captions : [String] = [String]()
    var resp : JSON = JSON.null
    //list data location and species
    var selected_Species : [String] = [String]()
    var species_data: [Species_Games]  = [Species_Games]()
    
    var data : [Species_Games] = [Species_Games]()
   
    //IBActions

    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancel_btn(_ sender: Any) {
//        print("\(captions)")
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    
    
    //end IBActions
    override func viewDidLoad() {
        super.viewDidLoad()
        GetSpecies()
        GetGames()
        
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selected_imgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AddCaptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddCaptionTableViewCell
        cell.img_View.image = self.selected_imgs[indexPath.row]
        let cgRect = NetworkController.shared.frame(forImage: cell.img_View)
        cell.img_View.frame = CGRect(x : 0, y : cell.img_View.frame.origin.y, width : cgRect.size.width , height : cgRect.size.height)
        
        cell.img_View.snp.updateConstraints{(make) in
            make.height.equalTo(cell.img_View.frame.height)
            make.width.equalTo(cell.img_View.frame.width)
        }
        cell.location_Btn.addTarget(self, action: #selector(self.locationAction(_sender:)), for: .touchUpInside)
        cell.addSpecies.addTarget(self, action: #selector(self.addSpecies_Action(_sender:)), for: .touchUpInside)

        
    //    self.captions.append(cell.caption_textField.text!)
        return cell
    }
   
    
    
    @objc func locationAction(_sender : UIButton){
        print("Working")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @objc func addSpecies_Action(_sender : UIButton){
        
//        print(self.data)
//        let selectionMenu =  RSSelectionMenu(selectionStyle : .multiple , dataSource: self.data) { (cell, object, indexPath) in
//            cell.textLabel?.text = object.name!
//            
//            // Change tint color (if needed)
//            cell.tintColor = .orange
//        }
        
        
//        selectionMenu.setSelectedItems(items: selected_Species) { (text, isPresented, _ ,selectedItems)  in
        
            // update your existing array with updated selected items, so when menu presents second time updated items will be default selected.
//            self.selected_Species = selectedItems
//        }
        
//        selectionMenu.show(style: .formSheet, from: self)
    }
    
    
    @IBAction func sendPost_Btn(_ sender: Any) {
        
        
        for i in 0..<self.selected_imgs.count{
            print(self.selected_imgs.count)
            let index = IndexPath(row: i, section: 0)
            let cell: AddCaptionTableViewCell = self.tableView.cellForRow(at: index) as! AddCaptionTableViewCell
            
            print(cell.caption_textField.text!)
            self.captions.append(cell.caption_textField.text!)
            print("\(captions)")
        }
        SendPost()
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feeds"{
            let tabCtrl = segue.destination as! UITabBarController
            let nav = tabCtrl.viewControllers![0] as! UINavigationController
            let _ : NewFeedsViewController  =  nav.topViewController as! NewFeedsViewController

        }
        else if segue.identifier == "popup"{
            let nav = segue.destination as!  UINavigationController
            let vc : PopupViewController = nav.topViewController as! PopupViewController
            vc.data = self.data
            
        }
    }
    

}




// Mark-: GooglePlaces
extension AddCaptionViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//Mark_: API Calls...

extension AddCaptionViewController{
    
    func SendPost(){
        self.addActivityLoader()
        if selected_imgs.count>1 {
                    let url = "http://plandstudios.com/project101/app/post_feed" /* your API url */
                    let parameters: Parameters = [
                        "front_user_id" : "\(NetworkController.front_user_id)",
                        "feed_content" : "Multiple  Images iOS",
                        ]
                    let headers: HTTPHeaders = [
                        /* "Authorization": "your_access_token",  in case you need authorization header */
                        "Content-type": "multipart/form-data"
                    ]
               
        
        
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
        
                            for (key, value) in parameters {
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                            }
                            for (index ,img) in self.selected_imgs.enumerated(){
                                multipartFormData.append(img.pngData()!, withName: "image[]", fileName: "image\(index).png", mimeType: "image/png")
                            }
                        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
                            switch result{
                            case .success(let upload, _, _):
                                
                                
                                
                                upload.uploadProgress(closure: { (Progress) in
                                    print("Upload Progress: \(Progress.fractionCompleted)")
                                   self.tableView.isHidden = true
                                })
        
                                upload.responseJSON { response in
                                    print("Succesfully uploaded")
                                 
                                   // loading.hide()
                                   self.tableView.isHidden = false
                                    //self.progressView.isHidden = true
                                    if let JSON = response.result.value {
                                        print("JSON: \(JSON)")
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                
                                
                                
                            case .failure(let error):
                                print("Error in upload: \(error.localizedDescription)")
                                //onError?(error)
                              //  loading.hide()
                               
                            }
                        }
                }
        else if selected_imgs.count>0 && selected_imgs.count == 1{
                let url = "http://plandstudios.com/project101/app/post_feed" /* your API url */
                let parameters: Parameters = [
                    "front_user_id" : "\(NetworkController.front_user_id)",
                    "feed_content" : "First Image",
                    ]
                let headers: HTTPHeaders = [
                    /* "Authorization": "your_access_token",  in case you need authorization header */
                    "Content-type": "multipart/form-data"
                ]
                //   if let imageData = UIImagePNGRepresentation(selectedImage!) {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                    
                    let imageData = self.selected_imgs[0].jpegData(compressionQuality: 0.7)!
                    multipartFormData.append(imageData, withName: "image[]", fileName: "image.png", mimeType: "image/png")
                    
                    
                }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
                    switch result{
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            print("Succesfully uploaded")
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                           
                        }
                    case .failure(let error):
                        print("Error in upload: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    func GetSpecies(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Species){ response,_  in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.resp = response["result"]["data"]
                    print(self.resp)
                    for post in self.resp
                    {
                        let data = Species_Games(SpeciesGamesResponse: post.1)
                        print(data)
                        self.data.append(data)
                    }
                    self.removeActivityLoader()
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        
        }
    }
    
    func GetGames(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Games){ response,_ in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.resp = response["result"]["data"]
                    for post in self.resp{
                        let data = Species_Games(SpeciesGamesResponse: post.1)
                        self.data.append(data)
                    }
                    self.removeActivityLoader()
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
            
        }
    }
    
}

