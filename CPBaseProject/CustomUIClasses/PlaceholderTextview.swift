//
//  PlaceholderTextview.swift
//  Kid Circle Pro
//
//  Created by dinesh sharma on 16/06/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import UIKit


class CommonTextView : UITextView {
    
    
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    override open func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        } else {
        }
    }
    
    open func textViewDidBeginEditing() {
        textViewDidBegin()
    }
    
    /**
     The textfield has ended an editing session.
     */
    open func textViewDidEndEditing() {
        textViewDidEnd()
    }
    
    open func textViewDidEnd() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     Creates all the animations that are used to leave the textfield in the "display input text" state.
     */
    open func textViewDidBegin() {
        fatalError("\(#function) must be overridden")
    }
}

class TextViewWithPlaceholder : CommonTextView {
    
    override open func textViewDidEnd() {
        switch text {
        case "":
            placeHolderLabel?.isHidden = false
        default:
            print()
        }
    }
    
    override open func textViewDidBegin() {
        placeHolderLabel?.isHidden = true
       
    }
    
    override open var bounds: CGRect {
        didSet {
            placeHolderLabel?.font = self.font
            placeHolderLabel?.frame = CGRect(x: 12, y: 8, width: bounds.width-30, height: 20)
        }
    }
    
    override open var text: String! {
        didSet {
            placeHolderLabel?.isHidden = text == "" ? false : true
        }
    }
    
    var placeHolderLabel : UILabel?
    
    func showPlaceHolderLabel() {
        
        placeHolderLabel = UILabel()
        placeHolderLabel?.frame = CGRect(x: 12, y: 8, width: bounds.width-30, height: 20)
        placeHolderLabel?.font = self.font
        placeHolderLabel?.text = defaultPlaceholderText
        placeHolderLabel?.textAlignment = .left
        placeHolderLabel?.textColor = placeholderColor
        placeHolderLabel?.numberOfLines = 0
        placeHolderLabel?.lineBreakMode = .byWordWrapping
        placeHolderLabel?.isUserInteractionEnabled = false
        placeHolderLabel?.sizeToFit()
        placeHolderLabel?.isHidden = text == "" ? false : true
        addSubview(placeHolderLabel!)
        
    }
    
    override func drawViewsForRect(_ rect: CGRect) {
        showPlaceHolderLabel()
    }
    
    @IBInspectable var textViewTextColor : UIColor = UIColor.black {
        didSet {
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray {
        
        didSet {
        }
    }
    
    @IBInspectable var defaultPlaceholderText : String = "" {
        
        didSet {
        }
    }
    
}

