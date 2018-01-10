//
//  SingletonModel.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift



class Singleton : NSObject {
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    static var shared = Singleton()
    var currenctSymbolConstant = "$"
    
    
    func showErrorMessage(message:String) {
        StatusBarErrorMessage.sharedInstance.showHideStatusBar(message: message, dismissAfter: APP_CONSTANT.STATUS_BAR_MESSAGE_DISMISS_TIME, style: .error)
    }

    
    func initialiseIQKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
    }

    
    func checkNumberOrString(yourText:AnyObject?) -> String{
        var yourString:String!
        
        switch(yourText)
        {
        case let x as NSNumber:
            yourString = String(describing: x)
        case _ as String:
            yourString = yourText as! String
        default:
            yourString = ""
        }
        
        return yourString
    }

    func showFullScreenLoading(message: String? = nil){
        
        let loader = ActivityData(size: nil, message: (message == nil ? nil : "\n" + message!) , messageFont: UIFont(name: "Avenir-Medium", size: 16.0), type: NVActivityIndicatorType.ballTrianglePath, color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(loader)
    }
    
    func stopLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func getStringFromParams(yourData:AnyObject)->String? {
        do {
            let involvedUsersArrayData = try? JSONSerialization.data(withJSONObject: yourData, options: JSONSerialization.WritingOptions())
            let involvedUsersArrayString = NSString(data: involvedUsersArrayData!, encoding: String.Encoding.utf8.rawValue)
            return involvedUsersArrayString as String?
        }
    }
  
    
  

    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    
}
