//
//  UIImageExtension.swift
//  WiggleSDK
//
//  Created by pkh on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public func scalingAndCroppingForSize(targetSize: CGSize, isCenter: Bool) -> UIImage? {
        
        let sourceImage: UIImage = self
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if imageSize.equalTo(targetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
                // scale to fit height
            }
            else {
                scaleFactor = heightFactor
                // scale to fit width
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            // center the image
            if widthFactor > heightFactor && isCenter {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }
            else {
                if widthFactor < heightFactor {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        // this will crop
        var thumbnailRect: CGRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
   
    public func toSize(_ size: CGSize) -> UIImage? {

        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func toSizeMax(_ size: CGSize) -> UIImage? {
        let oldWidth: CGFloat = self.size.width
        let oldHeight: CGFloat = self.size.height
        let scaleFactor: CGFloat = (oldWidth > oldHeight) ? size.width / oldWidth : size.height / oldHeight
        let newHeight: CGFloat = oldHeight * scaleFactor
        let newWidth: CGFloat = oldWidth * scaleFactor
        return self.toSize(CGSize(width: newWidth, height: newHeight))
    }
    
    // 회전된 이미지 정상방향으로 돌리기
    func fixrotation() -> UIImage? {
        guard self.cgImage != nil else {
            return nil
        }
        
        if self.imageOrientation == .up {
            return self
        }
        var transform: CGAffineTransform = .identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi) / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -(CGFloat(Double.pi) / 2))
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        
        if let ctx = CGContext(data: nil,
                               width: Int(self.size.width),
                               height: Int(self.size.height),
                               bitsPerComponent: self.cgImage!.bitsPerComponent,
                               bytesPerRow: 0,
                               space: self.cgImage!.colorSpace!,
                               bitmapInfo: self.cgImage!.bitmapInfo.rawValue) {
            
            ctx.concatenate(transform)
            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                // Grr...
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            default:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            }
            // And now we just create a new UIImage from the drawing context
            if let cgimg = ctx.makeImage() {
                return UIImage(cgImage: cgimg)
            }
            
        }
        
        return nil;

    }
    
    public class func imageRectangle(withFrame frame: CGRect, color: UIColor) -> UIImage? {
        return self.imageRectangle(withFrame: frame, color: color, alpha: 1.0)
    }
    
    public class func imageRectangle(withFrame frame: CGRect, color: UIColor, alpha aAlpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setAlpha(aAlpha)
        context.setFillColor(color.cgColor)
        context.fill(frame)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
