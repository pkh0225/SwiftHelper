//
//  UILabelExtensions.swift
//  EZSwiftExtensions
//
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

@MainActor
extension UILabel {
    public convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }

    /// 이 함수는 메인큐에서만 사용할 수 있습니다.
    /// 디버그를 용이하게 하기 위해서 메인큐가 아닌 곳에서 사용할 경우 앱을 죽입니다.
    /// 운영앱은 0 뱉을꺼에요 UI 깨질꺼임!
    public func maxLineHeight() -> CGFloat {
        if Thread.isMainThread {
            return CGFloat(self.numberOfLines) * self.font.lineHeight
        }
        if isBetaApp() {
            assertionFailure("이 함수는 메인큐에서만 사용할 수 있습니다.")
        }
        return .zero
    }

    /// 이 함수는 메인큐에서만 사용할 수 있습니다.
    /// 디버그를 용이하게 하기 위해서 메인큐가 아닌 곳에서 사용할 경우 앱을 죽입니다.
    /// 운영앱은 0 뱉을꺼에요 UI 깨질꺼임!
    public func textSize(width: CGFloat? = nil) -> CGSize {
        if Thread.isMainThread {
            let maxLineHeight = self.maxLineHeight()
            if let text {
                if let width {
                    return text.size(maxSize: CGSize(width: width, height: maxLineHeight), font: self.font)
                }
                return text.size(maxSize: CGSize(width: self.width, height: maxLineHeight), font: self.font)
            }
            return .zero
        }
        if isBetaApp() {
            assertionFailure("이 함수는 메인큐에서만 사용할 수 있습니다.")
        }
        return .zero
    }
}

// MARK: - Debug Label
@MainActor
extension UILabel {
    public static func makeDebugLabel(owner: NSObject) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, w: 100, h: 50))
        label.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        label.textColor = UIColor(hex: 0x3cc728, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.autoresizingMask = []
        label.text = owner.className
        label.sizeToFit()
        label.w += 4
        label.h += 2

        if let view = owner as? UITableViewCell {
            view.addSubview(label)
            label.frame.origin = CGPoint(x: 10, y: 24)
            label.textColor = UIColor(hex: 0xf0f000, alpha: 1.0)
        }
        else if let view = owner as? UICollectionViewCell {
            view.addSubview(label)
            label.frame.origin = CGPoint(x: 10, y: 24)
            label.textColor = UIColor(hex: 0xf0f000, alpha: 1.0)
        }
        else if let view = owner as? UICollectionReusableView {
            view.addSubview(label)
            label.frame.origin = CGPoint(x: 10, y: 24)
            label.textColor = UIColor(hex: 0xf0f000, alpha: 1.0)
        }
        else if let view = owner as? UIView {
            view.addSubview(label)
            label.frame.origin = .zero
            label.textColor = UIColor(hex: 0x20FF00, alpha: 1.0)
        }
        else if let vc = owner as? UIViewController {
            vc.view.addSubview(label)
            label.font = UIFont.boldSystemFont(ofSize: 13)
            label.centerInSuperView()
            label.autoresizingMask = []
            label.textColor = UIColor(hex: 0xc91e1e, alpha: 0.7)
            label.backgroundColor = UIColor(hex: 0xf3f2f2, alpha: 0.7)
            label.sizeToFit()
        }

        label.addLongPressGesture { [weak owner] _ in
            guard let owner else { return }
            Logger.ui.logDebug("\n 🌸 Show Class Name : \(owner.className)\n")
            UIPasteboard.general.string = owner.className
            UIAlertController.alert(title: nil, message: "\(owner.className) 복사되었습니다!")
        }
        label.addTapGesture { [weak label] recognizer in
            guard let label else { return }
            let point = recognizer.location(in: label.superview)
            let buttons: [UIButton] = label.superview?.getViews(type: UIButton.self) ?? []
            for btn in buttons {
                if btn.isHidden == false {
                    let btnRect = btn.superview?.convert(btn.frame, to: label.superview) ?? .zero
                    if btnRect.contains(point) {
                        btn.sendActions(for: .touchUpInside)
                        break
                    }
                }
            }
        }

        if let v = owner as? UIView, v.cornerRadius > 0 {
            label.frame.origin.x = v.cornerRadius / 3
        }
    }
}

@MainActor
extension UILabel {
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
                    self.font = font
                }
            }
        }
    }
}

// HTML
@MainActor
extension UILabel {
    public func setHTMLText(_ text: String?, alignment: NSTextAlignment = .natural, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.text = nil
        self.attributedText = nil
        guard let text else { return }
        if let attributedText = text.replace("\\n", "\n").replace("\n", "<br>").htmlToAttributedString {
            self.attributedText = attributedText.applyCustomFont(self.font)
        }
        else {
            self.attributedText = NSAttributedString(string: text.stripHTMLTags())
        }

        // 스타일을 유지하면서 필요한 속성 추가하기
        if let mutableAttr = attributedText?.mutableCopy() as? NSMutableAttributedString {
            let range = NSRange(location: 0, length: mutableAttr.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode
            paragraphStyle.alignment = alignment
            mutableAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            attributedText = mutableAttr
        }
    }
}

#endif
