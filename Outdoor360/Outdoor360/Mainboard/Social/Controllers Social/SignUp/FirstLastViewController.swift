//
//  SignUpViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 20/02/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import Alamofire

class FirstLastViewController: UIViewController {

    @IBOutlet weak var firstName_Txt: UITextField!
    @IBOutlet weak var lastName_Txt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
extension FirstLastViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func next_Btn(_ sender: Any) {
        
        if self.firstName_Txt.text == "" && self.lastName_Txt.text == "" {
            let alert = UIAlertController(title: "Empty Text field(s)+", message: nil , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{

            SignupGolbal.first_name = self.firstName_Txt.text!
            SignupGolbal.last_name = self.lastName_Txt.text!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    func ValidateSignUp() -> Bool {
        var flag = false
        if firstName_Txt.text != "" && lastName_Txt.text != ""{
           flag = true
        }
        else {
            flag = false
            let alert = UIAlertController(title: "Empty Text field(s)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return flag
    }

    func SignUp(){
        let url = "http://plandstudios.com/project101/app/signup"
        let parameters : Parameters = [
            "first_name":"",
            "last_name":"",
            "email":"",
            "pass":"",
            "country_code":"",
            "mobile_number": ""]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(){ response in
        
            if response.result.isSuccess
            {
                print("\(response)")
            }
            else
            {
                let alert = UIAlertController(title: "Oops...something went wrong", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    
}
