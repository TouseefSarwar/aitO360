//
//  AddressViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 24/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftyJSON

class AddressViewController: UIViewController {

    
    
    @IBOutlet weak var address_txt: UITextField!
    @IBOutlet weak var loader : UIView!
    
    //MARK: Current Location.....!
    
    var current_location = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.current_location.delegate = self
        self.current_location.desiredAccuracy = kCLLocationAccuracyBest
        self.current_location.startUpdatingLocation()
        loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(loader)
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location, placemarker, error) in
            if error == nil{
                self.address_txt.text = (placemarker?.locality!)! + "," + (placemarker?.country!)!
                self.loader.removeFromSuperview()
            }else{
                self.presentError(massageTilte: "\(error!.localizedDescription)")
                self.loader.removeFromSuperview()
            }
        }
       
    }
    
    @IBAction func textfeild_Tapped(_ sender: Any) {

        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    
}

//MARK: Current Location Manager Delegates....

extension AddressViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        current_location.stopUpdatingLocation()
    }
}

//MARK: GooglePlaces...
extension AddressViewController : GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.address_txt.text = place.formattedAddress!
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}



extension AddressViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signup_Btn(_ sender: Any) {
        
        if self.address_txt.text == ""  {
            let alert = UIAlertController(title: "Empty TextFields" , message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            SignupGolbal.address = self.address_txt.text!
            performSegue(withIdentifier: "mobile", sender: self)
        }
    }
}


