//
//  UExtensionUIView.swift
//  Outdoor360
//
//  Created by Apple on 19/11/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import UIKit
import  SafariServices


//UIView...

extension UIView {
    func hideWithAnimation(hidden: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
    
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    
    
}
