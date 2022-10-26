//
//  UIButtonExtension.swift
//  WiggleSDK
//
//  Created by mykim on 2020/10/20.
//  Copyright © 2020 mykim. All rights reserved.
//

import UIKit

private var controlAction_Key: UInt8 = 0

private class ClosureSleeve {
    let closure: (_ btn: UIButton) -> Void

    public init (_ closure: @escaping (_ btn: UIButton) -> Void) {
        self.closure = closure
    }

    @objc public func invoke (btn: UIButton) {
        closure(btn)
    }
}

extension UIControl {
    public func addAction(for controlEvents: UIControl.Event, _ closure: @escaping (_ btn: UIButton) -> Void) {
        let sleeve = ClosureSleeve(closure)
        removeTarget(nil, action: nil, for: controlEvents)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, &controlAction_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UIButton {
    private struct AssociatedKeys {
        static var isIndicatorShow: UInt8 = 0
        static var cacheImage: UInt8 = 0
        static var cacheTitle: UInt8 = 0
        static var indicator: UInt8 = 0
        static var cacheAttributedTitle: UInt = 0
    }
    public var isIndicatorShow: Bool {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKeys.isIndicatorShow) as? Bool {
                return obj
            }
            return false
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.isIndicatorShow, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                showIndicator()
            }
            else {
                hideIndicator()
            }
        }
    }

    public var cacheImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cacheImage) as? UIImage
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.cacheImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var cacheTitle: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cacheTitle) as? String
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.cacheTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var cacheAttributedTitle: NSAttributedString? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cacheAttributedTitle) as? NSAttributedString
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.cacheAttributedTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var indicator: UIActivityIndicatorView {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKeys.indicator) as? UIActivityIndicatorView {
                return obj
            }
            let indicate = UIActivityIndicatorView(style: .gray)
            self.addSubview(indicate)
            indicate.centerInSuperView()
            indicate.tagName = "indicate"
            objc_setAssociatedObject( self, &AssociatedKeys.indicator, indicate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return indicate
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.indicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var isIndicator: Bool {
        if let _ = objc_getAssociatedObject(self, &AssociatedKeys.indicator) as? UIActivityIndicatorView {
            return true
        }
        return false
    }

    public func showIndicator() {
        let defaultSize = self.size
        self.isEnabled = false
        self.cacheImage = self.image(for: .normal)
        self.cacheTitle = self.title(for: .normal)
        self.cacheAttributedTitle = self.attributedTitle(for: .normal)
        // 여기서 사이즈 줄어들어서 가운데 안나옴.
        self.setImage(nil, for: .normal)
        self.setTitle(nil, for: .normal)
        self.setAttributedTitle(nil, for: .normal)
        // 원래 사이즈로 다시 셋팅.
        self.size = defaultSize
        self.indicator.startAnimating()
    }

    public func hideIndicator() {
        self.isEnabled = true
        if let image = self.cacheImage {
            self.setImage(image, for: .normal)
        }
        if let attributeedTitle = self.cacheAttributedTitle {
            self.setAttributedTitle(attributeedTitle, for: .normal)
        }
        else if let title = self.cacheTitle {
            self.setTitle(title, for: .normal)
        }

        if isIndicator {
            self.indicator.stopAnimating()
        }
    }

    public func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControl.State) {
        self.setImage(image, for: state)

        if let frame = frame {
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
    }

    @IBInspectable var stretchImage: Bool {
        get {
            return self.stretch_image ?? false
        }
        set {
            self.stretch_image = newValue
            if newValue {
                self.setStrechImage(nil)
            }
        }
    }

    @IBInspectable var strechPoint: CGPoint {
        get {
            return self.strech_point ?? CGPoint.zero
        }
        set {
            self.strech_point = newValue
            guard let nomalImage: UIImage = self.backgroundImage(for: .normal) else { return }
            guard let point: CGPoint = self.strech_point else { return }
            guard point != CGPoint.zero else { return }
            var inset: UIEdgeInsets = .zero
            if point.x > 0 {
                inset.left = point.x / 2
                inset.right = nomalImage.size.width - (point.x / 2) - 1
            }
            else if point.x == 0 {
                inset.left = 0
                inset.right = 0
            }
            else {
                inset.right = (abs(point.x) / 2)
                inset.left = nomalImage.size.width - (abs(point.x) / 2) - 1
            }

            if point.y > 0 {
                inset.top = point.y / 2
                inset.bottom = nomalImage.size.height - (point.y / 2) - 1
            }
            else if point.y == 0 {
                inset.top = 0
                inset.bottom = 0
            }
            else {
                inset.bottom = (abs(point.y) / 2)
                inset.top = nomalImage.size.height - (abs(point.y) / 2) - 1
            }
            self.setStrechImage(inset)

        }
    }

    @IBInspectable public var resizeImageSize: Int {
        get {
            return self.resize_image_size ?? 0
        }
        set {
            self.resize_image_size = newValue
        }
    }

    /// EZSwiftExtensions: Convenience constructor for UIButton.
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, target: AnyObject, action: Selector) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        addTarget(target, action: action, for: .touchUpInside)
    }

    /// EZSwiftExtensions: Set a background color for the button.
    public func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }

    private func setStrechImage(_ inset: UIEdgeInsets?) {
        guard let nomalImage = self.backgroundImage(for: .normal) else { return }
        var edgeInset: UIEdgeInsets!

        if inset == nil {
            edgeInset = UIEdgeInsets(top: nomalImage.size.height / 2, left: nomalImage.size.width / 2, bottom: nomalImage.size.height / 2 - 1, right: nomalImage.size.width / 2 - 1)
        }
        else {
            edgeInset = inset
        }

        if let image = self.backgroundImage(for: .normal) {
            let resizeImage = image.resizableImage(withCapInsets: edgeInset, resizingMode: .stretch)
            self.setBackgroundImage(resizeImage, for: .normal)
        }

        if let image = self.backgroundImage(for: .highlighted) {
            let resizeImage = image.resizableImage(withCapInsets: edgeInset, resizingMode: .stretch)
            self.setBackgroundImage(resizeImage, for: .highlighted)
        }

        if let image = self.backgroundImage(for: .selected) {
            let resizeImage = image.resizableImage(withCapInsets: edgeInset, resizingMode: .stretch)
            self.setBackgroundImage(resizeImage, for: .selected)
        }

        if let image = self.backgroundImage(for: .disabled) {
            let resizeImage = image.resizableImage(withCapInsets: edgeInset, resizingMode: .stretch)
            self.setBackgroundImage(resizeImage, for: .disabled)
        }

    }

    public func setImageTintColor(color: UIColor, for state: UIControl.State) {
        self.setImage(self.image(for: state)?.tintColor(color), for: state)
    }

    public func setBGImageTintColor(color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(self.backgroundImage(for: state)?.tintColor(color), for: state)
    }

    public func setImageShadow(offset: CGSize = .zero, blur: CGFloat = 0, color: UIColor = .black) {
        self.setImage(self.image(for: state)?.addShadow(offset: offset, blur: blur, color: color), for: state)
    }
}
