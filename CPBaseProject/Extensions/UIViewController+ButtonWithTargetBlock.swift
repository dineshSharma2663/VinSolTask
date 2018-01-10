//
//  UIViewController.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import UIKit
import Foundation

class ButtonWithTargetBlock : UIButton {
    
    var targetBlock :(() -> Void)?
    
    func triggerActionHandleBlock() {
        targetBlock!()
    }
    
    func actionHandle(controlEvents control :UIControlEvents, ForAction action:@escaping () -> Void) {
        targetBlock = action
        self.addTarget(self, action: #selector(triggerActionHandleBlock), for: .touchUpInside)
    }
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    var originalButtonImage : UIImage?
    var originalSemantics : UISemanticContentAttribute!
    
    func showLoading() {
        originalSemantics = self.semanticContentAttribute
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.currentImage
        self.setTitle("", for: UIControlState.normal)
        self.setImage(nil, for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.semanticContentAttribute = self.originalSemantics
        self.setImage(originalButtonImage, for: .normal)
        self.setTitle(originalButtonText, for: UIControlState.normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}

extension UIViewController {
    
    //MARK: - Check network availability
    
    func addRightBarItemButton (buttonImage: UIImage? = nil,buttonTitle :String? = nil,titleColor:UIColor = UIColor.white,targetAction:@escaping()->Void) -> ButtonWithTargetBlock? {
        
        let rightButton  = ButtonWithTargetBlock(frame: CGRect(x: 0, y: 0, width: 50, height: 22))
        rightButton.setTitleColor(titleColor, for: .normal)
        rightButton.tintColor = UIColor.white
        rightButton.semanticContentAttribute = .forceRightToLeft
        rightButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        rightButton.titleLabel?.font = UIFont(name:APP_CONSTANT.themeFontNormal, size: 16.0)!
        _ = buttonImage != nil ? rightButton.setImage(buttonImage!, for: .normal) : print()
        let spacingBetweenImageAndTile = (buttonImage != nil && buttonTitle != nil) ? "  " : ""
        _ = buttonTitle != nil ? rightButton.setTitle( spacingBetweenImageAndTile + buttonTitle!, for: .normal) : print()
        rightButton.sizeToFit()
        rightButton.semanticContentAttribute = .forceRightToLeft
        rightButton.actionHandle(controlEvents: .touchUpInside, ForAction: targetAction)
        let rightItem: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        var temp = (self.navigationItem.rightBarButtonItems != nil) ? self.navigationItem.rightBarButtonItems : []
        temp?.append(rightItem)
        self.navigationItem.rightBarButtonItems = temp
        return rightButton
    }
    
    func addLeftBarItemButton (buttonImage: UIImage? = nil,buttonTitle :String? = nil,titleColor:UIColor = UIColor.white,targetAction:@escaping()->Void) -> ButtonWithTargetBlock? {
        
        let leftButton  = ButtonWithTargetBlock(frame: CGRect(x: 0, y: 0, width: 50, height: 22))
        leftButton.setTitleColor(titleColor, for: .normal)
        leftButton.setTitleColor(UIColor.gray, for: .highlighted)

        leftButton.titleLabel?.font = UIFont(name:APP_CONSTANT.themeFontNormal, size: 16.0)!
        _ = buttonImage != nil ? leftButton.setImage(buttonImage!, for: .normal) : print()
        _ = buttonTitle != nil ? leftButton.setTitle(buttonTitle!, for: .normal) : print()
        leftButton.sizeToFit()
        leftButton.actionHandle(controlEvents: .touchUpInside, ForAction: targetAction)
        let leftItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftItem
        return leftButton
        
    }

    //MARK: - Check network availability
    func isNetworkAvailable()->Bool{
        let reachability = Reachability.init()
        if (reachability?.isReachable)!{
            return true
        }
        return false
    }
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    func showAlert(title : String, message:String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Actions on Apple Push notification or PUSHER
    func actionPushNotification(userInfo : [String:AnyObject], notificationType : NSNumber)
    {
        switch notificationType {
        case 100:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "REQUEST_ACCEPTED"), object: nil, userInfo: userInfo)
            break
            default:
            print("anything in default")
        }
    }
}


