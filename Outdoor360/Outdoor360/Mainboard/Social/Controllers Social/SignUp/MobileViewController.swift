//
//  MobileViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 24/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import NKVPhonePicker
import SwiftyJSON

class MobileViewController: UIViewController {
   
    @IBOutlet weak var mobile_text: NKVPhonePickerTextField!
    @IBOutlet weak var mobile_back_text: UITextField!
    
    
    
    @IBOutlet weak var next_Btn: ButtonY!
    
    var social_identifier : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobile_text.phonePickerDelegate = self
        mobile_text.rightToLeftOrientation = false
        mobile_text.favoriteCountriesLocaleIdentifiers = ["US", "PK"]
        mobile_text.flagInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 10)
        mobile_text.flagSize = CGSize(width: 24, height: 24)
        mobile_text.enablePlusPrefix = false
        mobile_text.customPhoneFormats = ["US" : "(###) ###-####", "PK" : "(###) ### ####",]
    }

}

extension MobileViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next_Btn(_ sender: Any) {
        
        if self.mobile_text.text == "" || self.mobile_text.text == self.mobile_text.code {
            let alert = UIAlertController(title: "Empty TextFields", message: nil , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if self.social_identifier == "social"{
            SignupGolbal.mobile = self.mobile_text.phoneNumber!
            SignupGolbal.country_Code = self.mobile_text.code!
            UpdateSocial(country_code: SignupGolbal.country_Code , number: SignupGolbal.mobile)
        }else{
            SignupGolbal.mobile = self.mobile_text.phoneNumber!
            SignupGolbal.country_Code = self.mobile_text.code!
            self.SignUp_User()
        }
    }
}

//MARK: Api Call

extension MobileViewController{
    
    func SignUp_User(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "first_name" : SignupGolbal.first_name ?? "",
            "last_name" : SignupGolbal.last_name ?? "",
            "pass" : SignupGolbal.password ?? "",
            "email" : SignupGolbal.email ?? "",
            "mobile_number" : SignupGolbal.mobile ?? "" ,
            "location" : SignupGolbal.address ?? "",
            "country_code" : SignupGolbal.country_Code ?? "",
            "device_id" : AppDelegate.accessToken!,
            "device_type" : "ios"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SignUp){resp,_ in
            
            if resp != JSON.null{
                
                if resp["result"]["status"].boolValue == true{
                    self.removeActivityLoader()
                    SignupGolbal.first_name = resp["result"]["data"]["first_name"].stringValue
                    SignupGolbal.last_name = resp["result"]["data"]["last_name"].stringValue
                    SignupGolbal.email = ""
                    SignupGolbal.password = ""
                    SignupGolbal.mobile = ""
                    SignupGolbal.address = ""
                    SignupGolbal.country_Code = ""
                    SignupGolbal.front_user_id = resp["result"]["data"]["front_user_id"].stringValue
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(resp["result"]["description"].stringValue)"))")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
        
    }
 
    func UpdateSocial(country_code : String , number : String){
        self.addActivityLoader()
        let parameters : [String : Any]  = [
            "front_user_id" : "\(SignupGolbal.front_user_id!)" ,
            "email" : Login._email,
            "country_code" : "\(country_code)",
            "mobile_number" : "\(number)",
            
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .UpdateSocial) {response,_ in
            if response != JSON.null{
                
                if response["result"]["status"].boolValue == true{
                    Login._email = ""
                    Login._password = ""
                    Login._socialVerify = 0
                    self.removeActivityLoader()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                    
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



