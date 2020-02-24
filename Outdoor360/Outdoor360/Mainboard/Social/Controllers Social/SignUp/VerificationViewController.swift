//
//  VerificationViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 26/09/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import PinCodeTextField
import SwiftyJSON


class VerificationViewController: UIViewController {

    @IBOutlet weak var pinTextField : PinCodeTextField!
    
    //Forgot Verification....
    var forgotFlag : Bool = false
    var receivedCode : String = ""
    var frontUserId :  String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pinTextField.delegate = self
        self.pinTextField.keyboardType = .numberPad
        self.pinTextField.becomeFirstResponder()
        
        if frontUserId != ""{
            ResendCode()
        }
    }
    
    @IBAction func back_Btn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func resend_Btn(_ sender: Any) {
        ResendCode()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
   
}

//MARK: Api Call



extension VerificationViewController{
    
    func VerifyCode(){
        self.addActivityLoader()
        var parameters : [String : Any] = [:]
        if self.frontUserId != "" {
            parameters = [
                "sms_code" : "\(self.pinTextField.text!)",
                "front_user_id" : "\(self.frontUserId)"
            ]
        }else{
            parameters = [
                "sms_code" : "\(self.pinTextField.text!)",
                "front_user_id" : "\(SignupGolbal.front_user_id!)"
            ]
        }
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .SmsVerify){ response,_ in
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    self.removeActivityLoader()
                    NetworkController.front_user_id = response["result"]["data"]["front_user_id"].stringValue
                    if SignupGolbal.password == nil {
                        SignupGolbal.password = ""
                    }
                    if SignupGolbal.first_name == nil{
                       SignupGolbal.first_name = ""
                    }
                    if SignupGolbal.last_name == nil{
                        SignupGolbal.last_name = ""
                    }
                    if self.frontUserId == ""{
                        let userDefaultData =  [
                            "email":"\(response["result"]["data"]["email_address"])",
                            "password":"xyzPasswor!123",
                            "front_user_id":"\(response["result"]["data"]["front_user_id"])",
                            "user_name" : "\(SignupGolbal.first_name!) \(SignupGolbal.last_name!)"
                        ]
                        UserDefaults.standard.set(userDefaultData, forKey: "userInfo")
                        UserDefaults.standard.synchronize()
                        let tab_Crtl = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                        tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[2]
                        tab_Crtl.modalPresentationStyle = .fullScreen
                        self.present(tab_Crtl, animated: true, completion: nil)
                        SignupGolbal.first_name = ""
                        SignupGolbal.last_name = ""
                        SignupGolbal.email = ""
                        SignupGolbal.password = ""
                        SignupGolbal.mobile = ""
                        SignupGolbal.address = ""
                        SignupGolbal.country_Code = ""
                        SignupGolbal.front_user_id = ""
                    }else{
                        let userDefaultData =  [
                            "email":"\(response["result"]["data"]["email_address"])",
                            "password":"xyzPasswor!123",
                            "front_user_id":"\(response["result"]["data"]["front_user_id"])",
                            "user_image" : "\(response["result"]["data"]["user_image"])",
                            "user_name" : "\(response["result"]["data"]["user_name"])"
                        ]
                        UserDefaults.standard.set(userDefaultData, forKey: "userInfo")
                        UserDefaults.standard.synchronize()
                        UIApplication.shared.registerForRemoteNotifications()
//                        let res = LoginSignupResponse(LoginData: response["result"]["data"])
                        let tab_Crtl = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                        tab_Crtl.selectedViewController = tab_Crtl.viewControllers?[0]
                        tab_Crtl.modalPresentationStyle = .fullScreen
                        self.present(tab_Crtl, animated: true, completion: nil)
                    }
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

    func ResendCode(){
        self.addActivityLoader()
        var parameters : [String : Any] = [:]
        if self.frontUserId != "" {
            parameters = [
                "front_user_id" : "\(self.frontUserId)"
            ]
        }else{
            parameters = [
                "front_user_id" : "\(SignupGolbal.front_user_id!)"
            ]
        }
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .ResendSmsCode) { (response,_) in
            
            if response != JSON.null{
                
                if response["result"]["status"].boolValue == true{
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


extension VerificationViewController : PinCodeTextFieldDelegate{
    
    func textFieldValueChanged(_ textField: PinCodeTextField){
        if textField.text?.count == 4 {
            if forgotFlag{
                if self.pinTextField.text == self.receivedCode{
                    self.addActivityLoader()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.removeActivityLoader()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc =  storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
                        vc.changePassword = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    self.presentError(massageTilte: "Invalid Code Entered")
                }
            }else{
                if self.pinTextField.text?.count != 4 {
                    self.presentError(massageTilte: "Incomplete Verification Code!")
                }else{
                    VerifyCode()
                }
            }
        }
    }
}
