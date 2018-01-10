//
//  CommonTextField.swift
//  Zing
//
//  Created by dinesh sharma on 30/05/17.
//  Copyright © 2017 dinesh sharma. All rights reserved.
//

import  UIKit

struct TEXT_FIELD_TYPE {
    static let email = "email"
    static let password = "password"
    static let phoneNumber = "phoneNumber"
    static let name = "name"
}

@objc protocol CommonTextFieldDelegate {
   @objc optional func txtFieldDidBegin(field:CommonTextfield)
    @objc  optional func txtFieldDidEnd(field:CommonTextfield)
    @objc optional func txtFieldShouldReturn(field:CommonTextfield) -> Bool
}

class CommonTextfield : HoshiTextField,UITextFieldDelegate {
    
    
    var commonDelegate : CommonTextFieldDelegate?
    override func awakeFromNib() {
            self.delegate = self
    }
    
    @IBInspectable dynamic open var fieldType : String = "" {
        didSet {
            switch fieldType {
            case TEXT_FIELD_TYPE.password:
                setRightView()
                self.isSecureTextEntry = true
            default:
                break
            }
        }
    }
    
    func showHidePasswordText() {
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
    
    func setRightView() {
        let rightButton = UIButton(type: .system)
        rightButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        rightButton.setImage(UIImage(named: "hidePassword"), for: .normal)
        rightButton.addTarget(self, action: #selector(self.showHidePasswordText), for: .touchUpInside)
        rightButton.tintColor = UIColor.themeColor
        self.rightView = rightButton
        self.rightViewMode = .always
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.commonDelegate?.txtFieldDidBegin?(field: self)
        if bottomLayerBorder {
            self.activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
        }else if fullLayerBorder {
            self.layer.borderColor = self.borderActiveColor?.cgColor
            self.layer.borderWidth = 1.7
            self.layer.masksToBounds = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.commonDelegate?.txtFieldDidEnd?(field: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let temp = self.commonDelegate?.txtFieldShouldReturn?(field: self) ?? true
        print(temp)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        switch fieldType {
        case TEXT_FIELD_TYPE.password:
            return (resultString.characters.count >= APP_CONSTANT.MAX_PASSWORD_LENGTH || string == " ") ? false : true
        case TEXT_FIELD_TYPE.name:
            
            let whitespaceSet = CharacterSet.whitespaces
            if (resultString as NSString).rangeOfCharacter(from: whitespaceSet).location == NSNotFound{
                return resultString.containsOnlyCharactersIn("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
                
            } else {
                return false
            }
        default:
            break
        }
        
        return true
    }
    
}

