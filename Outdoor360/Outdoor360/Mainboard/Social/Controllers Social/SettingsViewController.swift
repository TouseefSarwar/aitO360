//
//  SettingsViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 04/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import SnapKit
import Kingfisher


protocol SettingsViewControllerDelegate : class {
    func closed()
}

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var userImage: ImageViewX!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var viewPop : ViewX!
    
    @IBOutlet weak var logOutBtn : UIButton!
    @IBOutlet weak var settingBtn : UIButton!
    @IBOutlet weak var shareBtn : UIButton!
    @IBOutlet weak var reportBtn : UIButton!
    
    
    var heightOfView : Float = 0
    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
    weak var delegate  : SettingsViewControllerDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        if NetworkController.front_user_id == "0"{
            self.logOutBtn.setTitle("Sign in", for: .normal)
            self.settingBtn.snp.updateConstraints { (mk) in
                mk.top.equalTo(self.reportBtn.snp.bottom).offset(0)
                mk.height.equalTo(0)
            }
            self.shareBtn.snp.updateConstraints { (mk) in
                mk.top.equalTo(self.settingBtn.snp.bottom).offset(0)
                mk.height.equalTo(0)
            }
            self.shareBtn.isHidden = true
            self.settingBtn.isHidden = true
            self.userImage.image = #imageLiteral(resourceName: "Logo")
            self.userName.isHidden = true
            
        }else{
            self.logOutBtn.setTitle("Sign out", for: .normal)
            self.settingBtn.isHidden = true
            self.shareBtn.snp.updateConstraints { (mk) in
                mk.top.equalTo(self.settingBtn.snp.bottom).offset(8)
                mk.height.equalTo(35)
            }
            self.shareBtn.isHidden = false
            
            self.settingBtn.snp.updateConstraints { (mk) in
                mk.top.equalTo(self.reportBtn.snp.bottom).offset(0)
                mk.height.equalTo(0)
            }
            self.userName.isHidden = false
            if let img = dic!["user_image"]{
                let resource1 = ImageResource(downloadURL: URL(string: ((img as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)!, cacheKey: ((img as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
                self.userImage.kf.indicatorType = .activity
                self.userImage.kf.setImage(with: resource1)
                
            }
            
            if let name = dic!["user_name"]{
                self.userName.text = name as? String
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
   
}


//All Actions
extension SettingsViewController{
    
    @IBAction func gotoSocail(_ sender : UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
        tab_Crtl.modalPresentationStyle = .fullScreen
        self.present(tab_Crtl, animated: true, completion: nil)
    }
    
    @IBAction func SignOut(_ sender : UIButton){
        
        if sender.currentTitle == "Sign out"{
            self.addActivityLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                let loginSession = LoginManager()
                if AccessToken.current != nil{
                    loginSession.logOut()
                }
                if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers(){
                    let store  =  TWTRTwitter.sharedInstance().sessionStore
                    let userID = store.session()?.userID
                    TWTRTwitter.sharedInstance().sessionStore.logOutUserID(userID!)
                }
                UIApplication.shared.unregisterForRemoteNotifications()
                UserDefaults.standard.removeObject(forKey: "userInfo")
                self.removeActivityLoader()
                NetworkController.front_user_id = "0"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                tab_Crtl.modalPresentationStyle = .fullScreen
                self.present(tab_Crtl, animated: true, completion: nil)
                
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            weak var vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? UINavigationController
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc! , animated: true, completion: nil)
        }
        
        
        
    }
    
    //Cancel
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate.closed()
        }
    }
    //share link
    @IBAction func shareLink(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReferralVC") as! ReferralVC
        vc.delegate = self
        vc.isFromSetting = true
        let navigationControlr = UINavigationController(rootViewController: vc)
        navigationControlr.modalTransitionStyle = .crossDissolve
        self.present(navigationControlr, animated: true, completion: nil)
    }
    
    //Stories
    @IBAction func stories(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        Home_VC.check = "story"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //Trips
    @IBAction func trips(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        Home_VC.check = "trip"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //Reports
    @IBAction func reports(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        Home_VC.check = "report"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


extension SettingsViewController : ReferralVCDelegate{
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
