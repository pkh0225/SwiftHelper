//
//  File.swift
//  
//
//  Created by mykim on 2020/10/21.
//

import UIKit
import Nuke
import Alamofire

var CellBackGroundColorIndex = 0

struct CellColor {
    public let cellBackGroundColorInfo: [UIColor] =
        [
            UIColor(hex: 0xf6f3e6),
            UIColor(hex: 0xf3eae0),
            UIColor(hex: 0xe5f3e0),
            UIColor(hex: 0xe0edf3),
            UIColor(hex: 0xe0e0f3),
            UIColor(hex: 0xeae0f3),
            UIColor(hex: 0xf3e0f2),
            UIColor(hex: 0xf3e0e4),
            UIColor(hex: 0xeae0cc),
            UIColor(hex: 0xd0ede0),
            UIColor(hex: 0xccd4ea),
            UIColor(hex: 0xe0e0e0)
        ]
}

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
            if let newValue = newValue {
                self.setTintColorImage(newValue)
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

    @IBInspectable public var resizeImageSize: Int {
        get {
            return self.resize_image_size ?? 0
        }
        set {
            self.resize_image_size = newValue
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

    // 이미지요청 취소
    public func cancelRequest() {
        Nuke.cancelRequest(for: self)
    }

    public func loadNukeCookieImage(_ imageUrl: String, _ value: String, _ completion: VoidClosure? = nil) {
        guard let url: URL = URL(urlString: imageUrl) else { return }
        let request: ImageRequest = ImageRequest(url: url)
        var urlRequest: URLRequest = request.urlRequest
        urlRequest.addValue(value, forHTTPHeaderField: "cookie")

        Nuke.loadImage(with: request, into: self)
    }

    public func loadAlamofireImage(_ imageUrl: String, _ completion: VoidClosure? = nil) {
//        let headers: HTTPHeaders = ["cookie": value]

        AF.request(imageUrl).response { result in
            guard  let data = result.data else { return }
            guard  let image = UIImage(data: data) else { return }
            self.image = image

            completion?()
        }
    }

    public func setTintColorImage(_ color: UIColor) {
//        print("1111333 self.image = \(String(describing: self.image))")
//        self.image = self.image?.tintColor(color)
        if self.image?.renderingMode != .alwaysTemplate {
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
        self.tintColor = color
    }
}

// MARK:-
extension UIImageView {
    // MARK:- GET scaleAspectFit Size
    public var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        }
        else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

extension UIView {
    public func addDebugView(targetView: UIView, strUrl: String?) {
        guard WG_ControlManager.debugRemoteImage else { return }

        let defaultViewTag: Int = 909012312
        var debugView: UIButton = UIButton()

        if let v: UIButton = targetView.viewWithTag(defaultViewTag) as? UIButton {
            debugView = v
        }
        else {
            targetView.addSubViewAutoLayout(debugView)
        }

        debugView.addTarget(self, action: #selector(self.showNetworkImageInfo), for: .touchUpInside)
        debugView.tag = defaultViewTag
        debugView.isUserInteractionEnabled = false
        debugView.accessibilityHint = strUrl

        if let urlString: String = strUrl {
//            println("urlString :: \(urlString)")

            if urlString.contains(WG_ControlManager.debugRemoteImageManagerUrl) {
                debugView.backgroundColor = .blue
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

    @objc
    public func showNetworkImageInfo(button: UIButton?) {
        println("image url : \(String(describing: button?.accessibilityHint))")
    }
}
