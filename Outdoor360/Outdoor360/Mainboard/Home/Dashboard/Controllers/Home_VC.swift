//
//  Dashboard_VC.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class Home_VC: UIViewController {

    //NOdata Image and label initializing
    @IBOutlet weak var noDataLabel : UILabel!
    @IBOutlet weak var noImage : UIImageView!
    
    
    @IBOutlet weak var tableView : UITableView!
//    @IBOutlet weak var tabCollection : UICollectionView!
    
    
//    var tabImages : [String] = ["social-1","story-1","trip","report" ,"search" ]
//    var tabLabel : [String] = [" Social","Stories","Trips","Reports","Search"]
    var refresh = UIRefreshControl()
//    var titleHeaders = "EXPLORE STORIES"
    var isLoading : Bool = false
    var dic = UserDefaults.standard.dictionary(forKey: "userInfo")
//    var homedata : HomeData!
    
    var story : [Stories] = []
    var trips : [Trips] = []
    var reports : [Reports] = []
    
    ///check report story or trip
    static var  check : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.tabBarController?.selectedIndex = 0
        
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(RefreshData(_:)), for: .valueChanged)

        self.setImageForNavigation(imageFor: #imageLiteral(resourceName: "navigationHeader"))
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
        if Home_VC.check == "story"{
            self.FetchStoriesData()
        }else if Home_VC.check == "trip"{
            self.FetchTripsData()
        }else{
            FetchReportsData()
        }
        tableView.registerNib(Image_Cell.self)
        tableView.registerNib(Bar_Cell.self)
        tableView.registerNib(Story_Cell.self)
        tableView.registerNib(Trip_Cell.self)
        tableView.registerNib(Report_Cell.self)
        tableView.registerHeaderNib(HeaderDash.self)
//        SelectedTab.index = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.AddNavLeftRightButtonItem()
        
    }
    
    
//    @IBAction func back(_ sender : UIBarButtonItem){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
//        self.present(tab_Crtl, animated: true, completion: nil)
//    }

    
    func AddNavLeftRightButtonItem(){
        if NetworkController.front_user_id != "0"{
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let imageview = UIImageView(frame: CGRect(x: 8, y: 5, width: 34, height: 34))
            imageview.contentMode = UIView.ContentMode.scaleAspectFill
            imageview.layer.borderColor = UIColor.white.cgColor
            imageview.layer.masksToBounds = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            imageview.addGestureRecognizer(tapGesture)
            imageview.isUserInteractionEnabled = true
            
            containView.addSubview(imageview)
            let rightBarButton = UIBarButtonItem(customView: containView)
            self.navigationItem.rightBarButtonItem = rightBarButton
            if let img = dic!["user_image"]{
                NetworkController.user_image = img as! String
                imageview.layer.cornerRadius = 17
                imageview.layer.borderWidth = 0.5
                
            }else{
                imageview.image = #imageLiteral(resourceName: "logo_1")
                return
            }
            
            ImageDownloader.default.downloadImage(with: URL(string: NetworkController.user_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) {  [weak self] (result) in
                switch result{
                case .success(let val):
                    imageview.image = val.image
                case .failure(let err):
                    print("\(err)")
                }
            }
            
            
        }else{
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let imageview = UIImageView(frame: CGRect(x: 8, y: 2, width: 34, height: 34))
            imageview.image = #imageLiteral(resourceName: "logo_1")
            //            imageview.layer.borderWidth = 0.5
            //            imageview.layer.borderColor = UIColor.white.cgColor
            imageview.contentMode = UIView.ContentMode.scaleAspectFill
            imageview.layer.cornerRadius = 17
            imageview.layer.masksToBounds = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            imageview.addGestureRecognizer(tapGesture)
            imageview.isUserInteractionEnabled = true
            
            containView.addSubview(imageview)
            let rightBarButton = UIBarButtonItem(customView: containView)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    ///Right Image Object Navigation
    @objc func imageTapped(_ sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? SettingsViewController
        vc?.heightOfView = 0
        vc?.delegate = self
        vc?.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc!, animated: true)
    }

    @objc func RefreshData(_ sender : Any){
        if Home_VC.check == "story"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.FetchStoriesData()
            }
        }else if Home_VC.check == "trip"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.FetchTripsData()
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.FetchReportsData()
            }
        }
    }
}

extension Home_VC : SettingsViewControllerDelegate{
    func closed() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

////Extension for tabs
//extension Home_VC : UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.tabImages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let tabs : Tab_Cell = tabCollection.dequeueReusableCell(for: indexPath)
//        tabs.imageIcon.image =  UIImage(named: self.tabImages[indexPath.row])
//        tabs.labelName.text = self.tabLabel[indexPath.row]
//        tabs.contentView.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)
//        tabs.imageIcon.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        tabs.labelName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//
//        if indexPath.row == SelectedTab.index{
//            tabs.line.backgroundColor = .white
//        }else{
//            tabs.line.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)
//        }
//
//        return tabs
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            SelectedTab.index = indexPath.row
//            self.tabCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            self.tabCollection.reloadData()
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let tab_Crtl = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
//            self.present(tab_Crtl, animated: true, completion: nil)
//        }else if indexPath.row == 1 {
//            self.titleHeaders = "EXPLORE STORIES"
//            SelectedTab.index = indexPath.row
//            self.FetchStoriesData()
//            self.tableView.scrollsToTop = true
//            self.tableView.reloadData()
//            self.tabCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            self.tabCollection.reloadData()
//
//
//
//        }else if indexPath.row == 2 {
//            self.titleHeaders = "BOOK TRIPS"
//            SelectedTab.index = indexPath.row
//            self.FetchTripsData()
//            self.tableView.scrollsToTop = true
//            self.tableView.reloadData()
//            self.tabCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            self.tabCollection.reloadData()
//
//        }else if indexPath.row == 3 {
//            self.titleHeaders = "READ REPORTS"
//            SelectedTab.index = indexPath.row
//            self.FetchReportsData()
//            self.tableView.scrollsToTop = true
//            self.tableView.reloadData()
//            self.tabCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            self.tabCollection.reloadData()
//
//        }else{
//            SelectedTab.index = indexPath.row
//            self.tabCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            self.tabCollection.reloadData()
//            self.pushViewController(storyboard: "Search", className: Search_VC.self)
//        }
//    }
//
//
//}
//


//TableView Delegates and DataSource...

extension Home_VC : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnCount : Int = 0
        if Home_VC.check == "story"{
            returnCount = self.story.count
        }else if Home_VC.check == "trip"{
            returnCount = self.trips.count
        }else{
            returnCount = self.reports.count
        }
        return returnCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Home_VC.check == "story"{
            let stories : Story_Cell = tableView.dequeueReusableCell(for: indexPath)
            if self.story.count > 0{
                print(indexPath.row)
                
                if self.story[indexPath.row].image != "" && self.story[indexPath.row].image != nil{
                    let res = ImageResource(downloadURL: URL(string: self.story[indexPath.row].image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                    stories.coverImage.kf.indicatorType = .activity
                    stories.coverImage.kf.setImage(with: res)
                    
                }else{
                    stories.coverImage.image = #imageLiteral(resourceName: "noImage")
                }
                stories.title.text = self.story[indexPath.row].postTitle!
            }
            return stories
        }else if Home_VC.check == "trip"{
            let trip : Trip_Cell = tableView.dequeueReusableCell(for: indexPath)
            if self.trips.count > 0{
                if self.trips[indexPath.row].image != "" && self.trips[indexPath.row].image != nil{
                    let res = ImageResource(downloadURL: URL(string: self.trips[indexPath.row].image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                    trip.coverImage.kf.indicatorType = .activity
                    trip.coverImage.kf.setImage(with: res)
                    
                }else{
                    trip.coverImage.image = #imageLiteral(resourceName: "noImage")
                }
                
                trip.title.text = self.trips[indexPath.row].title!
                trip.startFrom.text =  "Starting from $" + self.trips[indexPath.row].tripRate!
                trip.location.text = self.trips[indexPath.row].address!
                trip.guideName.text =  self.trips[indexPath.row].guideName!
                let resGuide = ImageResource(downloadURL: URL(string: self.trips[indexPath.row].guideImage!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                trip.guideImage.kf.indicatorType = .activity
                trip.guideImage.kf.setImage(with: resGuide)
            }
            return trip

        }else{
            let report : Report_Cell = tableView.dequeueReusableCell(for: indexPath)
            if self.reports.count > 0{
                if self.reports[indexPath.row].image != "" && self.reports[indexPath.row].image != nil{
                    let res = ImageResource(downloadURL: URL(string: self.reports[indexPath.row].image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                    report.coverImage.kf.indicatorType = .activity
                    report.coverImage.kf.setImage(with: res)
                }else{
                    report.coverImage.image = #imageLiteral(resourceName: "noImage")
                }
                report.location.text = reports[indexPath.row].address!
                report.title.text = reports[indexPath.row].title!
                
            }
            return report
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Home_VC.check == "story"{
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailStory_VC") as! DetailStory_VC
            vc.story = self.story[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else if Home_VC.check == "trip"{
            self.openWebView(withURL: self.trips[indexPath.row].tripLink!)
        }else{
            self.openWebView(withURL: self.reports[indexPath.row].reportLink!)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if Home_VC.check == "story"{
            if indexPath.row == self.story.count - 1 && !isLoading{
                self.tableView.tableFooterView = self.LazyLoader()
                self.tableView.tableFooterView?.isHidden = false
                self.LoadMoreStories()
                
            }
        }else if Home_VC.check == "trip"{
            if indexPath.row == self.trips.count - 1 && !isLoading{
                self.tableView.tableFooterView = self.LazyLoader()
                self.tableView.tableFooterView?.isHidden = false
                self.LoadMoreTrips()
            }
            
        }else{
            if indexPath.row == self.trips.count - 1 && !isLoading{
                self.tableView.tableFooterView = self.LazyLoader()
                self.tableView.tableFooterView?.isHidden = false
                self.LoadMoreReports()
            }
            
        }
        
    }
}

extension Home_VC{
    
    //Fetching Trips...
    func FetchTripsData(){
        
        if !self.refresh.isRefreshing{
            self.addLoader()
        }
        
        let parameters : [String : Any] = [
            "front_user_id" : "0",
            "sendlist" : "",
        ]
//        self.isItemsHidden(boolValue: true)
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Trips) { (respJSON,status) in
            if respJSON != JSON.null{
                if respJSON["result"]["status"].boolValue == true{
                    let resp = respJSON["result"]["trips"]
                    for item in resp{
                        let data = Trips(fromJson: item.1)
                        self.trips.append(data)
                    }
                    self.isLoading = false
                    self.refresh.endRefreshing()
                    self.removeLoader()
                    self.tableView.tableFooterView?.isHidden = true
                    self.tableView.scrollsToTop = true
                    self.tableView.reloadData()
                }else{
                    self.removeLoader()
                    self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
                }
            }else{
                self.removeLoader()
                self.presentError(massageTilte: "Something went wrong...")
            }
        }
    }
    
    //Loading More.....
    func LoadMoreTrips(){
        
        isLoading = true
        var sendIds : [String] = []
        for i in self.trips{
            sendIds.append(i.tripId!)
        }
        
        //        print(sendIds)
        let parameters : [String : Any] = [
            "front_user_id" : "0",
            "sendlist" : sendIds.joined(separator: ","),
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Trips) { (respJSON,status) in
            if respJSON != JSON.null{
                if respJSON["result"]["status"].boolValue == true{
                    let resp = respJSON["result"]["trips"]
                    for item in resp{
                        let data = Trips(fromJson: item.1)
                        self.trips.append(data)
                    }
                    self.isLoading = false
                    
                    self.tableView.tableFooterView?.isHidden = true
                    self.tableView.reloadData()
                }else{
                    self.tableView.tableFooterView?.isHidden = true
                    self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
                }
            }else{
                self.tableView.tableFooterView?.isHidden = true
                self.presentError(massageTilte: "Something went wrong...")
            }
        }
    }
    
    ///Fetching Reports Data
    func FetchReportsData(){
        if !self.refresh.isRefreshing{
            self.addLoader()
        }
        let parameters : [String : Any] = [
            "front_user_id" : "0",
            "sendlist" : "",
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Reports) { (respJSON,status)  in
            if respJSON != JSON.null{
                if respJSON["result"]["status"].boolValue == true{
                    let resp = respJSON["result"]["reports"]
                    for item in resp{
                        let data = Reports(fromJson: item.1)
                        self.reports.append(data)
                    }
                    self.refresh.endRefreshing()
                    self.removeLoader()
                    self.tableView.scrollsToTop = true
                    self.tableView.reloadData()
                }else{
                    self.removeLoader()
                    self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
                }
            }else{
                self.removeLoader()
                self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
            }
        }
    }
        
    ///Loading More Reports
    func LoadMoreReports(){
        
        isLoading = true
        var sendIds : [String] = []
        for i in self.reports{
            sendIds.append(i.reportId!)
        }
        let parameters : [String : Any] = [
            "front_user_id" : "0",
            "sendlist" : sendIds.joined(separator: ","),
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Reports) { (respJSON,status) in
            if respJSON != JSON.null{
                if respJSON["result"]["status"].boolValue == true{
                    let resp = respJSON["result"]["reports"]
                    for item in resp{
                        let data = Reports(fromJson: item.1)
                        self.reports.append(data)
                    }
                    if resp.count > 0{
                        self.isLoading = false
                    }
                    
                    self.tableView.tableFooterView?.isHidden = true
                    self.tableView.reloadData()
                }else{
                    self.tableView.tableFooterView?.isHidden = true
                    self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
                }
            }else{
                self.tableView.tableFooterView?.isHidden = true
                self.presentError(massageTilte: "Something went wrong...")
            }
        }
    }
    
    //fetch stories....
    func FetchStoriesData(){
        
        if !self.refresh.isRefreshing{
            self.addLoader()
        }
        
        let parameters : [String : Any] = [
            "front_user_id" : "0",
            "sendlist" : "",
        ]
        
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Stories) { (respJSON,status) in
            if respJSON != JSON.null{
                
                if respJSON["result"]["status"].boolValue == true{
                    let resp = respJSON["result"]["blogs"]
                    print(resp)
                    for item in resp{
                        let data = Stories(fromJson: item.1)
                        self.story.append(data)
                    }
                    self.isLoading = false
                    self.refresh.endRefreshing()
                    self.removeLoader()
                    self.tableView.scrollsToTop = true
                    self.tableView.reloadData()
                }else{
                    self.removeLoader()
                    self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
                }
            }else{
                self.removeLoader()
                self.presentError(massageTilte: "Something went wrong...")
            }
        }
    }
    
    //Loading...
    func LoadMoreStories(){
        
        isLoading = true
        var sendIds : [String] = []
        
        for i in self.story{
            sendIds.append(i.iD!)
        }
        
        let parameters : [String : Any] = [
            "front_user_id" : "0",
            "sendlist" : sendIds.joined(separator: ","),
        ]
        print(parameters)
        NetworkController.shared.Service(parameters: parameters, nameOfService: .Stories) { (respJSON,status) in
            if respJSON != JSON.null{
                if respJSON["result"]["status"].boolValue == true{
                    let resp = respJSON["result"]["blogs"]
                    for item in resp{
                        let data = Stories(fromJson: item.1)
                        self.story.append(data)
                    }
                    self.isLoading = false
                    self.tableView.tableFooterView?.isHidden = true
                    self.tableView.reloadData()
                }else{
                    self.tableView.tableFooterView?.isHidden = true
                    self.presentError(massageTilte: "\(respJSON["result"]["description"].stringValue)")
                }
            }else{
                self.tableView.tableFooterView?.isHidden = true
                self.presentError(massageTilte: "Something went wrong...")
            }
        }
    }
    
}




//
//extension Home_VC{
//
//    func FetchHomePage(){
//
//        if !self.refresh.isRefreshing{
//            self.addLoader()
//        }
//
//        let parameters : [String : Any] = [
//            "front_user_id" : "0",
//        ]
//        NetworkController.shared.Service(parameters: parameters, nameOfService: .Home) { (respJSON, status)  in
//
//            //            print(respJSON["result"]["blogs"])
//            if status == 1{
//                let resp = respJSON["result"]
//                self.homedata = HomeData(fromJson: resp)
//                if self.homedata.status == true{
//
//                    self.removeLoader()
//                    self.refresh.endRefreshing()
//                    self.tableView.reloadData()
//                }else{
//                    self.removeLoader()
//                    self.presentError(massageTilte: "\(String(describing: self.homedata.descriptionField))")
//                }
//            }else if status == 0{
//                self.removeLoader()
//                self.presentError(massageTilte: "The data you are trying to fetch is no available. Please try again!")
//            }else if status == 2{
//                self.removeLoader()
//                self.presentError(massageTilte: "No internet connection! Make sure that wifi or Mobile data is turned on, Try again!")
//            }
//        }
//    }
//}
