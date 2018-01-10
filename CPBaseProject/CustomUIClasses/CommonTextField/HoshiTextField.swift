//
//  HoshiTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 An HoshiTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
@IBDesignable open class HoshiTextField: TextFieldEffects {
    
    /**
     The color of the border when it has no content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable var textThemeColor : Bool {
        get {
            return false
        }set {
            _ = (newValue == true)  ? (self.textColor = UIColor.themeColor) : print("")
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable dynamic open var inActiveleftImageColor: UIColor = .black {
        didSet {
            //updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var activeleftImageColor: UIColor = .black {
        didSet {
            //updatePlaceholder()
        }
    }
    
   

    
    /**
     The color of the placeholder text.

     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
    */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var fullLayerBorder: Bool = false {
        didSet {
            setBorder()
        }
    }
    
    @IBInspectable dynamic open var bottomLayerBorder: Bool = false {
        didSet {
            //setBorder()
            layer.addSublayer(inactiveBorderLayer)
            layer.addSublayer(activeBorderLayer)
        }
    }
    
    func setBorder(){
        self.layer.borderColor = borderInactiveColor?.cgColor
        self.layer.borderWidth = 0.7
        self.layer.masksToBounds = true
    }

    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    @IBInspectable public var leftSpacer:CGFloat = 0.0 {
         didSet {
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftSpacer, height: frame.size.height))
            updateLeftPadding()
        }
    }
    
    var leftImageView : UIImageView?
    @IBInspectable public var leftViewImage:UIImage? {
        get {
            return nil
        }
        set {
            if newValue != nil {
                 leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: leftSpacer, height: 22))
                leftImageView?.image = newValue?.withRenderingMode(.alwaysTemplate)
                leftImageView?.tintColor = UIColor.themeColor
                leftImageView?.contentMode = .center
                leftView = leftImageView
                leftViewMode = .always
            }
        }
    }
    
    
    func updateLeftPadding() {
         placeholderInsets = CGPoint(x: leftSpacer, y: 5)
         textFieldInsets = CGPoint(x: leftSpacer, y: 9)
    }
    
     let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    private var placeholderInsets = CGPoint(x: 0, y: 0)
    private var textFieldInsets = CGPoint(x: 0, y: 9)
     let inactiveBorderLayer = CALayer()
     let activeBorderLayer = CALayer()    
     var activePlaceholderPoint: CGPoint = CGPoint.zero
    
    // MARK: - TextFieldsEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        print(placeholderLabel.frame)
        placeholderLabel.font = self.font
        
        updateBorder()
        updatePlaceholder()
        
        
        addSubview(placeholderLabel)
    }
    
    //text field did Begin
    override open func animateViewsForTextEntry() {
        
        self.leftImageView?.tintColor = self.activeleftImageColor
        
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint
        
        UIView.animate(withDuration: 0.2, animations: {
            self.placeholderLabel.alpha = 0.5
            self.placeholderLabel.font = self.placeholderFontFromFont(self.font!)
            self.placeholderLabel.sizeToFit()

        })
    }
    
    //textfield did end
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
                self.placeholderLabel.alpha = 1
                self.placeholderLabel.font = self.font!
                self.placeholderLabel.sizeToFit()
                self.layoutPlaceholderInTextRect()


            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
        }
        
            if bottomLayerBorder {
            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
            }else if fullLayerBorder {
                self.layer.borderColor = self.borderInactiveColor?.cgColor
                self.layer.borderWidth = 0.7
                self.layer.masksToBounds = true
            }
            
            self.leftImageView?.tintColor = self.text == "" ? self.inActiveleftImageColor : self.activeleftImageColor
        
    }
    
    //MARK: - Private
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
        
        if fullLayerBorder {
            self.layer.borderColor = self.borderInactiveColor?.cgColor
            self.layer.borderWidth = 0.7
            self.layer.masksToBounds = true
        }
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
     func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2-placeholderLabel.frame.size.height/2,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: 10)

    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
}
