//
//  UINavigationBarX.swift
//  Document_App
//
//  Created by Touseef Sarwar  on 10/01/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import UIKit
@IBDesignable
class UINavigationBarX: UINavigationBar
{
   
    
    @IBInspectable var hideBorder : Bool = false {
        didSet{
            if hideBorder
            {
                self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.shadowImage = UIImage()
            }
        }
    }
    
    
    
    
    
    @IBInspectable var firstColor : UIColor = UIColor.clear {
        didSet{
              UpdateView()
        }
      
    }
    @IBInspectable var secondColor : UIColor = UIColor.clear {
        didSet{
            UpdateView()
        }
    }
    
    @IBInspectable var HorizontalGradient : Bool = false {
        didSet{
            UpdateView()
        }
    }
    
  
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func UpdateView(){
        
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [firstColor.cgColor , secondColor.cgColor]
        if HorizontalGradient{
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        else{
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
    }
    
    
}
