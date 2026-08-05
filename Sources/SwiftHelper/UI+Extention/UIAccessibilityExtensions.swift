//
//  UIAccessibilityExtensions.swift
//  SwiftHelper
//
//  Copyright © 2021 mykim. All rights reserved.
//

import UIKit

@MainActor
extension UIAccessibility {
    public static func setFocusTo(_ object: Any?) {
        if UIAccessibility.isVoiceOverRunning {
            Task { @MainActor in
                try await Task.sleep(nanoseconds: 500_000_000)
                if let o = object as? NSObject {
                    o.isAccessibilityElement = true
                }
                UIAccessibility.post(notification: .screenChanged, argument: object)
            }
        }
    }
}
