//
//  UITextFieldExtensions.swift
//  EZSwiftExtensions
//
//  Created by Wang Yu on 6/26/16.
//  Copyright © 2016 Goktug Yilmaz. All rights reserved.
//
// swiftlint:disable line_length

#if os(iOS) || os(tvOS)

import UIKit

extension UITextField {
    ///   Regular exp for email
    public static let emailRegex = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

    ///   Add left padding to the text in textfield
    public func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView: UIView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }

    ///   Add a image icon on the left side of the textfield
    public func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView: UIView = UIView()
        leftView.frame = frame
        let imgView: UIImageView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, w: imageSize.width, h: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }

    ///   Validation of email format based on https://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address and https://stackoverflow.com/questions/2049502/what-characters-are-allowed-in-an-email-address
    // TODO match String.isEmail method
    public func validateEmail() -> Bool {
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", UITextField.emailRegex)
        return emailTest.evaluate(with: self.text)
    }

    ///   Validation of digits only
    public func validateDigits() -> Bool {
        let digitsRegEx = "[0-9]*"
        let digitsTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", digitsRegEx)
        return digitsTest.evaluate(with: self.text)
    }
}
#endif
