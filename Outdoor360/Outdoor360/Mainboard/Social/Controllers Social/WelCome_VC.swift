//
//  WelCome_VC.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 23/10/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit

class WelCome_VC: UIViewController {

    @IBOutlet weak var welcomeImg : UIImageView!
    @IBOutlet weak var qoute : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            weak var tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController
            tab_Crtl?.modalPresentationStyle = .fullScreen
            self.present(tab_Crtl!, animated: true, completion: nil)
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

//    @IBAction func goToOutdoor(_ sender : ButtonY){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        weak var tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController
//        tab_Crtl?.modalPresentationStyle = .fullScreen
//        self.present(tab_Crtl!, animated: true, completion: nil)
//    }

}
