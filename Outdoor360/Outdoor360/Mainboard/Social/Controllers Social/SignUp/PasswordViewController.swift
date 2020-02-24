//
//  PasswordViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 24/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON

class PasswordViewController: UIViewController {

    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var confirm_txt: UITextField!
    
    @IBOutlet weak var pass : UIButton!
    @IBOutlet weak var c_pas : UIButton!
    
    @IBOutlet weak var signingUpLabel : UILabel!
    
    
    
    var p_hide : Bool = false
    var cp_hide : Bool = false
    
    var changePassword : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if changePassword{
            self.signingUpLabel.text = "Change Password!"
        }else{
            self.getAddress()
            self.signingUpLabel.text = "Signing Up!"
        }
    }
    
    @IBAction func password_showHideAction(_ sender: Any){
        if(p_hide == true) {
            password_txt.isSecureTextEntry = true
            p_hide = false
        } else {
            password_txt.isSecureTextEntry = false
            p_hide = true
        }
    }
    
    @IBAction func c_password_showHideAction(_ sender: Any){
        if(cp_hide == true) {
            confirm_txt.isSecureTextEntry = true
            cp_hide = false
        } else {
            confirm_txt.isSecureTextEntry = false
            cp_hide = true
        }
    }
}


extension PasswordViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next_Btn(_ sender: Any) {
        if changePassword{
            if self.password_txt.text == "" && self.confirm_txt.text == "" {
                self.presentError(massageTilte: "Empty TextField(s)")
            }else{
                if isValidPassword(testStr: self.password_txt.text!){
                    if self.password_txt.text == self.confirm_txt.text!{
                        let trimmedString = self.password_txt.text!.trimmingCharacters(in: .whitespaces)
                        self.ChangePassword(pass: trimmedString)
                    }else{
                        self.presentError(massageTilte: "Password Not Matched")
                    }
                }else{
                    self.presentError(massageTilte: "Password should have atleast Upper Case, Lower Case and a digit.")
                }
            }
        }else{
            if self.password_txt.text == "" && self.confirm_txt.text == "" {
                self.presentError(massageTilte: "Empty TextField(s)")
            }else{
                if self.password_txt.text!.count >= 8{
                    if isValidPassword(testStr: self.password_txt.text!){
                        if self.password_txt.text == self.confirm_txt.text!{
                            SignupGolbal.password = self.password_txt.text!
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "mobile") as! MobileViewController
                            self.navigationController?.pushViewController(VC, animated: true)
                            
                        }else{
                            self.presentError(massageTilte: "Password Not Matched")
                        }
                    }else{
                        self.presentError(massageTilte: "Password should have atleast Upper Case, Lower Case and a digit.")
                    }
                }else{
                       self.presentError(massageTilte: "Password should have atleast 8 characters")
                }
                
            }
        }
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one uppercase,
//         at least one Special Character
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^a-zA-Z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
}

///MARK: API Calls
extension PasswordViewController {
    
    func getAddress(){
        self.addActivityLoader()
        NetworkController.shared.getNetworkIP(){ response in
            if response != JSON.null{
                SignupGolbal.address = response["ip"].stringValue
                self.removeActivityLoader()
            }else{
                self.removeActivityLoader()
            }
        }
    }
    
    func ChangePassword(pass : String) {
        self.addActivityLoader()
        let parameters : [String : Any]  = [
            "front_user_id" : NetworkController.front_user_id,
            "password" : pass
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ChangePassword) { (resp, _) in
            if resp != JSON.null{
                if resp["result"]["status"].boolValue == true{
                    self.removeActivityLoader()
                    
                    let alert = UIAlertController(title: "Password Successfully Changed", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? UINavigationController
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc! , animated: true, completion: nil)
                    }))
                    self.present(alert , animated: true, completion: nil)
                    
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
