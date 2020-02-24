//
//  ReferralVC.swift
//  Outdoor360
//
//  Created by Apple on 05/12/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol ReferralVCDelegate : class{
    @objc optional func goBack()
}

class ReferralVC: UIViewController {

    weak var delegate : ReferralVCDelegate?
    @IBOutlet weak var shareAppLinkBtn : UIButton!
    
    var isFromSetting : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
    }
    
    @IBAction func shareAppLink(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/outdoors360/id1480189267?ls=1"){
            
            let activityVC =  UIActivityViewController(activityItems: ["\(url)"], applicationActivities: nil)
            activityVC.modalPresentationStyle = .popover
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
            activityVC.completionWithItemsHandler = {(activity , completed,_, error) in
                // Return if cancelled
                if (!completed) {
                    return
                }
                self.SharedApp()
            }
        
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    @IBAction func back(_ sender : Any){
        if isFromSetting{
            self.delegate?.goBack?()
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension ReferralVC{
    func SharedApp(){
        if InternetAvailabilty.isInternetAvailable(){
            self.addActivityLoader()
            let parameters : [String: Any] = [
                "front_user_id" : NetworkController.front_user_id,
            ]
            
            NetworkController.shared.Service(parameters: parameters, nameOfService: .ShareAppLink){response,_ in
                if response != JSON.null {
                    if response["result"]["status"].boolValue == true{
//                        self.shareAppLinkBtn.isEnabled = false
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "App has been Shared successfully")
                    }else{
                        self.removeActivityLoader()
                        self.presentError(massageTilte: "\(String(describing: "\(response["result"]["description"].stringValue)"))")
                    }
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
                }
            }
        }else{
            self.presentError(massageTilte: "No Internet Connection")
        }
    }
}

