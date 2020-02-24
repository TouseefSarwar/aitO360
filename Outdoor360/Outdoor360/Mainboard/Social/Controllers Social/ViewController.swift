//
//  ViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 15/02/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var loaderView: UIView!
    
    
    var location : CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.AddNavLeftButtonItem()
        self.navigationController?.navigationBar.tintColor = .white
        
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: .white, .font : UIFont.boldSystemFont(ofSize: 17)]
    }
    
    
    
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
    
    @IBAction func Login(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "SignUpwithEmailViewController") as? SignUpwithEmailViewController
        vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
   
}

