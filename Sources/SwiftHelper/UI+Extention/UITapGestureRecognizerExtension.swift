//
//  UITapGestureRecognizerExtension.swift
//  WiggleSDK
//
//  Created by mykim on 2021/04/05.
//  Copyright © 2021 mykim. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    public func didTapAttributedTextInLabel(_ label: UILabel, inRange targetRange: ClosedRange<Int>) -> Bool {
        // only detect taps in attributed text
        guard let attributedText = label.attributedText, self.state == .ended else {
            return false
        }

        // Configure NSTextContainer
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines

        // Configure NSLayoutManager and add the text container
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        // Configure NSTextStorage and apply the layout manager
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addAttribute(.font, value: label.font ?? UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: attributedText.length))
        textStorage.addLayoutManager(layoutManager)

        // get the tapped character location
        let locationOfTouchInLabel = self.location(in: self.view)

        // account for text alignment and insets
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        var alignmentOffset: CGFloat = 0.0
        switch label.textAlignment {
        case .left, .natural, .justified:
            alignmentOffset = 0.0
        case .center:
            alignmentOffset = 0.5
        case .right:
            alignmentOffset = 1.0
        @unknown default:
            alignmentOffset = 1.0
        }
        let xOffset = ((label.bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((label.bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)

        // figure out which character was tapped
        let characterTapped = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // figure out how many characters are in the string up to and including the line tapped
        let lineTapped = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: label.bounds.size.width, y: label.font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // ignore taps past the end of the current line
        if characterTapped < charsInLineTapped {
            return targetRange.contains(characterTapped)
        }
        return false
    }
}
