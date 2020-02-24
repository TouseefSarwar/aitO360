//
//  AppVersion_VC.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 15/10/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit

class AppVersion_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func UpdateApp(_ sender : ButtonY){
        if let url = URL(string: "https://apps.apple.com/us/app/outdoors360/id1480189267?ls=1")
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
    }
    
}
