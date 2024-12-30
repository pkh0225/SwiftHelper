//
//  CGRectExtensions.swift
//  Qorum
//
//  Created by Goktug Yilmaz on 26/08/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

extension CGRect {
    ///   Easier initialization of CGRect
    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }

    ///   X value of CGRect's origin
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        set(value) {
            self.origin.x = value
        }
    }

    ///   Y value of CGRect's origin
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        set(value) {
            self.origin.y = value
        }
    }

    ///   Width of CGRect's size
    public var w: CGFloat {
        get {
            return self.size.width
        }
        set(value) {
            self.size.width = value
        }
    }

    ///   Height of CGRect's size
    public var h: CGFloat {
        get {
            return self.size.height
        }
        set(value) {
            self.size.height = value
        }
    }

    /// EZSE : Surface Area represented by a CGRectangle
    public var area: CGFloat {
        return self.h * self.w
    }

    public var center: CGPoint {
        get {
            return CGPoint(x: x + (w / 2.0), y: y + (h / 2.0))
        }
        set {
            x = newValue.x - (w / 2.0)
            y = newValue.y - (h / 2.0)
        }
    }
}

extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: value, bottom: value, right: value)
    }
}

#endif
