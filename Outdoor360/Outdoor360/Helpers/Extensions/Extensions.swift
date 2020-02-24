//
//  File.swift
//  Outdoor360
//
//  Created by Touseef Sarwar on 20/07/2019.
//  Copyright © 2019 Touseef Sarwar. All rights reserved.
//

import Foundation
import UIKit
import  SafariServices


extension UINavigationBar{
    
    func setGradientBackground(colors: [UIColor], startPoint: CAGradientLayer.Point = .topLeft, endPoint: CAGradientLayer.Point = .topRight) {
            var updatedFrame = bounds
            updatedFrame.size.height += self.frame.origin.y
            let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, startPoint: startPoint, endPoint: endPoint)
            setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
        }
    
    func setNavigationBar(barStyle: UIBarStyle, tintColor: UIColor, isTranslucent: Bool, font: UIFont, fontColor: UIColor) {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.barStyle = barStyle
        self.tintColor = tintColor
        self.isTranslucent = isTranslucent
        self.titleTextAttributes = [.foregroundColor: fontColor, .font: font]
    }
}

extension CAGradientLayer {
    
    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custion(point: CGPoint)
        
        var point: CGPoint {
            switch self {
            case .topRight: return CGPoint(x: 1.0, y: 0.5)
            case .topLeft: return CGPoint(x: 0.2, y: 0.5)
            case .bottomRight: return CGPoint(x: 1, y: 1)
            case .bottomLeft: return CGPoint(x: 0, y: 1)
            case .custion(let point): return point
            }
        }
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: Point, endPoint: Point) {
        self.init(frame: frame, colors: colors, startPoint: startPoint.point, endPoint: endPoint.point)
    }
    
    func createGradientImage() -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

//Table View Customization...
protocol Reusable: class{
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
        
    }
}

extension UITableViewCell: Reusable{}
extension UICollectionViewCell: Reusable{}
extension UITableViewHeaderFooterView: Reusable{}
protocol NibLoadableView {
    static var nibName: String { get }
}

extension NibLoadableView  {
    static var nibName: String {
        return String(describing: self)
    }
}


extension UICollectionView{
    func registerNib<T: UICollectionViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T  {
        //        print(T.reuseIdentifier)
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
}

extension UITableView{
    
    
   
    
    /// Register Your Cell file and identifiers.
    func register<T: UITableViewCell>(_: T.Type)  {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register Your nib file... Your class and identifier should be same as name is parameter for this.
    
    func registerNib<T: UITableViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
//        print(nib, T.reuseIdentifier)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeaderNib<T: UITableViewHeaderFooterView>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
//        print(T.reuseIdentifier, T.reuseIdentifier)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T  {
//        print(T.reuseIdentifier)
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(for section: Int) -> T  {
//        print(T.reuseIdentifier)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
}
///

//Int...
extension Int {
    
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
    
}

//String...

extension String {
    
    var html2AttributedString: NSAttributedString? {
        do {
            
            let str =  try NSAttributedString(data: Data(utf8),
                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                              documentAttributes: nil)
            return str
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    ///checking for valid url
    var isValidURL: Bool {
        let head     = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }
    
}



//TextView Extension...

extension UITextView {
    @IBInspectable var maxNumberOfLines: NSInteger {
        set {
            textContainer.maximumNumberOfLines = maxNumberOfLines
        }
        get {
            return textContainer.maximumNumberOfLines
        }
    }
    @IBInspectable var lineBreakByTruncatingTail: Bool {
        set {
            if lineBreakByTruncatingTail {
                textContainer.lineBreakMode = .byTruncatingTail
            }
        }
        get {
            return textContainer.lineBreakMode == .byTruncatingTail
        }
    }

}
