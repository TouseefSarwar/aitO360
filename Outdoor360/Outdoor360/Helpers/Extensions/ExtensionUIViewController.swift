//
//  ExtensionUIViewController.swift
//  Outdoor360
//
//  Created by Apple on 19/11/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import UIKit
import  SafariServices

///This extension is used for loader
extension UIViewController{
    /// Static variable only can be used for loader
    static let OLoader = Loader().loadNib() as! Loader
    static let ActivityLoader = Activity().loadNib() as! Activity
    static let uploader = Progressor().loadNib() as! Progressor
    
    ///Adding Activity Loader
    func addActivityLoader(){
        UIViewController.ActivityLoader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(UIViewController.ActivityLoader)
    }
    ///removing Activity Loader
    func removeActivityLoader(){
        UIViewController.ActivityLoader.removeFromSuperview()
    }
    
    ///Adding Loader
    func addLoader(){
        UIViewController.OLoader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(UIViewController.OLoader)
    }
    ///removing Loader
    func removeLoader(){
        UIViewController.OLoader.removeFromSuperview()
    }
    
    
    ///adding Uploader
    func Uploader(){
        UIViewController.uploader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(UIViewController.uploader)
        
    }
    func uploaderValue(progressValue : Float){
        UIViewController.uploader.progressBar.setProgress(progressValue, animated: true)
        let prog = Int(progressValue * 100)
        UIViewController.uploader.progressLabel.text = "Uploading...\(prog)%"
    }
    
    func removeUploader(){
        UIViewController.uploader.removeFromSuperview()
    }
    
    ///LazyLoader or load more function
    func LazyLoader() -> UIView{
        let loadView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.bounds.width, height: CGFloat(44)))
        loadView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let imageView = UIImageView(frame: CGRect(x: loadView.center.x - 10, y: loadView.center.y - 15, width: 24.0, height: 24.0))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.gifImageWithName("loader1")
        
        
        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.origin.y + imageView.frame.height  , width: self.view.frame.width, height: 12))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        label.text = "Loading More..."
        loadView.addSubview(label)
        loadView.addSubview(imageView)
        
        return loadView
    }
    
}


extension UIViewController : Reusable{
    
    ///Alert  with Warning or Error just with single Button
    
    func presentError( massageTilte msg : String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    ///Setting The Image for navigation bar
    
    func setImageForNavigation(imageFor image : UIImage){
        
        let navController = navigationController!
        let navImageView = UIImageView()
        //        let image = #imageLiteral(resourceName: "nav_image")
        navImageView.image = image
        //        navImageView = UIImageView(image: image)
        //        let bannerWidth = navController.navigationBar.frame.width
        //        let bannerHeight = navController.navigationBar.frame.height
        //        let bannerX = bannerWidth / image.size.width / 2
        //        let bannerY = bannerHeight / image.size.height / 2
        //        navImageView.frame = CGRect(x: bannerX , y: bannerY, width: bannerWidth/2 - 20, height: bannerHeight/2 - 30)
        //        navImageView.tintColor = UIColor.white
        navImageView.contentMode = .scaleAspectFit
        navImageView.center = navController.navigationBar.center
        self.navigationItem.titleView =  navImageView
    }
    
    ///Setting navigationColors for gradients
    func setNavigationColor(colorForNavigation color : [UIColor]){
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setNavigationBar(barStyle: .black, tintColor: .white, isTranslucent: true, font: UIFont.boldSystemFont(ofSize: 17), fontColor: .white)
        navigationController?.navigationBar.setGradientBackground(colors: color)
        
    }
    
    ///Push viewcontroller using storyboard initialViewController....
    
    func initialViewController(storyboard name : String){
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    ///Push ViewController using storyboard identifier
    func pushViewController<T : UIViewController>(storyboard name : String , className class : T.Type){
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: T.reuseIdentifier)
        vc.modalPresentationStyle = .fullScreen
        //        vc.title = T.reuseIdentifier.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///showing webview with given url
    func openWebView(withURL url : String){
        let webView = SFSafariViewController(url: URL(string: url)!)
        self.present(webView, animated: true, completion: nil)
    }
    
}



