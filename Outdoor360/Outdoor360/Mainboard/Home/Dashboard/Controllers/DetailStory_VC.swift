//
//  DetailStory_VC.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 19/09/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit
import SnapKit

class DetailStory_VC: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var webView : WKWebView!
    
    var rightButton =  UIBarButtonItem()
    var story : Stories!
    var isSize = true
    var notificationURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        self.addLoader()
        
        var url : String = ""
        if notificationURL != "" {
            url = self.notificationURL
        }else{
             url = self.story.postContent!
        }
        self.webView.load(URLRequest(url: URL(string: url)!))
        rightButton =  UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(ShareStory(_:)))
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationColor(colorForNavigation: [#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.07843137255, blue: 0.1529411765, alpha: 1)])
    }

    @objc func ShareStory(_ sender : UIBarButtonItem){
        print("URL: \(self.webView.url!)")
        let str =  String(describing:  webView.url)
        let slug = str.components(separatedBy: "/")   // str.split(separator: "/")
        let pureURL = "https://www.outdoors360.com/\(slug.last!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"

        let url =  URL(string: self.story.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        let link = NSURL(string: pureURL)
        let text = "\(self.story.postTitle!) \n \n\(pureURL)"
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result{
            case .success(let value):
                let shareAll = [ text, value.image, link!] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            case .failure(let err):
                self.presentError(massageTilte: "\(err.localizedDescription)")
            }
        }

    }
    
    @IBAction func backButton(_ sender : UIBarButtonItem){
        if notificationURL != "" {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()!
            Home_VC.check = "story"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}

extension DetailStory_VC : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.removeLoader()
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString
        let urlElements = url?.components(separatedBy: ":") ?? []
        
        switch urlElements[0] {
            
        case "tel":
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler : nil)
            decisionHandler(.cancel)
        case "mailto":
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler : nil)
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
    
}
