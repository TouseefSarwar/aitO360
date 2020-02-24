//
//  Search_VC.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 23/08/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import GooglePlaces

class Search_VC: UIViewController {

    
    let autoComplete = GMSAutocompleteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        autoComplete.delegate = self
        
    }

    @IBAction func searchViewClicked(_ sender: Any) {
        self.present(autoComplete, animated: true, completion: nil)
    }
    
    
    @IBAction func floridaClicked(_ sender: Any) {
        self.pushViewController(storyboard: "Search", className: SearchResult_VC.self)
    }

    @IBAction func californiaClicked(_ sender: Any) {
        self.pushViewController(storyboard: "Search", className: SearchResult_VC.self)
    }
    @IBAction func texasClicked(_ sender: Any) {
        self.pushViewController(storyboard: "Search", className: SearchResult_VC.self)
    }
    
}


//MARK: GooglePlaces
extension Search_VC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
//        self.delegate.returnLocation(item: place.formattedAddress!, index: self.index!)
        
        //        self.location_lbl.text  = place.formattedAddress!
        
        //Add Loader and push to result view controller also remove dismiss...
        
        self.dismiss(animated: true){
            self.pushViewController(storyboard: "Search", className: SearchResult_VC.self)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
