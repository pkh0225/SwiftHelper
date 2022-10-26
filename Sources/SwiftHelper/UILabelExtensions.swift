//
//  UILabelExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import EasyConstraints

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

        let messageParagraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
        messageParagraph.alignment = .center
        messageParagraph.lineBreakMode = .byCharWrapping
        messageParagraph.lineSpacing = 2
        messageStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: messageParagraph, range: NSRange(location: 0, length: messageStr.length))

        return messageStr
    }

    public func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        guard let attributedText = attributedText else { return nil }

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

    @discardableResult
    public func visibleViewByDataNBinding(_ value: String?, _ gone: GoneType? = nil) -> Bool {
        if let gone = gone {
            if let value = value, value.isValid {
                self.text = value
                self.ec.goneRemove(gone)
                return true
            }
            else {
                self.ec.gone(gone)
                return false
            }
        }
        else {
            if let value = value, value.isValid {
                self.text = value
                self.isHidden = false
                return true
            }
            else {
                self.isHidden = true
                return false
            }
        }
    }

}

#endif
