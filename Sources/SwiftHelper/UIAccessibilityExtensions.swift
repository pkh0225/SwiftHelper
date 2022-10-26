//
//  UIAccessibilityExtensions.swift
//  WiggleSDK
//
//  Created by pkh on 2021/04/08.
//  Copyright © 2021 mykim. All rights reserved.
//

import UIKit

extension UIAccessibility {
    public static func setFocusTo(_ object: Any?) {
        if UIAccessibility.isVoiceOverRunning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let o = object as? NSObject {
                    o.isAccessibilityElement = true
                }
                UIAccessibility.post(notification: .screenChanged, argument: object)
            }
        }
    }
}
