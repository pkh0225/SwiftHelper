//  UIViewExtensions.swift
//

#if os(iOS) || os(tvOS)

import UIKit
import WebKit

@MainActor
public class ViewCacheManager {
    static var cacheViewNibs: NSCache<NSString, UIView> = {
        var c = NSCache<NSString, UIView>()
        c.countLimit = 500
        return c
    }()
    static var cacheNibs: NSCache<NSString, UINib> = {
        var c = NSCache<NSString, UINib>()
        c.countLimit = 500
        return c
    }()

    public static func cacheRemoveAll() {
        self.cacheViewNibs.removeAllObjects()
        self.cacheNibs.removeAllObjects()
    }
}

// MARK: - Custom UIView Initilizers
extension UIView {
    ///   convenience contructor to define a view based on width, height and base coordinates.
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
    }
    ///   puts padding around the view
    public convenience init(superView: UIView, padding: CGFloat) {
        self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.w - padding * 2, height: superView.h - padding * 2))
    }

    public convenience init(superView: UIView) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: superView.size))
    }
}

// MARK: - Frame Extensions
extension UIView {
    /// AutoLayout을 사용하지 않고 add를 하는경우에만 사용..... 🧨 Autolayout을 쓰는 경우는 addSubViewAutoLayout 함수를 이용해주세요
    /// - Parameters:
    ///   - view: 타켓 뷰
    ///   - resizingMask: UIView.AutoresizingMask
    ///   - frame: CGRect
    public func addSubviewResizingMask(_ view: UIView, resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight], frame: CGRect = CGRect.zero) {
        if frame == CGRect.zero {
            view.frame = self.bounds
        }
        else {
            view.frame = frame
        }

        view.autoresizingMask = resizingMask
        self.addSubview(view)
    }

    ///   add multiple subviews
    public func addSubviews(_ views: [UIView]) {
        views.forEach { [weak self] eachView in
            self?.addSubview(eachView)
        }
    }

    ///   resizes this view so it fits the largest subview
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView: UIView in self.subviews {
            let aView: UIView = someView
            let newWidth: CGFloat = aView.x + aView.w
            let newHeight: CGFloat = aView.y + aView.h
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    ///   resizes this view so it fits the largest subview
    public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView: UIView in self.subviews {
            let aView: UIView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth: CGFloat = aView.x + aView.w
                let newHeight: CGFloat = aView.y + aView.h
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    ///   resizes this view so as to fit its width.
    public func resizeToFitWidth() {
        let currentHeight = self.h
        self.sizeToFit()
        self.h = currentHeight
    }

    ///   resizes this view so as to fit its height.
    public func resizeToFitHeight() {
        let currentWidth = self.w
        self.sizeToFit()
        self.w = currentWidth
    }

    ///   resizes this view so as to fit its height.
    public func resizeToFitHeight(_ height: CGFloat) {
        var rt: CGRect = frame
        rt.size.height = height
        frame = rt
    }

    ///   getter and setter for the x coordinate of the frame's origin for the view.
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    public var minX: CGFloat {
        get {
            return self.frame.minX
        }
    }

    public var midX: CGFloat {
        get {
            return self.frame.midX
        }
    }

    public var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            self.frame.x = newValue - self.w
        }
    }
    ///   getter and setter for the y coordinate of the frame's origin for the view.
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    public var minY: CGFloat {
        get {
            return self.frame.minY
        }
    }

    public var midY: CGFloat {
        get {
            return self.frame.midY
        }
    }

    public var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
        set {
            self.frame.y = newValue - self.h
        }
    }

    ///   variable to get the width of the view.
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    ///   variable to get the height of the view.
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }

    public var width: CGFloat {
        get {
            return self.w
        }
        set {
            self.w = newValue
        }
    }

    public var height: CGFloat {
        get {
            return self.h
        }
        set {
            self.h = newValue
        }
    }

    ///   getter and setter for the x coordinate of leftmost edge of the view.
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    ///   getter and setter for the x coordinate of the rightmost edge of the view.
    public var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }

    ///   getter and setter for the y coordinate for the topmost edge of the view.
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    ///   getter and setter for the y coordinate of the bottom most edge of the view.
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }

    ///   getter and setter the frame's origin point of the view.
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    ///   getter and setter for the X coordinate of the center of a view.
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    ///   getter and setter for the Y coordinate for the center of a view.
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    ///   getter and setter for frame size for the view.
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    ///   getter for an leftwards offset position from the leftmost edge.
    public func leftOffset(_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }

    ///   getter for an rightwards offset position from the rightmost edge.
    public func rightOffset(_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }

    ///   aligns the view to the top by a given offset.
    public func topOffset(_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }

    ///   align the view to the bottom by a given offset.
    public func bottomOffset(_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }

    ///   align the view widthwise to the right by a given offset.
    public func alignRight(_ offset: CGFloat) -> CGFloat {
        return self.w - offset
    }

    public func reorderSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView: UIView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                if reorder {
                    let aView: UIView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }

    public func removeSubviews() {
        for subview: UIView in subviews {
            subview.removeFromSuperview()
        }
    }

    public func removeSubviews(_ tag: Int) {
        for subview: UIView in subviews {
            if subview.tag == tag {
                subview.removeFromSuperview()
            }
        }
    }

    public func viewWithTagName(_ name: String) -> UIView? {
        var sv: UIView? = self.superview
        while true {
            guard sv?.superview != nil else { break }
            sv = sv?.superview
        }
        if sv == nil {
            sv = self
        }
        let viewList: [UIView] = UIView.subViewAllList(sv!)
        return viewList.lazy.filter({ view -> Bool in
            return view.tag_name == name
        }).first

    }

    public class func subViewAllList(_ view: UIView) -> [UIView] {
        var result: [UIView] = [UIView]()
        for sv: UIView in view.subviews {
            if sv.subviews.count > 0 {
                result += subViewAllList(sv)
            }
            result.append(sv)
        }

        return result
    }

    public func getViews<T: UIView>(type: T.Type) -> [T] {
        return UIView.subViewAllList(self).compactMap { v in
            if let vt = v as? T {
                return vt
            }
            return nil
        }
    }

    public var topParentView: UIView? {
        var superView: UIView? = self.superview
        while superView != nil {
            superView = superView?.superview
        }
        return superView
    }
    
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    ///   Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("SwiftExtensions Error: The view \(String(describing: type(of: self.parentViewController))) doesn't have a superview")
            return
        }

        self.x = (parentView.w / 2.0) - (self.w / 2.0)
    }

    ///   Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("SwiftExtensions Error: The view \(String(describing: type(of: self.parentViewController))) doesn't have a superview")
            return
        }

        self.y = (parentView.h / 2.0) - (self.h / 2.0)
    }

    ///   Centers view in superview horizontally & vertically
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }

}

// MARK: Transform Extensions
extension UIView {
    public func setRotationX(_ x: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        self.layer.transform = transform
    }

    public func setRotationY(_ y: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }

    public func setRotationZ(_ z: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    public func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    public func setScale(x: CGFloat, y: CGFloat) {
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
}

// MARK: - Layer Extensions
extension UIView {
    @IBInspectable public var tagName: String? {
        get {
            return self.tag_name
        }
        set {
            self.tag_name = newValue
        }
    }

    @IBInspectable public var rotationDegrees: CGFloat {
        get {
            return atan2(self.transform.b, self.transform.a)
        }
        set {
            let radians: CGFloat = CGFloat(Double.pi) * newValue / 180.0
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }

    @IBInspectable open var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            guard self.layer.borderColor != newValue?.cgColor else { return }
            self.layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            guard self.layer.borderWidth != newValue else { return }
            self.layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            guard self.layer.cornerRadius != newValue else { return }
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            self.clipsToBounds = true
            setNeedsDisplay()
        }
    }

    public func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.cornerRadius = r
        }
    }

    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    public func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }

    public func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding * 2, height: size, color: color)
    }

    public func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }

    public func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }

    public func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }

    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border: CALayer = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    public func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let path: UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w / 2)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        self.layer.addSublayer(shapeLayer)
    }
    public func drawStroke(width: CGFloat, color: UIColor) {
        let path: UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w / 2)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }

    public func showRectLine() {
        func subViewList(_ view: UIView) -> [UIView] {
            var result: [UIView] = [UIView]()
            for sv: UIView in view.subviews {
                if sv.subviews.count > 0 && (sv is UIButton) == false {
                    result += subViewList(sv)
                }
                result.append(sv)
            }
            return result
        }

        for view: UIView in subViewList(self) {
            if view is UILabel {
                view.borderColor = .green
                view.borderWidth = 1
            }
            else if view is UIImageView {
                view.borderColor = .red
                view.borderWidth = 1.5
            }
            else if view is UITextField {
                view.borderColor = .darkGray
                view.borderWidth = 1
            }
//            else if view is UIScrollView {
//                view.borderColor = UIColor(hex: 0xFF7D5A, alpha: 0.6)
//                view.borderWidth = 1
//            }
            else if view is UIStackView {
                view.borderColor = UIColor(hex: 0xCACF00, alpha: 1)
                view.borderWidth = 1
            }
            else if view is UIButton {
                view.borderColor = .blue
                view.borderWidth = 2
            }
            else if view is UICollectionViewCell {
                view.borderColor = .purple
                view.borderWidth = 1
            }
            else if view is UICollectionReusableView {
                view.borderColor = UIColor(hex: 0x26004c, alpha: 1)
                view.borderWidth = 1
            }
            else if view is UITableViewCell {
                view.borderColor = .purple
                view.borderWidth = 1
            }
            else if view is WKWebView {
                view.borderColor = UIColor(hex: 0xFF3E3E, alpha: 1)
                view.borderWidth = 5
            }
            else {
                view.borderColor = .yellow
                view.borderWidth = 0.5
            }
        }
    }

    public func roundView(withBorderColor color: UIColor? = nil, withBorderWidth width: CGFloat? = nil) {
        self.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
        self.layer.borderWidth = width ?? 0
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
    }

    public func nakedView() {
        self.layer.mask = nil
        self.layer.borderWidth = 0
    }
}

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

// MARK: - Animation Extensions
extension UIView {
    public func clickAnimation(scaleX: CGFloat = 0.8, usingSpringWithDamping: CGFloat = 0.3, initialSpringVelocity: CGFloat = 10.0, completion: VoidClosure? = nil) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.transform = CGAffineTransform.identity
                       },
                       completion: { _ in completion?() }
        )
    }

    public func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0

        layer.add(pulse, forKey: "pulse")
    }

    public func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3

        layer.add(flash, forKey: nil)
    }

    public func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true

        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)

        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)

        shake.fromValue = fromValue
        shake.toValue = toValue

        layer.add(shake, forKey: "position")
    }

    public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIView.AnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }

    public func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }

    public func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [weak self] () -> Void in
            guard let `self` = self else { return }
            self.setScale(x: 1, y: 1)
        })
    }

    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [weak self] () -> Void in
            guard let `self` = self else { return }
            self.setScale(x: 1, y: 1)
        })
    }

    ///  Shakes the view for as many number of times as given in the argument.
    public func shakeViewForTimes(_ times: Int) {
        let anim: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7 / 100

        self.layer.add(anim, forKey: nil)
    }
}

// MARK: - Render Extensions
extension UIView {
    public func toImage () -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

// MARK: - Gesture Extensions
nonisolated(unsafe) private var TapGesture_Key: UInt8 = 0
nonisolated(unsafe) private var SwipeGesture_Key: UInt8 = 0
nonisolated(unsafe) private var PanGesture_Key: UInt8 = 0
nonisolated(unsafe) private var PinchGesture_Key: UInt8 = 0
nonisolated(unsafe) private var LongPressGesture_Key: UInt8 = 0

@MainActor
private final class ClosureSleeve: @unchecked Sendable {
    let closure: (_ recognizer: UIGestureRecognizer) -> Void

    init (_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) {
        self.closure = closure
    }

    @objc func invoke (recognizer: UIGestureRecognizer) {
        switch recognizer {
        case let recognizer as UITapGestureRecognizer:
            if recognizer.state == .ended {
                closure(recognizer)
            }
        case let recognizer as UILongPressGestureRecognizer:
            if recognizer.state == .began {
                closure(recognizer)
            }
        default:
            closure(recognizer)
        }
    }
}

extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    @discardableResult
    public func addTapGesture(tapNumber: Int = 1, _ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &TapGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return tap
    }

    @discardableResult
    public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, _ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        swipe.direction = direction

        #if os(iOS)
        swipe.numberOfTouchesRequired = numberOfTouches
        #endif

        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &SwipeGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return swipe
    }

    @discardableResult
    public func addPanGesture(_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &PanGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return pan
    }
    #if os(iOS)

    @discardableResult
    public func addPinchGesture(_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let pinch: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &PinchGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return pinch
    }

    #endif

    @discardableResult
    public func addLongPressGesture(_ closure: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
        let sleeve = ClosureSleeve(closure)
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &LongPressGesture_Key, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return longPress
    }
}

// MARK: - UIView Extension Xib
extension UIView {
    class func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private class func fromXib<T>(cache: Bool = false, as type: T.Type) -> T {
        if cache, let view = ViewCacheManager.cacheViewNibs.object(forKey: self.className as NSString) {
            return view as! T
        }
        else if let nib = ViewCacheManager.cacheNibs.object(forKey: self.className as NSString) {
            return nib.instantiate(withOwner: nil, options: nil).first as! T
        }
        else if let path: String = Bundle.main.path(forResource: className, ofType: "nib") {
            if FileManager.default.fileExists(atPath: path) {
                let nib = UINib(nibName: self.className, bundle: nil)
                let view = nib.instantiate(withOwner: nil, options: nil).first as! T

                ViewCacheManager.cacheNibs.setObject(nib, forKey: self.className as NSString)
                if cache {
                    ViewCacheManager.cacheViewNibs.setObject(view as! UIView, forKey: self.className as NSString)
                }
                return view
            }
        }
        fatalError("\(className) XIB File Not Exist")
    }

    public class func fromXibSize() -> CGSize {
        return fromXib(cache: true).frame.size
    }
}


// MARK: - UIView safeAreaLayoutGuide
extension UIView {
    public var safeTopAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.topAnchor
    }

    public var safeLeftAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.leftAnchor
    }

    public var safeRightAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.rightAnchor
    }

    public var safeBottomAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.bottomAnchor
    }
}

extension UIResponder {
    public func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UIView {
    public func getViewFromParent<T>(_ type: T.Type) -> T? {
        var view: UIView? = self
        while view != nil {
            view = view?.superview
            if let view = view as? T {
                return view
            }
        }
        return nil
    }
}

extension UIView {
    private struct AssociatedKeys {
        nonisolated(unsafe) static var cache: UInt8 = 0
        nonisolated(unsafe) static var unitName: UInt8 = 0
        nonisolated(unsafe) static var tagName: UInt8 = 0
        nonisolated(unsafe) static var tagValue: UInt8 = 0
        nonisolated(unsafe) static var stretchImage: UInt8 = 0
        nonisolated(unsafe) static var strechPoint: UInt8 = 0
        nonisolated(unsafe) static var resizeImageSize: UInt8 = 0
    }

    public var cache: Bool {
        get {
            if let info = objc_getAssociatedObject(self, &AssociatedKeys.cache) as? Bool {
                return info
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cache, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var unitName: String {
        get {
            if let info = objc_getAssociatedObject(self, &AssociatedKeys.unitName) as? String {
                return info
            }
            return ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.unitName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var tag_name: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tagName) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tagName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var tag_value: Any? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tagValue)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tagValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var stretch_image: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.stretchImage) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.stretchImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var strech_point: CGPoint? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.strechPoint) as? CGPoint
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.strechPoint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var resize_image_size: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.resizeImageSize) as? Int
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.resizeImageSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func allButtonSelect(_ select: Bool) {
        for view: UIView in self.subviews {
            if let button: UIButton = view as? UIButton {
                button.isSelected = select
            }
            else {
                view.allButtonSelect(select)
            }
        }
    }

    public func allButtonEnalbe(_ enable: Bool) {
        for view: UIView in self.subviews {
            if let button: UIButton = view as? UIButton {
                button.isEnabled = enable
            }
            else {
                view.allButtonEnalbe(enable)
            }
        }
    }

    public func disableScrollsToTopPropertyOnAllSubviewsOf() {
        for view in self.subviews {
            if let scrollView: UIScrollView = view as? UIScrollView {
                scrollView.scrollsToTop = false
            }
            else {
                view.disableScrollsToTopPropertyOnAllSubviewsOf()
            }
        }
    }

    public func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        }
        else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        }
        else {
            return nil
        }
    }
}
#endif

