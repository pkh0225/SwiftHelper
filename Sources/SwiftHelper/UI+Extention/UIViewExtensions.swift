//  UIViewExtensions.swift
//

#if os(iOS) || os(tvOS)

import UIKit
import WebKit

@MainActor
public class ViewCacheManager {
    static let cacheViewNibs = NSCache<NSString, UIView>()
    static let cacheNibs = NSCache<NSString, UINib>()

    public static func cacheRemoveAll() {
        self.cacheViewNibs.removeAllObjects()
        self.cacheNibs.removeAllObjects()
    }
}
// MARK: - Frame Extensions
@MainActor
extension UIView {
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
}

// MARK: - View subView
@MainActor
extension UIView {
    /// AutoLayout을 사용하지 않고 add하는 경우에만 사용
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

    public func subViewAllList() -> [UIView] {
        return UIView.subViewAllList(self)
    }

    public static func subViewAllList(_ view: UIView) -> [UIView] {
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

    ///   Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("SwiftExtensions Error: The view \(String(describing: type(of: self))) doesn't have a superview")
            return
        }

        self.x = (parentView.w / 2.0) - (self.w / 2.0)
    }

    ///   Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("SwiftExtensions Error: The view \(String(describing: type(of: self))) doesn't have a superview")
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

// MARK: - Transform Extensions
@MainActor
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
@MainActor
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
            if let cgColor = self.layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
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
            if let label = view as? UILabel {
                if !(label.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false) || label.attributedText != nil {
                    label.borderColor = .green
                    label.borderWidth = 1
                }
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

    public func showCommonUIRectLine() {
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 200_000_000)

            self.borderColor = UIColor(hex: 0xFF336D, alpha: 1)
            self.borderWidth = 3

            let dot = UIView(frame: CGRect(x: 6, y: 6, width: 6, height: 6))
            dot.backgroundColor = UIColor(hex: 0xFF336D, alpha: 1)
            dot.cornerRadius = 3
            self.addSubview(dot)
        }
    }

    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.layoutIfNeeded()
        let topLeft: CGFloat = corners.contains(.topLeft) ? radius : 0
        let topRight: CGFloat = corners.contains(.topRight) ? radius : 0
        let bottomLeft: CGFloat = corners.contains(.bottomLeft) ? radius : 0
        let bottomRight: CGFloat = corners.contains(.bottomRight) ? radius : 0
        setLayerMaskOperation(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
    }

    public func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        // 원래부터도 cornerRadius와 동시에 있으면 이 값을 무시하고 0으로 적용하고 있었습니다. 따라서 기존 스펙대로 초기화합니다.
        setLayerMaskOperation(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
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

    public func addCDNDebugView(targetView: UIView, strUrl: String?) {
        let debugRemoteImageManagerUrl = "ssgcdn.com/ui/app/small"
        let debugRemoteDesignImageUrl = "sui.shinsegaecdn.com/ui/m_ssg/img/design"

        let defaultViewTag: Int = 909012312
        var debugView: UIButton = UIButton()

        if let v: UIButton = targetView.viewWithTag(defaultViewTag) as? UIButton {
            debugView = v
        }
        else {
            targetView.addSubviewResizingMask(debugView)
        }

        debugView.addTarget(self, action: #selector(self.showNetworkImageInfo), for: .touchUpInside)
        debugView.tag = defaultViewTag
        debugView.isUserInteractionEnabled = false
        debugView.accessibilityHint = strUrl

        if let urlString: String = strUrl {
//            println("urlString :: \(urlString)")

            if urlString.contains(debugRemoteImageManagerUrl) {
                debugView.backgroundColor = .blue
            }
            else if urlString.contains(debugRemoteDesignImageUrl) {
                debugView.backgroundColor = .purple
            }
            else {
                debugView.backgroundColor = .yellow
            }
        }
        else {
            debugView.backgroundColor = .red
        }

        debugView.alpha = 0.5
    }

    public func addDebugMaskView(targetView: UIView, color: UIColor = UIColor(hex: 0xFF3E3E, alpha: 0.2), isUseStroke: Bool = false) {
        let debugView = DebugMaskingView(bgColor: color, strokeColor: color, isUseStroke: isUseStroke)
        debugView.frame = targetView.bounds
        targetView.addSubviewResizingMask(debugView)
        targetView.bringSubviewToFront(debugView)
    }

    public func debugMaskView() -> DebugMaskingView? {
        guard let debugMaskView = self.viewWithTag(DebugMaskingView.DebugMaskViewTag) as? DebugMaskingView else {
            return nil
        }
        return debugMaskView
    }
    @objc
    public func showNetworkImageInfo(button: UIButton?) {
        Logger.ui.logDebug("image url : \(String(describing: button?.accessibilityHint))")
    }
}

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

// MARK: - Animation Extensions
@MainActor
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
        spring(duration: 0.2, animations: { [weak self] in
            guard let `self` = self else { return }
            self.setScale(x: 1, y: 1)
        })
    }

    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [weak self] in
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
@MainActor
extension UIView {
    /// 뷰와 그 전체 계층 구조를 UIImage로 변환합니다.
    /// - `drawHierarchy(in:afterScreenUpdates:)`를 사용하여 뷰 계층 구조 전체를 캡처합니다.
    ///   텍스트, 이미지, 서브뷰, 오버레이 등이 포함됩니다.
    /// - 뷰의 전체 시각적 표현을 캡처해야 하는 경우 적합합니다.
    /// - 참고: 계층 구조가 복잡한 경우 성능 저하가 발생할 수 있습니다.
    /// - 반환값: 뷰의 전체 계층 구조를 나타내는 `UIImage`.
    public func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
    }

    /// 뷰의 Core Animation 레이어만 UIImage로 변환합니다.
    /// - `layer.render(in:)`를 사용하여 현재 레이어 상태만 캡처합니다.
    /// - 서브뷰나 오버레이는 포함되지 않으며, 단일 뷰만 캡처됩니다.
    /// - 화면에 표시되지 않는 뷰도 캡처할 수 있습니다.
    /// - 빠르게 단일 뷰를 렌더링하거나 특정 레이어만 캡처할 때 적합합니다.
    /// - 반환값: 뷰의 레이어를 나타내는 `UIImage`.
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

// MARK: - Gesture Extensions
private var TapGesture_Key: UInt8 = 0
private var SwipeGesture_Key: UInt8 = 0
private var PanGesture_Key: UInt8 = 0
private var PinchGesture_Key: UInt8 = 0
private var LongPressGesture_Key: UInt8 = 0

@MainActor
private class ClosureSleeve {
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

@MainActor
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
@MainActor
extension UIView {
    public class func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private class func fromXib<T: UIView>(cache: Bool = false, as type: T.Type) -> T {
        // betaApp이고 현재 메인쓰레드가 아닌데 fromXib를 호출했으면 종료처리
        if isBetaApp() && !Thread.isMainThread {
            fatalError("not main thread")
        }
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
//                let view: UIView = Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)!.first as! UIView
                if cache {
                    ViewCacheManager.cacheViewNibs.setObject(view, forKey: self.className as NSString)
                    view.cache = cache
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
@MainActor
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

@MainActor
extension UIResponder {
    public func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

@MainActor
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

    public func topSuperview() -> UIView? {
        return sequence(first: self, next: \.superview).lazy.compactMap({ $0 as? UIWindow }).first
    }
}

@MainActor
extension UIView {
    private struct AssociatedKeys {
        static var cache: UInt8 = 0
        static var unitName: UInt8 = 0
        static var tagName: UInt8 = 0
        static var tagValue: UInt8 = 0
        static var stretchImage: UInt8 = 0
        static var strechPoint: UInt8 = 0
        static var resizeImageSize: UInt8 = 0
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

    public func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let responder = subview.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}

// MARK: - CGRect 각 코너별 radius 지원
@MainActor
extension UIView {
    private struct RoundCornerAssociatedKeys {
        static var topLeftRadius: UInt8 = 0
        static var topRightRadius: UInt8 = 0
        static var bottomLeftRadius: UInt8 = 0
        static var bottomRightRadius: UInt8 = 0
    }
    /// XIB에서 코너별로 다른 radius 적용 시 cornerRadius 값을 무시하고 위의 값을 적용
    @IBInspectable public var topLeftRadius: NSNumber? {
        get {
            if let value = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.topLeftRadius) as? NSNumber {
                return value
            }
            return nil
        }
        set {
            let oldValue = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.topLeftRadius)
            objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.topLeftRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setLayerMaskIfNeeded(oldValue: oldValue as? NSNumber, newValue: newValue)
        }
    }
    @IBInspectable public var topRightRadius: NSNumber? {
        get {
            if let value = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.topRightRadius) as? NSNumber {
                return value
            }
            return nil
        }
        set {
            let oldValue = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.topRightRadius)
            objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.topRightRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setLayerMaskIfNeeded(oldValue: oldValue as? NSNumber, newValue: newValue)
        }
    }
    @IBInspectable public var bottomLeftRadius: NSNumber? {
        get {
            if let value = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.bottomLeftRadius) as? NSNumber {
                return value
            }
            return nil
        }
        set {
            let oldValue = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.bottomLeftRadius)
            objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.bottomLeftRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setLayerMaskIfNeeded(oldValue: oldValue as? NSNumber, newValue: newValue)
        }
    }
    @IBInspectable public var bottomRightRadius: NSNumber? {
        get {
            if let value = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.bottomRightRadius) as? NSNumber {
                return value
            }
            return nil
        }
        set {
            let oldValue = objc_getAssociatedObject(self, &RoundCornerAssociatedKeys.bottomRightRadius)
            objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.bottomRightRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setLayerMaskIfNeeded(oldValue: oldValue as? NSNumber, newValue: newValue)
        }
    }
    /// 여러 코너의 cornerRadius 값을 변경한 경우, 한 번의 mask만 그리는 operation을 수행하도록 하는 func
    public func setLayerMaskOperation(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.topLeftRadius, NSNumber(floatLiteral: topLeft), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.topRightRadius, NSNumber(floatLiteral: topRight), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.bottomLeftRadius, NSNumber(floatLiteral: bottomLeft), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &RoundCornerAssociatedKeys.bottomRightRadius, NSNumber(floatLiteral: bottomRight), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        setLayerMask()
    }
    /// 런타임에서 특정 코너의 cornerRadius 값을 변경하는 경우, 값이 바뀌어야만 masking을 하도록 만든 func
    public func setLayerMaskIfNeeded<T>(oldValue: T?, newValue: T?) where T: NSNumber {
        guard let oldValue, oldValue.isEqual(to: newValue ?? NSNumber(floatLiteral: 0)) else { return }
        setLayerMask()
    }
    /// layer의 mask를 graphic operation 으로 (GPU 가속을 이용하여) 그리는 공통 func
    public func setLayerMask() {
        let topLeft = CGFloat(topLeftRadius?.doubleValue ?? 0)
        let topRight = CGFloat(topRightRadius?.doubleValue ?? 0)
        let bottomLeft = CGFloat(bottomLeftRadius?.doubleValue ?? 0)
        let bottomRight = CGFloat(bottomRightRadius?.doubleValue ?? 0)

        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = Self.roundedRectPath(
            in: bounds,
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight
        ).cgPath

        layer.mask = shape
        clipsToBounds = true
        layer.masksToBounds = true
        setNeedsDisplay()
    }

    private static func roundedRectPath(
        in rect: CGRect,
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomLeft: CGFloat,
        bottomRight: CGFloat
    ) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        if topRight > 0 {
            path.addArc(
                withCenter: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                radius: topRight,
                startAngle: -.pi / 2,
                endAngle: 0,
                clockwise: true
            )
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        if bottomRight > 0 {
            path.addArc(
                withCenter: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                radius: bottomRight,
                startAngle: 0,
                endAngle: .pi / 2,
                clockwise: true
            )
        }
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        if bottomLeft > 0 {
            path.addArc(
                withCenter: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
                radius: bottomLeft,
                startAngle: .pi / 2,
                endAngle: .pi,
                clockwise: true
            )
        }
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        if topLeft > 0 {
            path.addArc(
                withCenter: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                radius: topLeft,
                startAngle: .pi,
                endAngle: -.pi / 2,
                clockwise: true
            )
        }
        path.close()
        return path
    }
}

#endif
