//
//  NSMutableAttributedStringExtensions.swift
//  ssg
//
//  Created by pkh on 2018. 1. 16..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    public func setAsLink(textToFind: String, linkURL: String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension NSAttributedString {
    // AttributedString multiLine일때 사이즈 구하기.
    public func heightForMultiline(_ width: CGFloat) -> CGFloat {
        // attributes:[NSAttributedString.Key.font: font]
        let height = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        return ceil(height)
    }

    public func heightForMultilineWithMaxSize(_ size: CGSize) -> CGFloat {
        // attributes:[NSAttributedString.Key.font: font]
        let height = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        return ceil(height)
    }

    public func components(separatedBy separator: String) -> [NSAttributedString] {
        var result = [NSAttributedString]()
        let separatedStrings = string.components(separatedBy: separator)
        var range = NSRange(location: 0, length: 0)
        for string in separatedStrings {
            range.length = string.utf16.count
            let attributedString = attributedSubstring(from: range)
            result.append(attributedString)
            range.location += range.length + separator.utf16.count
        }
        return result
    }
}
