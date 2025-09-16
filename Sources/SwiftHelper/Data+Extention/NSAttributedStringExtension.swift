//
//  NSAttributedStringExtension.swift
//  WiggleSDK
//
//  Created by 박길호(팀원) - 서비스개발담당App개발팀 on 9/16/25.
//  Copyright © 2025 mykim. All rights reserved.
//
import UIKit

// MARK: - AttributedString Support
extension NSAttributedString {
    public func height(maxWidth: CGFloat, maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        if #available(iOS 16, *) {
            let sizeAttributedString = NSMutableAttributedString(attributedString: self)
            let range = NSRange(location: 0, length: sizeAttributedString.length)
            var isParagraphStyle: Bool = false

            sizeAttributedString.enumerateAttribute(.paragraphStyle, in: range) { value, _, _ in
                if let paragraphStyle = value as? NSMutableParagraphStyle {
                    isParagraphStyle = true
                    paragraphStyle.lineBreakStrategy = .hangulWordPriority
                }
            }
            if isParagraphStyle == false {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakStrategy = .hangulWordPriority
                sizeAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: sizeAttributedString.length))
            }
            return sizeAttributedString.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        }
        else {
            let constraintRect = CGSize(width: maxWidth, height: maxHeight)
            let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

            return boundingBox.height
        }
    }

    public func width(maxHeight: CGFloat) -> CGFloat {
        if #available(iOS 16, *) {
            let sizeAttributedString = NSMutableAttributedString(attributedString: self)
            let range = NSRange(location: 0, length: sizeAttributedString.length)
            var isParagraphStyle: Bool = false

            sizeAttributedString.enumerateAttribute(.paragraphStyle, in: range) { value, _, _ in
                if let paragraphStyle = value as? NSMutableParagraphStyle {
                    isParagraphStyle = true
                    paragraphStyle.lineBreakStrategy = .hangulWordPriority
                }
            }
            if isParagraphStyle == false {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakStrategy = .hangulWordPriority
                sizeAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: sizeAttributedString.length))
            }
            return sizeAttributedString.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: maxHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width
        }
        else {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
            let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

            return boundingBox.width
        }
    }
}

extension NSMutableAttributedString {
    // HTML 안전 검사 함수 (필요에 따라 구현)
    public func applyCustomFont(_ font: UIFont) -> Self {
        let fullRange = NSRange(location: 0, length: self.length)
        self.enumerateAttribute(.font, in: fullRange) { (value, range, _) in
            if let originalFont = value as? UIFont {
                let traits = originalFont.fontDescriptor.symbolicTraits
                var newFont = font

                // 볼드 스타일 유지
                if traits.contains(.traitBold) {
                    newFont = UIFont.boldSystemFont(ofSize: font.pointSize)
                }

                // 이탤릭 스타일 유지
                if traits.contains(.traitItalic) {
                    newFont = UIFont.italicSystemFont(ofSize: font.pointSize)
                }

                self.addAttribute(.font, value: newFont, range: range)
            }
        }
        return self
    }

    public func applyCustomColor(_ color: UIColor) -> Self {
        let fullRange = NSRange(location: 0, length: self.length)
        self.enumerateAttribute(.foregroundColor, in: fullRange) { (_, range, _) in
            self.addAttribute(.font, value: color, range: range)
        }
        return self
    }
}

extension NSMutableParagraphStyle {
    public convenience init(withHangul: Bool) {
        self.init()
        // 1. 애플이 iOS 16부터 String에는 자동으로 hangulWordPriority을 넣고 있으며
        // 2. ParagraphStyle을 수동으로 init하여 넣는 경우에는 개발자가 만드므로 빠지고 있음
        // 3. 그러나 애플은 이를 있다고 가정하고 boundingRect을 계산하는 오류가 있으므로 init 시 강제로 박도록 한다.
        // 애플이 오류 수정 시 이 키워드로 검색 후 기본 init으로 바꿔주면 됩니다!!!
        if #available(iOS 14.0, *) {
            if withHangul {
                self.lineBreakStrategy = .hangulWordPriority
            }
            else {
                self.lineBreakStrategy = .standard
            }
        }
    }
}
