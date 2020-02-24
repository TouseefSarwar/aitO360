//
//  TextViewX.swift
//  Yentna_App
//
//  Created by Touseef Sarwar  on 12/04/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextViewX: UITextView , UITextViewDelegate{
    
   
   
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
   
    
    
}
