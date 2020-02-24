//
//  Label+Extension.swift
//  Nikahfy
//
//  Created by Muhammad Tayyab on 04/12/2019.
//  Copyright © 2019 Muhammad Tayyab. All rights reserved.
//
import UIKit

// How to use it
//titleLabel.text = "Welcome"
//titleLabel.font = UIFont.systemFont(ofSize: 70, weight: .bold)
//titleLabel.textColor = UIColor.black
//titleLabel.changeFont(ofText: "lc", with: UIFont.systemFont(ofSize: 60, weight: .light))
//titleLabel.changeTextColor(ofText: "el", with: UIColor.blue)
//titleLabel.changeTextColor(ofText: "co", with: UIColor.red)
//titleLabel.changeTextColor(ofText: "m", with: UIColor.green)




// How To Use It

//    func didTapLabel(){
//        lbl_TermsPrivacyPolicy.underLineText(ofText: "Terms") // Posted user Name
//        lbl_TermsPrivacyPolicy.underLineText(ofText: "Privacy Policy") // user that share with
//        lbl_TermsPrivacyPolicy.changeFont(ofText: "Terms", with: UIFont.Font(.SofiaPro, type: .Light, size: 15))
//        lbl_TermsPrivacyPolicy.changeFont(ofText: "Privacy Policy", with: UIFont.Font(.SofiaPro, type: .Light, size: 15))
//        lbl_TermsPrivacyPolicy.changeTextColor(ofText: "Terms", with: UIColor.AppColor(color: .PrimaryColor))
//        lbl_TermsPrivacyPolicy.changeTextColor(ofText: "Privacy Policy", with: UIColor.AppColor(color: .PrimaryColor))
//        lbl_TermsPrivacyPolicy.addTapGesture(tagId: 1, target: self, action: #selector(lbl_Tapped(_:)))
//    }
//
//    @objc func lbl_Tapped(_ sender: UITapGestureRecognizer){
//            let signupString = lbl_TermsPrivacyPolicy.text! as String
//            let termsRange = signupString.range(ofText: "Terms")
//            let privacyPolicyRange = signupString.range(ofText: "Privacy Policy")
//
//            let tapLocation = sender.location(in: lbl_TermsPrivacyPolicy)
//            let index = lbl_TermsPrivacyPolicy.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
//
//            if String.CheckRange(termsRange, contain: index) == true {
//                // Perfom Action There
//                return
//            }
//
//            if String.CheckRange(privacyPolicyRange, contain: index) {
//                // Perform Action there
//                return
//            }
//    }


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}


//extension UILabel {
//    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
//        assert(self.attributedText != nil, "This method is developed for attributed string")
//        let textStorage = NSTextStorage(attributedString: self.attributedText!)
//        let layoutManager = NSLayoutManager()
//        textStorage.addLayoutManager(layoutManager)
//        let textContainer = NSTextContainer(size: self.frame.size)
//        textContainer.lineFragmentPadding = 0
//        textContainer.maximumNumberOfLines = self.numberOfLines
//        textContainer.lineBreakMode = self.lineBreakMode
//        layoutManager.addTextContainer(textContainer)
//
//        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//        return index
//    }
//}

//extension UILabel {
//    func set(image: UIImage, with text: String) {
//        let attachment = NSTextAttachment()
//        attachment.image = image
//        attachment.bounds = CGRect(x: 0, y: -3, width: 25, height: 20)
//        let attachmentStr = NSAttributedString(attachment: attachment)
//
//        let mutableAttributedString = NSMutableAttributedString()
//        mutableAttributedString.append(attachmentStr)
//
//        let textString = NSAttributedString(string: text, attributes: [.font: self.font])
//        mutableAttributedString.append(textString)
//
//        self.attributedText = mutableAttributedString
//        self.textAlignment = .left
//    }
//}




public protocol ChangableFont: AnyObject {
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    var rangedAttributes: [RangedAttributes] { get }
    func getFont() -> UIFont?
    func changeFont(ofText text: String, with font: UIFont)
    func changeFont(inRange range: NSRange, with font: UIFont)
    func changeTextColor(ofText text: String, with color: UIColor)
    func changeTextColor(inRange range: NSRange, with color: UIColor)
    func resetFontChanges()
}

public struct RangedAttributes {
    
    let attributes: [NSAttributedString.Key: Any]
    let range: NSRange
    
    public init(_ attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        self.attributes = attributes
        self.range = range
    }
}

extension UILabel: ChangableFont {
    
    public func getFont() -> UIFont? {
        return font
    }
}

extension UITextField: ChangableFont {
    
    public func getFont() -> UIFont? {
        return font
    }
}

public extension ChangableFont {
    
    var rangedAttributes: [RangedAttributes] {
        guard let attributedText = attributedText else {
            return []
        }
        var rangedAttributes: [RangedAttributes] = []
        let fullRange = NSRange(
            location: 0,
            length: attributedText.string.count
        )
        attributedText.enumerateAttributes(
            in: fullRange,
            options: []
        ) { (attributes, range, stop) in
            guard range != fullRange, !attributes.isEmpty else { return }
            rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        }
        return rangedAttributes
    }
    
    func changeFont(ofText text: String, with font: UIFont) {
        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
        changeFont(inRange: range, with: font)
    }
    
    func changeFont(inRange range: NSRange, with font: UIFont) {
        add(attributes: [.font: font], inRange: range)
    }
    
    func changeTextColor(ofText text: String, with color: UIColor) {
        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
        changeTextColor(inRange: range, with: color)
    }
    
    func changeTextColor(inRange range: NSRange, with color: UIColor) {
        add(attributes: [.foregroundColor: color], inRange: range)
    }
    
    private func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        guard !attributes.isEmpty else { return }
        
        var rangedAttributes: [RangedAttributes] = self.rangedAttributes
        
        var attributedString: NSMutableAttributedString
        
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }
        
        rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        
        rangedAttributes.forEach { (rangedAttributes) in
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: rangedAttributes.range
            )
        }
        
        attributedText = attributedString
    }
    
    func resetFontChanges() {
        guard let text = text else { return }
        attributedText = NSMutableAttributedString(string: text)
    }
}


public extension String {
    
    func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }
}
