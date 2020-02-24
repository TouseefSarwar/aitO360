//
//  ProfileEditViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 18/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NKVPhonePicker

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var first_name : UITextField!
    @IBOutlet weak var last_name : UITextField!
    @IBOutlet weak var dateOfBirth : UITextField!
    @IBOutlet weak var phoneNumber: NKVPhonePickerTextField!
    @IBOutlet weak var descri : TextViewX!
    
    var profileData : ProfileResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumber.phonePickerDelegate = self
        phoneNumber.rightToLeftOrientation = false
        phoneNumber.favoriteCountriesLocaleIdentifiers = ["US", "PK"]
        phoneNumber.flagInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 10)
        phoneNumber.flagSize = CGSize(width: 20, height: 20)
        phoneNumber.enablePlusPrefix = false
        phoneNumber.customPhoneFormats = ["US" : "(###) ###-####", "PK" : "(###) ### ####",]

        if let _ = self.profileData{
            self.first_name.text = profileData.first_name!
            self.last_name.text = profileData.last_name!
            self.descri.text = profileData.user_description!
            self.dateOfBirth.text = profileData.dateOfBirth ?? ""
            self.phoneNumber.text = profileData.phoneNumber ?? ""
        }else{}
        self.descri.delegate = self
        dateOfBirth.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    
    @IBAction func Update(_ sender: Any){
       self.EditProfile()
    }
    
   
}

extension ProfileEditViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descri.text == "Write something about yourself..."{
            descri.text = ""
        }
        descri.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descri.text == "" {
            descri.text = "Write something about yourself..."
        }
        descri.resignFirstResponder()
    }
}

extension ProfileEditViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        PickerY.selectDate(title: "Select Date of Birth", hideCancel: false, datePickerMode: .date, selectedDate: nil, minDate: nil, maxDate: nil) { (selectedDate) in
            self.dateOfBirth.text = selectedDate.toString("MMM dd, YYYY")
        }
        
    }
}

extension ProfileEditViewController {
    
    func EditProfile(){
        self.addActivityLoader()
        let parameters: [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "first_name" : self.first_name.text ?? "",
            "last_name" : self.last_name.text ?? "",
            "description" : self.descri.text ?? "",
            "date_of_birth" : self.dateOfBirth.text ?? "",
            "phone_number" : self.phoneNumber.phoneNumber ?? "",
            "country_code" : self.phoneNumber.code ?? ""
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .EditProfile) {response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.removeActivityLoader()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                    tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                    tab_Crtl.modalPresentationStyle = .fullScreen
                    self.present(tab_Crtl, animated: true, completion: nil)
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: response["result"]["description"].stringValue)
                }
                
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
        
    }
    
}
