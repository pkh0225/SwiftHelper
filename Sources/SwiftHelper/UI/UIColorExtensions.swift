//
//  UIColorExtensions.swift
//

#if os(iOS) || os(tvOS)

import UIKit

// #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)

extension UIColor {
    private static var hexStringColorCache = NSCache<NSString, UIColor>()

    ///   init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1)
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    // 2021. 08. 17. youngji 안드: 김동준P
    // DefaultColor : darkGray -> lightGray 맞춤
    public static func hexString(_ hexString: String, alpha: CGFloat = 1.0, defaultColor: UIColor = .lightGray) -> UIColor {
        var alpha = alpha
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            if cString.count == 8 {
                // alpha 코드 포함
                let endIdx: String.Index = cString.index(cString.startIndex, offsetBy: 1)
                let startIdx: String.Index = cString.index(cString.startIndex, offsetBy: 2)

                let alphaCode = String(cString[...endIdx])
                cString = String(cString[startIdx...])

                if let alphaDeci = Int(alphaCode, radix: 16) {
                    let alphaVal = round(Double(alphaDeci) / 255.0 * 100) / 100 // decimal 수치로 변환 후 소숫점 두자리까지 표현
                    alpha = CGFloat(alphaVal)
                }
            }
            else {
                return defaultColor
            }
        }

        let key = "\(hexString)_\(alpha)"
        if let hasColor: UIColor = hexStringColorCache.object(forKey: key as NSString) {
            return hasColor
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let color: UIColor = UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)

        hexStringColorCache.countLimit = 100
        hexStringColorCache.setObject(color, forKey: key as NSString)
        return color
    }

    public convenience init(hex col: UInt32, alpha: CGFloat = 1.0) {
        let b = UInt8((col & 0xff))
        let g = UInt8(((col >> 8) & 0xff))
        let r = UInt8(((col >> 16) & 0xff))
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    ///   init method from Gray value and alpha(default:1)
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray / 255, green: gray / 255, blue: gray / 255, alpha: alpha)
    }

    ///   Red component of UIColor (get-only)
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }

    ///   Green component of UIColor (get-only)
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }

    ///   blue component of UIColor (get-only)
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }

    ///   Alpha of UIColor (get-only)
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }

    ///   Returns random UIColor with random alpha(default: false)
    public static var random: UIColor {
        let r: CGFloat = CGFloat(arc4random() % 11) / 10.0
        let g: CGFloat = CGFloat(arc4random() % 11) / 10.0
        let b: CGFloat = CGFloat(arc4random() % 11) / 10.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    public func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        UIGraphicsGetCurrentContext()?.setFillColor(self.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: CGPoint.zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    public func toHex() -> UInt32 {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            var hexValue: UInt32 = 0
            hexValue += UInt32(alpha * 255) << 24
            hexValue += UInt32(red * 255) << 16
            hexValue += UInt32(green * 255) << 8
            hexValue += UInt32(blue * 255)
            return hexValue
        }
        else {
            return 0
        }
    }

    public func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return NSString(format: "#%06x", rgb) as String
    }
}

extension UIColor {
    public static func blendColor(color1: UIColor, color2: UIColor) -> UIColor {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var alpha1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var alpha2: CGFloat = 0

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor(red: max(r1, r2), green: max(g1, g2), blue: max(b1, b2), alpha: max(alpha1, alpha2))
    }

    public func getComplementaryForColor() -> UIColor {
        let ciColor = CIColor(color: self)

        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue

        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
}

#endif
