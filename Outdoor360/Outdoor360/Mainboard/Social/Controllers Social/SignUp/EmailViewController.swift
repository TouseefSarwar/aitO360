//
//  EmailViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 24/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON

class EmailViewController: UIViewController {
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var loader : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

extension EmailViewController {
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func next_Btn(_ sender: Any) {
        
        if self.email_txt.text == "" && self.email_txt.text == "" {
            let alert = UIAlertController(title: "Empty TextFields", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if isValidEmail(testStr: self.email_txt.text!){
                ValidateEmail()
            }else{
                let alert = UIAlertController(title: "Invalid Email Format", message: "Try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}



extension EmailViewController{
    
    func ValidateEmail(){
        self.addActivityLoader()
        let trimmedEmail = self.email_txt.text!.trimmingCharacters(in: .whitespaces)
        let parameters : [String : Any]  = [
            "email_address" : trimmedEmail
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .validateEmail) { (resp, _) in
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    self.removeActivityLoader()
                    if Login._socialVerify > 0{
                        Login._email = self.email_txt.text!
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "mobile") as! MobileViewController
                        vc.social_identifier = "social"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        SignupGolbal.email = self.email_txt.text!
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "FirstLastViewController") as! FirstLastViewController
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(resp["result"]["description"].stringValue)")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "Oops! Something went wrong")
            }
        }
    }
    
}
