//
//  Common.swift
//  SwiftHelper
//

import UIKit

nonisolated public func isBetaApp() -> Bool {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
        return false
    }
    return bundleIdentifier.contains("beta")
}

@MainActor
public func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
    var aBase = base

    if aBase == nil {
        if Thread.isMainThread {
            aBase = keyWindow()?.rootViewController
        }
        else {
            return nil
        }
    }

    if let nav = aBase as? UINavigationController {
        if let vc = nav.visibleViewController {
            return topViewController(vc)
        }
    }
    else if let tab = aBase as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(selected)
        }
    }
    else if let presented = aBase?.presentedViewController {
        return topViewController(presented)
    }
    return aBase
}
