//
//  UIView.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIColor {
    static var textFieldPlaceHolderTextColor: UIColor  { return UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 0.75) }
    static var themeColor: UIColor  { return UIColor(red: 35/255.0, green: 159/255.0, blue: 133/255.0, alpha: 1.0) }
    static var successColor: UIColor  { return UIColor(red: 11/255.0, green: 148/255.0, blue: 68/255.0, alpha: 1.0) }
    static var errorColor: UIColor  { return UIColor(red: 232/255.0, green: 98/255.0, blue: 109/255.0, alpha: 1.0) }
}



extension UITextField {
    
    func addDropDownImage() {
        let image = UIImage(named:"dropDown")
        
        let rightView = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 25))
        rightView.image = image?.withRenderingMode(.alwaysTemplate)
        rightView.tintColor = UIColor.lightGray
        rightView.contentMode = .center
        rightView.clipsToBounds = true
        self.rightView = rightView
        self.rightViewMode = .always
    }
}

extension UILabel {
    
    func addAttributedString(firstString : String,secondString : String,firstColor : UIColor, secondColor : UIColor,firstFont : UIFont, secondFont : UIFont,lineSpacing : CGFloat = 6.0,alignMent : NSTextAlignment = .center) {
        let firstString = firstString
        let secondString = secondString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignMent
        
        let myMutableString = NSMutableAttributedString(string: firstString + secondString)
        myMutableString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, (firstString + secondString).length))
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: firstColor, range: NSRange(location:0,length:firstString.length))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: secondColor, range: NSRange(location:firstString.length,length:secondString.length))
        myMutableString.addAttribute(NSFontAttributeName, value: firstFont, range: NSRange(location:0,length:firstString.length))
        myMutableString.addAttribute(NSFontAttributeName, value: secondFont, range: NSRange(location:firstString.length,length:secondString.length))
        self.attributedText = myMutableString
    }
}

extension UIView {
    
    @IBInspectable var setThemeColor : Bool {
            get {
                return false
            }set {
                _ = (newValue == true)  ? (self.backgroundColor = UIColor.themeColor) : print("")
            }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func commonpopAppearAnimation() {
        let transformAnim            = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values         = [NSValue(caTransform3D: CATransform3DMakeScale(0.2, 0.2, 1)),
                                        NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1)),NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1))]
        transformAnim.duration       = 0.6
        self.layer.add(transformAnim, forKey: "transform")
    }
    
    
    @IBInspectable var borderWidth : CGFloat {
        
        get {
            return layer.borderWidth
        }set {
            self.layer.borderWidth = newValue
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }set {
            self.layer.borderColor = newValue.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
 
    @IBInspectable var shadowColorView: UIColor {
        get {
            return self.shadowColorView
        }set {
            self.addShadow(shadowColor : newValue.cgColor)
        }
    }
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

extension UIButton {

    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setImageWithColor(_ color: UIColor, forUIControlState state: UIControlState) {
        self.setImage(imageWithColor(color), for: state)
    } 
    func setBackgroundColor(_ color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), for: state)
    }
    
    func alignTextUnderImage(padding: CGFloat = 25.0) {
        guard let imageView = imageView else {
            return
        }
        let imageSize: CGSize = imageView.image!.size
        titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + padding), 0.0)
        let labelString = NSString(string: titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: titleLabel!.font])
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + padding), 0.0, 0.0, -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0)
    }
} 


