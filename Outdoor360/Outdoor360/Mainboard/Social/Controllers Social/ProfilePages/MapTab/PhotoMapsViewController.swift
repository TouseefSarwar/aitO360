//
//  PhotoMapsViewController.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 14/05/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Kingfisher

class PhotoMapsViewController: UIViewController, GMSMapViewDelegate , GMUClusterManagerDelegate {

    
    var photo : [Photo] = [Photo]()
    var myResp : JSON = JSON.null
    var current_searchData : Photo!
    
    
    var clusterManager: GMUClusterManager!
    var mapView: GMSMapView!

    var marker = GMSMarker()
    let camera = GMSCameraPosition.camera(withLatitude:40.538995, longitude: -99.050604, zoom: 2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
       // self.title = "Photo Maps"
       
        self.title = "Photos Map"
        if NetworkController.others_front_user_id != "0"{
            Fetch_Photo_Map(front_user_id: NetworkController.others_front_user_id)
        }else{
            Fetch_Photo_Map(front_user_id: NetworkController.front_user_id)
        }
        
   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "singleImage"{
            let VC = segue.destination as! ShowImageViewController
            VC.photo.append(self.current_searchData)
            VC.index = 0
        }
    }
    
    private func generateClusterItems() {
        let extent = 0.2
//        let frm = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mapView = GMSMapView.map(withFrame: self.view.bounds , camera: camera)
//        self.view = mapView
        self.view.addSubview(mapView)
        self.removeActivityLoader()
//        mapView.clear()
        let iconGenerator =  GMUDefaultClusterIconGenerator(buckets: [10,20,30,50,100], backgroundImages: [#imageLiteral(resourceName: "m1"),#imageLiteral(resourceName: "m2"),#imageLiteral(resourceName: "m3"),#imageLiteral(resourceName: "m4"),#imageLiteral(resourceName: "m5")])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
        
        for index in 0..<self.photo.count {

            let lat = photo[index].lat!  + extent * randomScale()
            let lng = photo[index].long! + extent * randomScale()
            //let name = "Item \(index)"
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.marker.position = position
            self.marker.map = self.mapView
            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), marker : self.marker , photoItem : self.photo[index])
          clusterManager.add(item)
            
        }
        clusterManager.cluster()
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        
    }
 
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
   
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.photoItem.id!)")
            
            self.current_searchData = poiItem.photoItem
            self.performSegue(withIdentifier: "singleImage", sender: self)
            
        } else {
            NSLog("Did tap a normal marker")
        }
        return true
    }
    
}
//Marker Data
class POIItem: NSObject, GMUClusterItem {
    
    var position: CLLocationCoordinate2D
    var marker : GMSMarker!
    var photoItem : Photo!
    init(position: CLLocationCoordinate2D , marker : GMSMarker , photoItem : Photo) {
        self.position = position
        self.marker = marker
        self.photoItem = photoItem
    }
    
}

//API Calls
extension PhotoMapsViewController {

    func Fetch_Photo_Map(front_user_id : String){

        self.addActivityLoader()
        let parameters : [String: Any] = [
            "front_user_id" : "\(front_user_id)"
        ]
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        NetworkController.shared.Service(parameters: parameters, nameOfService: .PhotoMap){ response,_ in
            
            if response != JSON.null {
                if response["result"]["status"].boolValue == true{
                    self.myResp = response["result"]["photos"]
                    for post in self.myResp{
                        let data = Photo(photoData: post.1)
                        self.photo.append(data)
                    }
                    print("The Count is :\(self.photo.count)")
                    self.generateClusterItems()
//                    self.removeActivityLoader()
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

