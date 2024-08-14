//
//  UIStackViewExtension.swift
//  ssg
//
//  Created by enteris on 2020/08/07.
//  Copyright © 2020 emart. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    public func addBackground(_ color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
