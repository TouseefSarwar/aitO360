//
//  LoginViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 20/02/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn

class LoginViewController: UIViewController {

    
    var socialResponse : LoginSignupResponse = LoginSignupResponse()
    var dataResponse : JSON = JSON.null
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtfield: UITextField!
    @IBOutlet weak var loader : UIView!
    @IBOutlet weak var fbBtn : ButtonY!
    @IBOutlet weak var twBtn : ButtonY!
    @IBOutlet weak var loginBtn : ButtonY!
    @IBOutlet weak var forgotBtn : UIButton!
    @IBOutlet weak var eyeBtn : UIButton!
    @IBOutlet weak var passImage : UIImageView!
    
    
    @IBOutlet weak var googleBtn : UIButton!
    
    
    var showPass = false
    let login_btn = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil{
            login_btn.logOut()
        }
        GIDSignIn.sharedInstance().signOut()
        AddNavLeftButtonItem()
        
    }
    
    
    @IBAction func showHide(_ sender : UIButton){
        if showPass {
            passwordTxtfield.isSecureTextEntry = true
            showPass = false
        }else{
            passwordTxtfield.isSecureTextEntry = false
            showPass = true
        }
    }
    
    @IBAction func close_keyboard(_ sender: Any) {
        emailTxtField.resignFirstResponder()
        passwordTxtfield.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTxtField.text = ""
        self.passwordTxtfield.text = ""
        self.AddNavLeftButtonItem()
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(self.socialResponse.front_user_id!)")
        if segue.identifier == "newFeeds"{
            let tabCtrl = segue.destination as! UITabBarController
            let nav = tabCtrl.viewControllers![0] as! UINavigationController
            let _ : NewFeedsViewController  =  nav.topViewController as! NewFeedsViewController
        }else if segue.identifier == "number"{
            let vc = segue.destination as! MobileViewController
            vc.social_identifier = "social"
        }else if segue.identifier == "verify"{

        }
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    func validateFields() -> Bool {
        var success = false
        if emailTxtField.hasText && passwordTxtfield.hasText  {
            success = true
        }else{
            let alert =  UIAlertController(title : "Empty TextFeilds" , message : nil, preferredStyle :UIAlertController.Style.alert )
            alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.default , handler : nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return success
    }
    
    func isHideElements(_sender: Bool){
        if _sender{
            self.passwordTxtfield.isHidden = _sender
            self.fbBtn.isHidden = _sender
            self.twBtn.isHidden = _sender
            self.passImage.isHidden = _sender
            self.googleBtn.isHidden = _sender
            self.eyeBtn.isHidden = _sender
            self.loginBtn.setTitle("Reset password", for: .normal)
            self.forgotBtn.setTitle("Go Back", for: .normal)
        }else{
            self.passwordTxtfield.isHidden = _sender
            self.fbBtn.isHidden = _sender
            self.twBtn.isHidden = _sender
            self.passImage.isHidden = _sender
            self.eyeBtn.isHidden = _sender
            self.googleBtn.isHidden = _sender
            self.loginBtn.setTitle("Login", for: .normal)
            self.forgotBtn.setTitle("Forgot Password?", for: .normal)
        }
    }
}
///Navigation Bar back button
extension LoginViewController{
    
    func AddNavLeftButtonItem(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.setTitle(" Back", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17 )
        button.sizeToFit()
        button.addTarget(self, action: #selector(GotoHome(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    
    ///New button to go back to Dashboard
    @objc func GotoHome(_ sender : UIBarButtonItem){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
        tab_Crtl.modalPresentationStyle = .fullScreen
        self.present(tab_Crtl, animated: true, completion: nil)
    }
    
}


///MARK: Forgot Password Module
extension LoginViewController{
    
    @IBAction func forgotPass(_ sender : UIButton){
        if sender.currentTitle == "Forgot Password?"{
            self.isHideElements(_sender: true)
        }else{
            self.isHideElements(_sender: false)
        }
        
    }
    
}

// MARK: Login Btns
extension LoginViewController {
    
    @IBAction func LoginButton(_ sender: ButtonY) {
        if sender.currentTitle != "Login"{
            if emailTxtField.hasText{
                if isValidEmail(testStr: emailTxtField.text!){
                    self.Forgot()
                }else{
                    self.presentError(massageTilte: "Incorrect Email Format")
                }
                
            }else{
                self.presentError(massageTilte: "Please! Enter email address to recover password.")
            }
        }else{
            if validateFields(){
                if isValidEmail(testStr: emailTxtField.text!){
                    if InternetAvailabilty.isInternetAvailable(){
                        self.addActivityLoader()
                        Login._email = emailTxtField.text!.trimmingCharacters(in: .whitespaces)
                        Login._password = passwordTxtfield.text!
                        if AppDelegate.accessToken == nil{
                            AppDelegate.accessToken = "f281e3359fc09E7574d9c18d715e3840h1aec4788182fa33441a852e00c20b9d"
                        }
                        let parameters : [String : Any]  = [
                            "email" : "\(Login._email)",
                            "pass" : "\(Login._password)",
                            "device_id" : AppDelegate.accessToken!,
                            "device_type" : "ios"
                        ]
                        
                        NetworkController.shared.Service(parameters: parameters, nameOfService: .Login){ responseJSON,_ in
                            
                            if responseJSON != JSON.null{
                                if responseJSON["result"]["status"].boolValue == true{
//                                    print(responseJSON["result"])
                                    self.removeActivityLoader()
//                                    if responseJSON["result"]["sms_verified"].stringValue == "0"{
//                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                        let VC = storyboard.instantiateViewController(withIdentifier: "mobile") as! MobileViewController
//                                        self.navigationController!.pushViewController(VC, animated: true)
//                                    }else{
                                        let userDefaultData =  [
                                            "email":"\(self.emailTxtField.text!)",
                                            "password":"\(self.passwordTxtfield.text!)",
                                            "front_user_id":"\(responseJSON["result"]["data"]["front_user_id"])",
                                            "user_image" : "\(responseJSON["result"]["data"]["user_image"])",
                                            "user_name" : "\(responseJSON["result"]["data"]["user_name"])"
                                        ]
                                        UserDefaults.standard.set(userDefaultData, forKey: "userInfo")
                                        UserDefaults.standard.synchronize()
                                        UIApplication.shared.registerForRemoteNotifications()
                                        self.socialResponse = LoginSignupResponse(LoginData: responseJSON["result"]["data"])
                                        self.performSegue(withIdentifier: "newFeeds", sender: self)
//                                    }
                                    
                                }else{
                                    self.removeActivityLoader()
                                    self.presentError(massageTilte: "\(responseJSON["result"]["description"].stringValue)")
                                }
                            }else{
                                self.removeActivityLoader()
                                self.presentError(massageTilte: "Oops...something went wrong")
                            }
                        }
                    }else{
                        self.presentError(massageTilte: "No Internet Connection")
                    }

                }else{
                    self.presentError(massageTilte: "Incorrect Email Format")
                }
            }
        }
        
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {

        if AccessToken.current == nil {
            login_btn.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                self.addActivityLoader()
                if result != nil{
                    self.getFBUserData()
                }else{
                    self.removeActivityLoader()
                    self.login_btn.logOut()
                }
            }
        }else{
            self.removeActivityLoader()
            login_btn.logOut()
        }
        
        
    }
    
    @IBAction func loginWithTwitter(_ sender: Any) {
        
        if TWTRTwitter.sharedInstance().sessionStore.session() != nil {
            if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers(){
                let store  =  TWTRTwitter.sharedInstance().sessionStore
                let userID = store.session()?.userID
                TWTRTwitter.sharedInstance().sessionStore.logOutUserID(userID!)
            }
        }
       
        self.addActivityLoader()
        TWTRTwitter.sharedInstance().logIn { (session, error) in
                if session != nil{
                    let client = TWTRAPIClient.withCurrentUser()
                    let req = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=ture", parameters: ["include_email": "true", "skip_status": "`"], error: nil)
                    
                    client.sendTwitterRequest(req, completion: { (response, data, err) in
                        if err == nil {
                            do{
                                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                                let firstName = json["name"]
                                _ = json["screen_name"]
                                let email = json["email"]
                                let id = json["id"]
                                SignupGolbal.first_name = firstName as? String
                                SignupGolbal.email = email as? String
                                let parts = (firstName as! String).split(separator: " ")
                                var first = ""
                                var last = ""
                                for i in 0..<parts.count {
                                    if i == parts.count - 1{
                                        last = String(parts[i])
                                    }else{
                                        first = String(parts[i])
                                    }
                                }
                                NetworkController.shared.getNetworkIP(){ response in
                                    if response != JSON.null{
                                        self.SocialLogin(first_name: first , last_name: last, email: SignupGolbal.email, id: String(describing: id!),  location: response["ip"].stringValue, type: "twitter")
                                    }
                                }
                            } catch {
                                
                            }
                            
                        }else{
                            print("Error 1:\(err.debugDescription)")
                            self.removeActivityLoader()
                            self.presentError(massageTilte : err.debugDescription )
                        }
                    })
                }else{
                    print("Error 2: \(error.debugDescription)")
                    self.removeActivityLoader()
                    self.presentError(massageTilte : error.debugDescription )
                }
        }
        
        
        
        
    }
    
    @IBAction func loginWithGoogle(_ sender: Any){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
}

extension LoginViewController : GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.addActivityLoader()
        if error == nil{
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let idToken = user.authentication.idToken // Safe to send to the server
            let userId = user.userID                  // For client-side use only!
            let fullName = user.profile.name
            let email = user.profile.email
            SignupGolbal.first_name = fullName ?? ""
            SignupGolbal.email = email ?? ""
            
            let parts = fullName?.split(separator: " ")
            var first = ""
            var last = ""
            for i in 0..<parts!.count {
                
                if i == parts!.count - 1{
                    last = String(parts![i])
                }else{
                    first = String(parts![i])
                }
            }
            NetworkController.shared.getNetworkIP(){ response in
                if response != JSON.null{
                    self.SocialLogin(first_name: first , last_name: last, email: email! , id: userId!,  location: response["ip"].stringValue, type: "google")
                }
            }
            
            
        }else{
            self.removeActivityLoader()
            self.presentError(massageTilte: "\(error.localizedDescription)")
        }
        
        
    }
}

// MARK: Social Functions
extension LoginViewController{
    
    // Fetch Facebook Data...!
    func getFBUserData(){

        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil && result != nil{
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    
                    SignupGolbal.first_name = data["first_name"] as? String
                    SignupGolbal.last_name = data["last_name"] as? String
                    if let em = data["email"] {
                        SignupGolbal.email = em as? String
                    }else{
                        SignupGolbal.email = ""
                    }
                    
                    
                    NetworkController.shared.getNetworkIP(){ response in
                        if response != JSON.null{
                            
                            self.SocialLogin(first_name: SignupGolbal.first_name , last_name: SignupGolbal.last_name, email: SignupGolbal.email, id: data["id"] as! String, location: response["ip"].stringValue, type: "facebook")
                        }
                    }

                }
            })
        }else{
            self.removeActivityLoader()
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}

//MARK: Api
extension LoginViewController{

    func SocialLogin(first_name : String, last_name : String,email : String,id : String, location : String,type : String ) {
        if InternetAvailabilty.isInternetAvailable(){
            let parameters : [String : Any]  = [
                "first_name" : "\(first_name)",
                "last_name" : "\(last_name)",
                "email" : "\(email)",
                "id" : "\(id)",
                "location" : "\(location)",
                "type" : "\(type)",
                "device_id" : AppDelegate.accessToken!,
                "device_type" : "ios"
            ]
            
            NetworkController.shared.Service(parameters: parameters, nameOfService: .SocialLogin){ response,_ in
                if response != JSON.null{
                    
                    if response["result"]["status"].boolValue == true{
                        //TODO: Response for social login from server...
                        
                        self.socialResponse = LoginSignupResponse(LoginData: response["result"]["data"])
                        self.removeActivityLoader()
                      
                        SignupGolbal.front_user_id = self.socialResponse.front_user_id
                        if self.socialResponse.email == ""{
                            //send to email View
                            Login._socialVerify = Int(self.socialResponse.social_type!)!
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "email") as! EmailViewController
                            self.navigationController!.pushViewController(vc, animated: true)
                        }else if self.socialResponse.mobile_number == "" && (self.socialResponse.sms_verified == "0"  || self.socialResponse.sms_verified == ""){
    //                        self.performSegue(withIdentifier: "number", sender: self)
                            SignupGolbal.email = self.socialResponse.email
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "mobile") as! MobileViewController
                            VC.social_identifier = "social"
                            self.navigationController!.pushViewController(VC, animated: true)
                        }else if self.socialResponse.mobile_number != "" && (self.socialResponse.sms_verified == "0"  || self.socialResponse.sms_verified == "") {
                            SignupGolbal.mobile = self.socialResponse.mobile_number
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                            self.navigationController?.pushViewController(VC, animated: true)
                            
                        
                        }else if self.socialResponse.mobile_number != "" &&
                            (self.socialResponse.sms_verified != "" || self.socialResponse.sms_verified != "0") {
                            let userDefaultData =  [
                                "email": self.socialResponse.email,
                                "password": self.socialResponse.password,
                                "front_user_id": self.socialResponse.front_user_id,
                                "user_image" : self.socialResponse.user_image,
                                "user_name" : self.socialResponse.first_name! + " " + self.socialResponse.last_name!
                            ]
                            UserDefaults.standard.set(userDefaultData, forKey: "userInfo")
                            UserDefaults.standard.synchronize()
                            self.performSegue(withIdentifier: "newFeeds", sender: self)
                            
                        }
                        
                    }else{
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "\(response["result"]["description"].stringValue)")
                    }
                }
                else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte:  "Oops...something went wrong" )
                }
                
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
    
    func Forgot() {
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String : Any]  = [
                "email_address" : self.emailTxtField.text!.trimmingCharacters(in: .whitespaces)
            ]
            
            NetworkController.shared.Service(parameters: parameters, nameOfService: .ForgotPassword) { (resp, _) in
                if resp != JSON.null{
                    if resp["result"]["status"].boolValue == true{
                        self.removeActivityLoader()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                        vc.forgotFlag = true
                        vc.receivedCode = resp["result"]["sms_code"].stringValue
                        print("Code Received: \(vc.receivedCode)")
                        NetworkController.front_user_id = resp["result"]["front_user_id"].stringValue
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "\(resp["result"]["description"].stringValue)")
                    }
                    
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "Oops! Something went wrong")
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
}
