//
//  PopupViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 08/05/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol SpeciesDelegates{
    func Total_Games_Species(count : Int, index : Int)
    @objc optional func ChangeOccur()
}


class PopupViewController: UIViewController {

    
    
    weak var delegate : SpeciesDelegates?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView : UIView!
    var data : [Species_Games] = []
    var filter_Species : [Species_Games] = []
    var isSearching : Bool = false
    
    var game : [String] = []
    var specy : [String] = []

//    static var selectedSpecies : [String] = []
//    static var selectedGame : [String] = []
    
    
    var index : Int!
    var viewType : String!  // View type should be "ImageInfo" or "CreatePost"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "PopupTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        title = "Species"
//        if title == "Game"{
        
//        }else{
            GetSpecies()
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        
    }
  

    
    @IBAction func done_Btn(_ sender: Any) {
        
        if self.viewType == "ImageInfo"{
//            if self.title == "Game"{
                ImageInfoGlobals.game = self.game
//                print(ImageInfoGlobals.game)
//                self.dismiss(animated: true, completion: nil)
//            }else{
                ImageInfoGlobals.species = self.specy
//                print(ImageInfoGlobals.species)
                self.dismiss(animated: true, completion: nil)
//            }
        }else{
//            if self.title == "Game"{
                let str = self.game.joined(separator: ",")
                PostUpdateGlobal.g_games[index!] = str
//                self.delegate.Total_Games_Species(count: self.game.count, index:  index)
//                self.dismiss(animated: true, completion: nil)
            
//            }else{
                let strsp = self.specy.joined(separator: ",")
                PostUpdateGlobal.g_species[index!] = strsp
//                self.delegate.Total_Games_Species(count: self.specy.count, index:  index)
                self.dismiss(animated: true, completion: nil)
//            }
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
// MARK: Search Bar Delegate Methods...

extension PopupViewController : UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        self.searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filter_Species = data.filter({ (searchGuides) -> Bool in
//            let stringSearch = searchGuides.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
//
//            if self.searchBar.text == nil || searchBar.text == "" {
//                isSearching = false
//                self.tableView.reloadData()
//            }else{
//                isSearching = true
//                self.tableView.reloadData()
//            }
//            return (stringSearch != nil)
//
//        })
        
        filter_Species = data.filter { $0.name!.range(of: searchText, options: .caseInsensitive) != nil}
            if self.searchBar.text == nil || searchBar.text == "" {
                isSearching = false
                view.endEditing(true)
                self.tableView.reloadData()
            }else{
                isSearching = true
                self.tableView.reloadData()
            }
        
        
        
        self.tableView.reloadData()
        
//        self.tableView.reloadData()
//        filter_Species = data.filter({$0.prefix(searchText.count) == searchText})
//        //
//
//        if self.searchBar.text == nil || searchBar.text == "" {
//            isSearching = false
//            // to dismiss keyboard
//            view.endEditing(true)
//            self.tableView.reloadData()
//        }else{
//            isSearching = true
//            self.tableView.reloadData()
//
//        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
}


// Mark-: TableView DataSources and delegatex
extension PopupViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return self.filter_Species.count
        }else{
            return self.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PopupTableViewCell
        if isSearching{
            
//            if self.title == "Game"{
            
            cell.lbl.text = self.filter_Species[indexPath.row].name
//                cell.isSearching = self.isSearching
            if self.data[indexPath.row].type! == "game" {
                if game.contains(filter_Species[indexPath.row].name!)
                {
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else{
                if specy.contains(filter_Species[indexPath.row].name!)
                {
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            
                
//            }else{
//                cell.lbl.text = self.filter_Species[indexPath.row]
//                cell.isSearching = self.isSearching
            
//            }
        }else{
//            if self.title == "Game"{
                cell.lbl.text = data[indexPath.row].name!
//                cell.isSearching = self.isSearching
            
            if self.data[indexPath.row].type! == "game" {
                if game.contains(self.data[indexPath.row].name!){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else{
                if specy.contains(self.data[indexPath.row].name!){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.ChangeOccur!()
        if isSearching{
//            if self.title == "Game"{
            if self.data[indexPath.row].type! == "game"{
//                print(self.data[indexPath.row].type!)
                if game.contains(self.filter_Species[indexPath.row].name!){
                    let index = self.game.firstIndex(of: self.filter_Species[indexPath.row].name!)
                    self.game.remove(at: index!)
                    self.tableView.reloadData()
                    
                }else{
                    self.game.append(filter_Species[indexPath.row].name!)
                    self.tableView.reloadData()
                }
            }else{
                if specy.contains(self.filter_Species[indexPath.row].name!){
                    let index = self.specy.firstIndex(of: self.filter_Species[indexPath.row].name!)
                    self.specy.remove(at: index!)
                    self.tableView.reloadData()
                    
                }else{
                    self.specy.append(filter_Species[indexPath.row].name!)
                    self.tableView.reloadData()
                }
            }
            
        }else{
//            if self.title == "Game"{
           
            
            if self.data[indexPath.row].type! == "game"{
                if game.contains(self.data[indexPath.row].name!){
                    let index = self.game.firstIndex(of: self.data[indexPath.row].name!)
                    self.game.remove(at: index!)
                    self.tableView.reloadData()
                    
                }else{
                    self.game.append(self.data[indexPath.row].name!)
                    self.tableView.reloadData()
                }
            }else{
                if specy.contains(self.data[indexPath.row].name!){
                    let index = self.specy.firstIndex(of: self.data[indexPath.row].name!)
                    self.specy.remove(at: index!)
                    self.tableView.reloadData()
                    
                }else{
                    self.specy.append(self.data[indexPath.row].name!)
                    self.tableView.reloadData()
                }
            }
            
//                if game.contains(self.data[indexPath.row]){
//                    let index = self.game.firstIndex(of: self.data[indexPath.row])
//                    self.game.remove(at: index!)
//                    self.tableView.reloadData()
//
//                }else{
//                    self.game.append(self.data[indexPath.row])
//                    self.tableView.reloadData()
//                }
//
////            }else{
//                if specy.contains(self.data[indexPath.row]){
//                    let index = self.specy.firstIndex(of: self.data[indexPath.row])
//                    self.specy.remove(at: index!)
//                    self.tableView.reloadData()
//
//                }else{
//                    self.specy.append(self.data[indexPath.row])
//                    self.tableView.reloadData()
//                }
//            }
            
        }

        
        
    }
}

// MARK: Fetching Species and game API's

extension PopupViewController{
    func GetSpecies(){
        
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Species){ response,_ in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["data"]
             
                    for post in resp{
                        let data = Species_Games(SpeciesGamesResponse: post.1)
                        self.data.append(data)
                    }
                    
                    if self.viewType == "ImageInfo"{
                        for item in ImageInfoGlobals.species{
                            self.specy.append(item)
                        }
                    }else{
                        let sp = PostUpdateGlobal.g_species[self.index].split(separator: ",")
                        for item in sp{
                            self.specy.append(String(item))
                        }
                    }
                    self.GetGames()
//                    self.tableView.reloadData()
//                    self.removeActivityLoader()
                }else{
                    self.removeActivityLoader()
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil , preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                self.removeActivityLoader()
                let alert =  UIAlertController(title : "Oops...something went wrong" , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func GetGames(){
        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(NetworkController.front_user_id)"
        ]
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Games){ response,_ in
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    let resp = response["result"]["data"]
                
                    for post in resp
                    {
                        let data = Species_Games(SpeciesGamesResponse: post.1)
                        self.data.append(data)
                    }
                    if self.viewType == "ImageInfo"{
                        for item in ImageInfoGlobals.game{
                            self.game.append(item)
                        }
                    }else{
                        let sp = PostUpdateGlobal.g_games[self.index].split(separator: ",")
                        for item in sp{
                            self.game.append(String(item))
                        }
                    }
                    self.data = self.data.sorted(by: { $0.name! < $1.name! })
                    self.tableView.reloadData()
                    self.removeActivityLoader()
                }else{
                    self.removeActivityLoader()
                    let alert =  UIAlertController(title : "\(response["result"]["description"].stringValue)" , message : nil, preferredStyle :UIAlertController.Style.alert )
                    alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                        //                        self.dismiss(animated: true, completion: nil)
                    }))
                    //                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                self.removeActivityLoader()
                let alert =  UIAlertController(title : "Oops...something went wrong"  , message : nil, preferredStyle :UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title : "Ok" , style : UIAlertAction.Style.cancel , handler : { (Void) in
                    //                    self.dismiss(animated: true, completion: nil)
                }))
                //                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
