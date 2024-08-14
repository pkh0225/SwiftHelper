//
//  UITableViewExtension.swift
//  WiggleSDK
//
//  Created by pkh on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    public func registerDefaultCell() {
        register(UITableViewCell.self)
        registerHeaderFooter(UITableViewHeaderFooterView.self)
    }

    public func register(_ Class: UITableViewCell.Type) {
        register(Class, forCellReuseIdentifier: Class.className)
    }

    public func register(_ Classs: [UITableViewCell.Type]) {
        Classs.forEach { Class in
            register(Class, forCellReuseIdentifier: Class.className)
        }
    }

    public func registerNibCell(_ Class: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: Class), bundle: nil), forCellReuseIdentifier: Class.className)
    }

    public func registerNibCell(_ Classs: [UITableViewCell.Type]) {
        Classs.forEach { Class in
            register(UINib(nibName: String(describing: Class), bundle: nil), forCellReuseIdentifier: Class.className)
        }
    }

    public func registerHeaderFooter(_ Class: UITableViewHeaderFooterView.Type) {
        register(Class, forHeaderFooterViewReuseIdentifier: Class.className)
    }

    public func registerHeaderFooter(_ Classs: [UITableViewHeaderFooterView.Type]) {
        Classs.forEach { Class in
            register(Class, forHeaderFooterViewReuseIdentifier: Class.className)
        }
    }

    public func registerNibCellHeaderFooter(_ Class: UITableViewHeaderFooterView.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forHeaderFooterViewReuseIdentifier: Class.className)
    }

    public func registerNibCellHeaderFooter(_ Classs: [UITableViewHeaderFooterView.Type]) {
        Classs.forEach { Class in
            register(UINib(nibName: Class.className, bundle: nil), forHeaderFooterViewReuseIdentifier: Class.className)
        }
    }

    public func dequeueReusableCell<T: UITableViewCell>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: Class.className, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }

    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ Class: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: Class.className) as! T
    }

}

extension UITableViewCell {
    private struct AssociatedKeys {
        static var indexPath: UInt8 = 0
    }
    public var indexPath: IndexPath {
        get {
            if let indexPath: IndexPath = objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath {
                return indexPath
            }
            return IndexPath(row: 0, section: 0)
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
