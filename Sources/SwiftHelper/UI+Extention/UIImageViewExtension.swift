//
//  File.swift
//
//
//

import UIKit

@MainActor
extension UIImageView {
    @IBInspectable public var stretchImage: Bool {
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

    @IBInspectable public var tintColorImage: UIColor? {
        get {
            return self.tintColor
        }
        set {
            if let newValue {
                self.image = self.image?.withTintColor(newValue)
            }
        }
    }

    @IBInspectable public var strechPoint: CGPoint {
        get {
            return self.strech_point ?? CGPoint.zero
        }
        set {
            self.strech_point = newValue
            guard let nomalImage = self.image else { return }
            guard let point = self.strech_point else { return }
            guard point != CGPoint.zero else { return }
            var inset: UIEdgeInsets = .zero
            if point.x > 0 {
                inset.left = point.x
                inset.right = nomalImage.size.width - point.x - 1
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
                inset.top = point.y
                inset.bottom = nomalImage.size.height - point.y - 1
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

    public func setStrechImage(_ inset: UIEdgeInsets?, resizeMode: UIImage.ResizingMode = .stretch) {
        guard let nomalImage = self.image else { return }
        var edgeInset: UIEdgeInsets!

        if inset == nil {
            edgeInset = UIEdgeInsets(top: nomalImage.size.height / 2, left: nomalImage.size.width / 2, bottom: nomalImage.size.height / 2 + 1, right: nomalImage.size.width / 2 + 1)
        }
        else {
            edgeInset = inset
        }

        let resizeImage: UIImage = nomalImage.resizableImage(withCapInsets: edgeInset, resizingMode: resizeMode)
        self.image = resizeImage

        if let highlightedImage = self.highlightedImage {
            let highlightedResizeImage = highlightedImage.resizableImage(withCapInsets: edgeInset, resizingMode: resizeMode)
            self.highlightedImage = highlightedResizeImage
        }

    }
}
