//
//  TextFieldValidatorTableViewCell.swift
//  TextFieldValidator
//
//  Created by Khemmachart Chutapetch on 12/10/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class TextFieldValidatorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var validationDescLabel: UILabel!
    
    var validatorCellType: TextFieldValidatorTableViewCellType! = .None
    var editedFlag: Bool = false
    
    var validateSuccessCallback: ((_ text: String, _ resultDesc: String) -> Void) = { _, _ in }
    var validateFailedCallback:  ((_ text: String, _ resultDesc: String) -> Void) = { _, _ in }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setInterface()
        self.shouldValidateTextField()
    }
    
    // MARK: - Interface
    
    func setInterface() {
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 3
        
        titleLabel.text = validatorCellType.title
        validationDescLabel.text = " "
    }
    
    func shouldValidateTextField() {
        if editedFlag {
            validate(self.textField)
        }
    }
    
    // MARK: - Action
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        validate(textField)
    }
    
    @IBAction func textFieldDidTextChange(_ textField: UITextField) {
        validate(textField)
    }
    
    // MARK: - Validator
    
    func validate(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let validatedText = validatorCellType.validate(text)
        
        if validatedText.result {
            validateSuccessHandler(validatedText.desc)
            validateSuccessCallback(text, validatedText.desc)
        } else {
            validateFailedHandler(validatedText.desc)
            validateFailedCallback(text, validatedText.desc)
        }
    }
    
    // MARK: - Handler
    
    func validateSuccessHandler(_ desc: String) {
        containerView.layer.borderColor = UIColor.green.cgColor
        validationDescLabel.text = desc
    }
    
    func validateFailedHandler(_ desc: String) {
        containerView.layer.borderColor = UIColor.red.cgColor
        validationDescLabel.text = desc
    }
}

extension TextFieldValidatorTableViewCell {
    
    enum TextFieldValidatorTableViewCellType {
        case UsernameCell
        case PasswordCell
        case EmailCell
        case Firstname
        case None
        
        func validate(_ text: String) -> (result: Bool, desc: String) {
            switch self {
            case .UsernameCell:
                if (text.characters.count < 8) {
                    return (false, "Username must longer than 8 characters")
                } else if (text.characters.count > 16) {
                    return (false, "Username must not longer than 16 characters")
                } else if (text.isNumeric()) {
                    return (false, "Username must contain at lease one character")
                } else if (text.hasSpecialCharacters()) {
                    return (false, "Username cannot contain any special character")
                }
                return (true, "")
                
            case .PasswordCell:
                if (text.characters.count < 8) {
                    return (false, "Password must longer than 8 characters")
                } else if (text.characters.count > 16) {
                    return (false, "Password must not longer than 16 characters")
                } else if (text.hasSpecialCharacters()) {
                    return (false, "Password cannot contain any special character")
                }
                return (true, "")
                
            case .EmailCell:
                if (!text.isEmailFormat()) {
                    return (false, "Invalid email format")
                }
                return (true, "")
                
            case .Firstname:
                if (text.characters.count < 2) {
                    return (false, "Username must longer than 2 characters")
                } else if (!text.isCharacter()) {
                    return (false, "Only character is allowed")
                }
                return (true, "")
                
            case .None:
                return (false, "Something went wrong")
            }
        }
        
        var title: String {
            switch self {
            case .UsernameCell:
                return "Username"
            case .PasswordCell:
                return "Password"
            case .EmailCell:
                return "Email"
            case .Firstname:
                return "Firstname"
            case .None:
                return "Something went wrong"
            }
        }
    }
}
