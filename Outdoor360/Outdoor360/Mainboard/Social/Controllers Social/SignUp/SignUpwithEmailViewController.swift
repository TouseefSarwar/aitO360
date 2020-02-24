//
//  SignUpwithEmailViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 06/10/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import TwitterKit
import GoogleSignIn

class SignUpwithEmailViewController: UIViewController {

    
    var socialResponse : LoginSignupResponse = LoginSignupResponse()
    var dataResponse : JSON = JSON.null
    @IBOutlet weak var loader: UIView!
    let login_btn = LoginManager()
    @IBOutlet weak var googleBtn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.googleBtn.isHidden = true
        if AccessToken.current != nil{
            login_btn.logOut()
        }
        GIDSignIn.sharedInstance().signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.AddNavLeftButtonItem()
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }

    @IBAction func Signup_with_email_Btn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "email") as! EmailViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    
    
}
///Navigation Bar back button
extension SignUpwithEmailViewController{
    
    func AddNavLeftButtonItem(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.setTitle(" Back", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17 )
        button.sizeToFit()
        button.addTarget(self, action: #selector(GotoHome(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    
    ///NEw button to go back to Dashboard
    @objc func GotoHome(_ sender : UIBarButtonItem){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
        tab_Crtl.modalPresentationStyle = .fullScreen
        self.present(tab_Crtl, animated: true, completion: nil)
    }
    
}



//MARK: Social SignUp Fb,LI,TW....
extension SignUpwithEmailViewController{
    
    //    MARK: FaceBook
    @IBAction func sigupFacebook_Btn(_ sender: Any) {
        
        if AccessToken.current == nil {
            login_btn.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                self.addActivityLoader()
                if result != nil{
                    self.getFBUserData()
                }else{
                    self.login_btn.logOut()
                }
            }
            
        }else{
            login_btn.logOut()
        }
        
    }
    
    //    MARK: Twitter
    
    @IBAction func signupTwitter_Btn(_ sender: Any) {
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers(){
            let store  =  TWTRTwitter.sharedInstance().sessionStore
            let userID = store.session()?.userID
            TWTRTwitter.sharedInstance().sessionStore.logOutUserID(userID!)
        }else{
            print("Logged in Session active....")
        }
        self.addActivityLoader()
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            
            if session != nil{
                self.addActivityLoader()
                let client = TWTRAPIClient.withCurrentUser()
                let req = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=ture", parameters: ["include_email": "true", "skip_status": "`"], error: nil)
                client.sendTwitterRequest(req, completion: { (response, data, err) in
                    if err == nil {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                            //                            print("Json response: ", json)
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
                self.removeActivityLoader()
                print(error?.localizedDescription ?? "Error Not Found")
                self.presentError(massageTilte: error?.localizedDescription ?? "Error Not Found")
            }
        }

    }
    
    @IBAction func loginWithGoogle(_ sender: Any){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension SignUpwithEmailViewController : GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.addActivityLoader()
        if error == nil{
//            _ = user.authentication.idToken // Safe to send to the server
//            _ = user.profile.givenName
//            _ = user.profile.familyName
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
                    self.SocialLogin(first_name: first , last_name: last , email: email! , id: userId!,  location: response["ip"].stringValue, type: "google")
                }
            }
        }else{
            self.removeActivityLoader()
            print("\(error.localizedDescription)")
            self.presentError(massageTilte: "\(error.localizedDescription)")
        }
        
        
    }
}

// MARK: FaceBook signup Settings...
extension SignUpwithEmailViewController{
    
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
            print("here")
        }
    }
    
}

extension SignUpwithEmailViewController{
    
    func SocialLogin(first_name : String, last_name : String,email : String,id : String, location : String,type : String ) {
        if AppDelegate.accessToken == nil
        {    AppDelegate.accessToken = "f281e3359fc09E7574d9c18d715e3840h1aec4788182fa33441a852e00c20b9d"
        }
        let parameters : [String : Any]  = [
            "first_name" : "\(first_name)" ,
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
                    if self.socialResponse.email == "" {
                        //send to email View
                        Login._socialVerify = Int(self.socialResponse.social_type!)!
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "email") as! EmailViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if self.socialResponse.mobile_number == "" && self.socialResponse.sms_verified == "0" {
//                        self.performSegue(withIdentifier: "number", sender: self)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "mobile") as! MobileViewController
                        VC.social_identifier = "social"
                        self.navigationController?.pushViewController(VC, animated: true)
                    }else if self.socialResponse.mobile_number != "" && self.socialResponse.sms_verified == "0"{
                        SignupGolbal.mobile = self.socialResponse.mobile_number
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                        self.navigationController?.pushViewController(VC, animated: true)
//                        self.performSegue(withIdentifier: "verify", sender: self)
                    }else if self.socialResponse.mobile_number != "" &&
                        self.socialResponse.sms_verified != ""  {
                        
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
                    self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
            
        }
    }
}

