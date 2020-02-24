//
//  LabelX.swift
//  Yentna_App
//
//  Created by Touseef Sarwar on 12/07/2018.
//  Copyright © 2018 Touseef Sarwar . All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LabelX: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)
        }
    }
}
