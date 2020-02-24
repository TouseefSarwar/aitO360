//
//  FlagViewController.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 23/09/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import SwiftyJSON

class FlagViewController: UIViewController {
    @IBOutlet weak var loaderView : UIView!
    @IBOutlet weak var  inappro : UIButton!
    @IBOutlet weak var  spam : UIButton!
    @IBOutlet weak var  other : UIButton!
    @IBOutlet weak var  submit : UIButton!
    
    var selectedReason : String = ""
    var postId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Flag post"
        self.submit.isEnabled = false
    }
    
    
    @IBAction func inappropriateButton(_ sender : UIButton){
        selectedReason = "1"
        self.submit.isEnabled = true
        self.inappro.setImage(#imageLiteral(resourceName: "On_radio"), for: .normal)
        self.spam.setImage(#imageLiteral(resourceName: "Off_radio"), for: .normal)
        self.other.setImage(#imageLiteral(resourceName: "Off_radio"), for: .normal)
    }
    
    
    @IBAction func spamButton(_ sender : UIButton){
        selectedReason = "2"
        self.submit.isEnabled = true
        self.inappro.setImage(#imageLiteral(resourceName: "Off_radio"), for: .normal)
        self.spam.setImage(#imageLiteral(resourceName: "On_radio"), for: .normal)
        self.other.setImage(#imageLiteral(resourceName: "Off_radio"), for: .normal)
    }
    
    @IBAction func ohterButton(_ sender : UIButton){
        selectedReason = "3"
        self.submit.isEnabled = true
        self.inappro.setImage(#imageLiteral(resourceName: "Off_radio"), for: .normal)
        self.spam.setImage(#imageLiteral(resourceName: "Off_radio"), for: .normal)
        self.other.setImage(#imageLiteral(resourceName: "On_radio"), for: .normal)
    }
    
    
    @IBAction func submitButton(_ sender : UIButton){
        FlagPost()
    }
    
}


extension FlagViewController{
    func FlagPost(){
        self.removeActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "post_id" : self.postId,
            "flag" : selectedReason,
            "type" : "post"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Flag){
            response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true {
                    
                    self.removeActivityLoader()
                    self.navigationController?.popToRootViewController(animated: true)
//                    self.presentError(massageTilte: "Post Flagged")
//                    self.dismiss(animated: true, completion: nil)
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
