//
//  UILabelExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

extension UILabel {
    ///   Initialize Label with a font, color and alignment.
    public convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }

    /// EZSwiftExtensions
    public func getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: height))
    }

    /// EZSwiftExtensions
    public func getEstimatedHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)).height
    }

    /// EZSwiftExtensions
    public func getEstimatedWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)).width
    }

    /// EZSwiftExtensions
    public func fitHeight() {
        self.h = getEstimatedHeight()
    }

    /// EZSwiftExtensions
    public func fitWidth() {
        self.w = getEstimatedWidth()
    }

    /// EZSwiftExtensions
    public func fitSize() {
        self.fitWidth()
        self.fitHeight()
        sizeToFit()
    }

    /// EZSwiftExtensions (if duration set to 0 animate wont be)
    public func set(text _text: String?, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = _text
        }, completion: nil)
    }

    public func convertWonFormat(_ text: String) -> NSMutableAttributedString {
        let price: String = text + "원"
        let wonFont: UIFont = UIFont(name: self.font.fontName, size: self.font.pointSize - 4)!

        let messageStr: NSMutableAttributedString = NSMutableAttributedString(string: price)
        messageStr.addAttribute(NSAttributedString.Key.font, value: self.font as Any, range: NSRange(location: 0, length: messageStr.length - 1))
        messageStr.addAttribute(NSAttributedString.Key.font, value: wonFont, range: NSRange(location: messageStr.length - 1, length: 1))
        messageStr.addAttribute(NSAttributedString.Key.foregroundColor, value: self.textColor as Any, range: NSRange(location: 0, length: messageStr.length))

        let messageParagraph: NSMutableParagraphStyle = NSMutableParagraphStyle(withHangul: true)
        messageParagraph.alignment = .center
        messageParagraph.lineBreakMode = .byCharWrapping
        messageParagraph.lineSpacing = 2
        messageStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: messageParagraph, range: NSRange(location: 0, length: messageStr.length))

        return messageStr
    }

    public func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        guard let attributedText else { return nil }

        let textStorage: NSTextStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager: NSLayoutManager = NSLayoutManager()

        textStorage.addLayoutManager(layoutManager)

        let textContainer: NSTextContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0

        layoutManager.addTextContainer(textContainer)

        var glyphRange: NSRange = NSRange()

        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)

        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}

// MARK: - Debug Label
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
            print("\n 🌸 Show Class Name : \(owner.className)\n")
            UIPasteboard.general.string = owner.className
            alert(title: nil, message: "\(owner.className) 복사되었습니다!")
//            UIAlertController.alert(title: nil, message: "\(owner.className) 복사되었습니다!")
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
    }
}

// HTML
extension UILabel {
    public func setHTMLText(_ text: String?, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
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
            mutableAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            attributedText = mutableAttr
        }
    }
}

#endif
