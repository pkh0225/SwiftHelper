//
//  UIButtonExtension.swift
//  SwiftHelper
//
//  Copyright © 2020 mykim. All rights reserved.
//

import UIKit

private var controlAction_Key: UInt8 = 0

@MainActor
private class ClosureSleeve {
    let closure: (_ btn: UIButton) -> Void

    public init (_ closure: @escaping (_ btn: UIButton) -> Void) {
        self.closure = closure
    }

    @objc public func invoke (btn: UIButton) {
        closure(btn)
    }
}

@MainActor
extension UIControl {
    public func addAction(for controlEvents: UIControl.Event, _ closure: @escaping (_ btn: UIButton) -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        var dic = objc_getAssociatedObject(self, &controlAction_Key) as? [Int: ClosureSleeve] ?? [Int: ClosureSleeve]()
        dic[Int(controlEvents.rawValue)] = sleeve
        objc_setAssociatedObject(self, &controlAction_Key, dic, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func removeAction(for controlEvents: UIControl.Event) {
        removeTarget(nil, action: nil, for: controlEvents)
        var dic = objc_getAssociatedObject(self, &controlAction_Key) as? [Int: ClosureSleeve] ?? [Int: ClosureSleeve]()
        dic[Int(controlEvents.rawValue)] = nil
        objc_setAssociatedObject(self, &controlAction_Key, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func removeAllAction() {
        removeTarget(nil, action: nil, for: .allEvents)
        var dic = objc_getAssociatedObject(self, &controlAction_Key) as? [Int: ClosureSleeve] ?? [Int: ClosureSleeve]()
        dic.removeAll()
        objc_setAssociatedObject(self, &controlAction_Key, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

@MainActor
extension UIButton {
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
        self.setImage(self.image(for: state)?.withTintColor(color), for: state)
    }

    public func setBGImageTintColor(color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(self.backgroundImage(for: state)?.withTintColor(color), for: state)
    }

    public func setImageShadow(offset: CGSize = .zero, blur: CGFloat = 0, color: UIColor = .black) {
        self.setImage(self.image(for: state)?.addShadow(offset: offset, blur: blur, color: color), for: state)
    }
}

@MainActor
extension UIButton {
    private struct AssociatedKeys {
        static var customFontName: UInt8 = 0
        static var customFontSize: UInt8 = 0
    }

    @IBInspectable public var customFont: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.customFontName) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.customFontName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let string = newValue else { return }
            let strings = string.components(separatedBy: ",").filter {
                !$0.trim().isEmpty
            }
            if let fontName = strings.first, let size = strings.last {
                if let font = UIFont(name: fontName, size: size.toCGFloat()) {
                    self.titleLabel?.font = font
                }
            }
        }
    }
}

// MARK: - UIButton Configuration Builder Extension
public extension UIButton {
    private func defaultConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        config.titleLineBreakMode = .byTruncatingTail
        config.background.backgroundColor = .clear
        config.cornerStyle = .fixed
        config.background.cornerRadius = 0
        return config
    }
    // MARK: - Builder 패턴

    /// Builder 패턴으로 Configuration의 모든 속성 설정
    func setConfigure(_ builder: (inout UIButton.Configuration) -> Void) {
        var config = self.configuration ?? defaultConfiguration()
        builder(&config)
        self.configuration = config
    }

    // MARK: - Title 설정

    /// Configuration으로 title 설정
    func setConfigTitle(_ title: String?) {
        setTitle(title, for: .normal)
        var config = self.configuration ?? defaultConfiguration()
        config.title = title
        self.configuration = config
    }

    func setConfigFont(_ font: UIFont) {
        var config = self.configuration ?? defaultConfiguration()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
            var outgoing = incoming
            outgoing.font = font
            if let color = self?.titleColor(for: .normal) {
                outgoing.foregroundColor = color
            }
            return outgoing
        }
        self.configuration = config
    }

    func setConfigTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        var config = self.configuration ?? defaultConfiguration()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
            var outgoing = incoming
            outgoing.foregroundColor = color
            if let font = self?.titleLabel?.font {
                outgoing.font = font
            }
            return outgoing
        }
        self.configuration = config
    }

    /// Title 폰트와 색상 함께 설정
    func setConfigTitleStyle(font: UIFont, color: UIColor) {
        var config = self.configuration ?? defaultConfiguration()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            outgoing.foregroundColor = color
            return outgoing
        }
        self.configuration = config
    }

    // MARK: - Image 설정

    func setConfigImage(_ image: UIImage? = nil) {
        setImage(image, for: .normal)
        var config = self.configuration ?? defaultConfiguration()
        config.image = image
        self.configuration = config
    }

    func setConfigImageStyle(placement: NSDirectionalRectEdge, padding: CGFloat) {
        var config = self.configuration ?? defaultConfiguration()
        if let image = self.image(for: .normal) {
            config.image = image
        }
        config.imagePlacement = placement
        config.imagePadding = padding
        self.configuration = config
    }

    // MARK: - Background

    func setConfigRadius(_ radius: CGFloat, width: CGFloat = 0, color: UIColor? = nil) {
        var config = self.configuration ?? defaultConfiguration()
        config.cornerStyle = .fixed
        config.background.cornerRadius = radius
        config.background.strokeColor = color
        config.background.strokeWidth = width
        self.configuration = config
    }

    func setConfigBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        var config = self.configuration ?? defaultConfiguration()
        config.background.backgroundColor = color
        self.configuration = config
    }

    func setConfigBackgroundImage(_ image: UIImage) {
        self.setBackgroundImage(image, for: .normal)
        var config = self.configuration ?? defaultConfiguration()
        config.background.image = image
        self.configuration = config
    }

    // MARK: - Inset

    func setConfigContentInset(_ insets: NSDirectionalEdgeInsets) {
        var config = self.configuration ?? defaultConfiguration()
        config.contentInsets = insets
        self.configuration = config
    }

    // MARK: - Computed Properties
    /// Configuration의 title
    var configTitle: String? {
        get { configuration?.title }
        set { setConfigTitle(newValue) }
    }

    /// Configuration의 image
    var configImage: UIImage? {
        get { configuration?.image }
        set { setConfigImage(newValue) }
    }
}
