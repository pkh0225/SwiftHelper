//
//  UIStackViewExtension.swift
//  ssg
//
//  Copyright © 2020 emart. All rights reserved.
//

import Foundation
import UIKit

@MainActor
extension UIStackView {
    public func addBackground(_ color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
