//
//  ImageInfoViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 18/01/2019.
//  Copyright © 2019 Touseef Sarwar . All rights reserved.
//

import UIKit
import Kingfisher
import GooglePlaces
import SwiftyJSON

class ImageInfoViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    var photo : Photo!
    var indexOfPhoto : Int = -1
    
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var loaderView : UIView!
    
    var sectionTitle : [String] = []
    var loc : String = "No Location Tagged"
    var species : [String] = []
    var game : [String] = []
    var data : [[String]] = []
    
    
    var changeFlag : Bool = false
    var countSpecies : Int = 0
    var countGame : Int = 0
    let autocompleteController = GMSAutocompleteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = []
        self.GetData(photo_id: photo.id!)
        sectionTitle = ["Location:","Species:"]
        autocompleteController.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
//        if NetworkController.front_user_id != "0"{
//            print(ImageInfoGlobals.species.count)
//            print(ImageInfoGlobals.game.count)
//            if changeFlag || self.countSpecies != ImageInfoGlobals.species.count || self.countGame != ImageInfoGlobals.game.count{
////                self.saveBtn.isEnabled = true
//                let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Apply Changes", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Save(_:)))
//                navigationItem.rightBarButtonItems = [saveButton]
//            }else{
////                self.saveBtn.isEnabled = true
////                let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Apply Changes", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Save(_:)))
////                navigationItem.rightBarButtonItems = [saveButton]
//                self.navigationItem.rightBarButtonItems = []
//            }
//        }else{
//            navigationItem.rightBarButtonItems = []
//        }
        if self.loc == ""{
            self.loc = "No Location Tagged"
        }else{
            self.loc = ImageInfoGlobals.location
        }
        if ImageInfoGlobals.species.count > 0 || ImageInfoGlobals.game.count > 0{
            if self.species.first != "No Species Tagged"{
                self.species = ImageInfoGlobals.species
                for i in ImageInfoGlobals.game{
                    self.species.append(i)
                }
            }else{
                if self.species.count > 1{
                    self.species.remove(at: 0)
                    self.species = ImageInfoGlobals.species
                    for i in ImageInfoGlobals.game{
                        self.species.append(i)
                    }
                }else{
                    self.species.remove(at: 0)
                    self.species = ImageInfoGlobals.species
                    for i in ImageInfoGlobals.game{
                        self.species.append(i)
                    }
                }
            }
        }
        
        self.data = [[self.loc],self.species]
        
        self.tableView.reloadData()
        
        
    }

    @IBAction func close(_ sender: Any) {

        if changeFlag || self.countSpecies < ImageInfoGlobals.species.count || self.countGame < ImageInfoGlobals.game.count{
            let actionSheet = UIAlertController(title: "Click Apply Changes to save, or Discard to go back.", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Apply Changes", style: .default, handler: { _ in
                self.Add_More_Data()
            }))
            actionSheet.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { _ in
                ImageInfoGlobals.location = ""
                ImageInfoGlobals.species.removeAll()
                ImageInfoGlobals.game.removeAll()
                self.dismiss(animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }else{
            ImageInfoGlobals.location = ""
            ImageInfoGlobals.species.removeAll()
            ImageInfoGlobals.game.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }

    @IBAction func Save(_ sender: UIBarButtonItem) {
        if NetworkController.front_user_id != "0" {
            self.Add_More_Data()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
        }
    }
}


extension ImageInfoViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty == false{
            if section == 0{
                return 1
            }else{
                return self.data[section].count
            }
        }else{
            if section == 0{
                return 1
            }else{
                return 1
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoCell
        
        if data.isEmpty == false{
            cell.rowlabel.text = self.data[indexPath.section][indexPath.row]
            cell.rowlabel.numberOfLines = 0
        }
        else{
            cell.rowlabel.text = "No Species Tagged"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if section == 0{
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            titleLabel.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
            titleLabel.text = self.sectionTitle[section]
            viewHeader.addSubview(titleLabel)
            
            let button = UIButton()
            let width  : CGFloat = 60
            button.frame = CGRect(x: tableView.frame.width - width - 8 , y: 5, width: width, height: 30)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
            if NetworkController.front_user_id != "0" && self.photo.front_user_id! == NetworkController.front_user_id{
                button.isHidden = false
                button.addTarget(self , action: #selector(self.editLocation(sender:)), for: .touchUpInside)
            }else{
                button.isHidden = true
            }
            
            viewHeader.addSubview(button)
            
        }else if section == 1{
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 5, y: 5, width: 100, height: 30)
            titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            titleLabel.text = self.sectionTitle[section]
            viewHeader.addSubview(titleLabel)
            
            let button = UIButton()
            let width  : CGFloat = 60
            button.frame = CGRect(x: tableView.frame.width - width - 8 , y: 5, width: width, height: 30)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
            if NetworkController.front_user_id != "0" && self.photo.front_user_id! == NetworkController.front_user_id{
                button.isHidden = false
                button.addTarget(self , action: #selector(self.editSpecies(sender:)), for: .touchUpInside)
            }else{
                button.isHidden = true
            }
            
            viewHeader.addSubview(button)
        }
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}


// MARK: Edit Buttons for Species and Game

extension ImageInfoViewController{
    
    @objc func editSpecies(sender : UIButton){
        
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "popup") as? PopupViewController

        vc?.viewType = "ImageInfo"
        vc?.delegate = self
        let navigation = UINavigationController(rootViewController: vc!)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    @objc func editGame(sender : UIButton){
        
        let storyboard = UIStoryboard(name: "Feeds", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "popup") as? PopupViewController
//        vc?.title = "Game"
        vc?.viewType = "ImageInfo"
        vc?.delegate = self
        let navigation = UINavigationController(rootViewController: vc!)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    @objc func editLocation(sender : UIButton){
        self.present(autocompleteController, animated: true, completion: nil)
    }
}

extension ImageInfoViewController : SpeciesDelegates{
    func Total_Games_Species(count : Int, index : Int){
        
    }
    
    func ChangeOccur() {
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Apply Changes", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Save(_:)))
        self.navigationItem.rightBarButtonItems = [saveButton]
    }
}

extension ImageInfoViewController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        self.delegate.returnLocation(item: place.formattedAddress!, index: index)
//        self.location_lbl.text  = place.formattedAddress!
//        self.delegate.dismissViewController()
        
        
        self.data[0][0] = place.formattedAddress!
        ImageInfoGlobals.location = place.formattedAddress!
        self.tableView.reloadData()
        self.changeFlag = true
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//MARK: API Calls

extension ImageInfoViewController {
    
    func GetData(photo_id : String){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "feed_id" : "\(photo_id)",
            "type" : "photo"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .TaggedItems){ responce,_ in
            
            if responce != JSON.null{
                if responce["result"]["status"].boolValue == true{
                    self.loc = responce["result"]["location"].stringValue
                    if self.loc == ""{
                        self.loc = "No Location Tagged"
                    }else{
                        ImageInfoGlobals.location = self.loc
                    }
                    
                    let sp = responce["result"]["species"]
                    for s in sp{
                        let data = Species_Games(SpeciesGamesResponse: s.1)
                        self.species.append(data.name!)
                        ImageInfoGlobals.species.append(data.name!)
                    }
                  
                    let gm = responce["result"]["game"]
                    for g in gm{
                    let data = Species_Games(SpeciesGamesResponse: g.1)
                    self.species.append(data.name!)
                    ImageInfoGlobals.game.append(data.name!)
                }
                    
                    if self.species.count <= 0{
                        self.species.append("No Species Tagged")
                    }
                    self.data = [[self.loc],self.species]
                    self.countSpecies = sp.count
                    self.countGame = gm.count
                    self.tableView.reloadData()
                    self.removeActivityLoader()
                }else{
                    self.removeActivityLoader()
                    self.presentError(massageTilte: "\(String(describing: "\(responce["result"]["description"].stringValue)"))")
                }
            }else{
                self.removeActivityLoader()
                self.presentError(massageTilte: "\(String(describing: "Oops...something went wrong"))")
            }
        }
    }
    
    func Add_More_Data(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)",
            "feed_id" : "\(self.photo!.id!)",
            "type" : "photo",
            "location" : "\(ImageInfoGlobals.location)",
            "species" : "\(ImageInfoGlobals.species)",
            "game" : "\(ImageInfoGlobals.game)",
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .TagItem){ response,_ in
            
            if response != JSON.null{
                if response["result"]["status"].boolValue == true{
                    ImageInfoGlobals.location = ""
                    ImageInfoGlobals.species.removeAll()
                    ImageInfoGlobals.game.removeAll()
                    self.data.removeAll()
                    self.removeActivityLoader()
                    self.dismiss(animated: true, completion: nil)
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
