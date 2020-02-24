//
//  TabbarX.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 30/06/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TabbarX : UITabBar{
    
    
    
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
       
        let layer1 =  self.layer as! CAGradientLayer
        layer1.colors = [ firstColor.cgColor, secondColor.cgColor ]
        
        if (horizontalGradient) {
            layer1.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer1.endPoint = CGPoint(x: 1.0, y: 0.5)
//            layer1.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
//            self.layer.insertSublayer(layer1, at: 0)
            
//            self.layer.addSublayer(layer1)
        } else {
            layer1.startPoint = CGPoint(x: 0, y: 0)
            layer1.endPoint = CGPoint(x: 0, y: 1)
            
//            layer1.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
//              self.layer.insertSublayer(layer1, at: 0)
//             self.layer.addSublayer(layer1)
        }
    }
}
