//
//  UIColorExtensions.swift
//

#if os(iOS) || os(tvOS)

import UIKit

// #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)

extension UIColor {
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

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let color: UIColor = UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)

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
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
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

    public func getComplementaryForColorUsingHSB() -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        // 보색 계산 (Hue를 180도 이동)
        let complementaryHue = fmod(hue + 0.5, 1.0) // 0.5는 180도를 의미
        return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// W3C의 상대 휘도(Relative Luminance) 계산 표준을 따릅니다.
    public var relativeLuminance: CGFloat {
        guard let components = cgColor.components, components.count >= 3 else {
            var white: CGFloat = 0
            getWhite(&white, alpha: nil)
            return white
        }

        func adjust(_ colorComponent: CGFloat) -> CGFloat {
            if colorComponent <= 0.03928 {
                return colorComponent / 12.92
            }
            else {
                return pow((colorComponent + 0.055) / 1.055, 2.4)
            }
        }

        let r = adjust(components[0])
        let g = adjust(components[1])
        let b = adjust(components[2])

        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    // 주어진 색상이 흰색 배경에서 읽기 힘들 경우(명암비가 낮을 경우),
    /// 색상의 고유한 톤(Hue)은 유지하면서 충분한 명암비가 확보될 때까지 색상을 어둡게 만듭니다.
    ///
    /// - Parameters:
    ///   - originalTextColor: 조정할 원본 텍스트 색상
    ///   - backgroundColor: 백그라운드 색상
    ///   - minimumContrastRatio: 목표로 하는 최소 명암비 (WCAG AA 일반 텍스트 권장치는 4.5)
    /// - Returns: 조정된 텍스트 색상. 명암비가 충분하면 원본 색상을 그대로 반환합니다.
    public func adjustedTextColor(originalTextColor: UIColor, backgroundColor: UIColor = .white, minimumContrastRatio: CGFloat = 4.5) -> UIColor {
        // 1. 현재 텍스트 색상과 흰 배경의 명암비를 계산합니다.
        let currentContrastRatio = contrastRatio(between: originalTextColor, and: backgroundColor)

        // 2. 명암비가 이미 충분한지 확인합니다.
        if currentContrastRatio >= minimumContrastRatio {
            // 충분하면 원본 색상을 그대로 반환합니다.
            return originalTextColor
        }
        else {
            // 3. 명암비가 부족하면 색상을 어둡게 조정합니다.

            // HSB(색상, 채도, 밝기) 값을 가져옵니다.
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            originalTextColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

            // 목표 명암비를 만족할 때까지 밝기(brightness)를 점진적으로 낮춥니다.
            var newBrightness = brightness
            var adjustedColor = originalTextColor

            // 밝기를 0.01씩 줄여가며 적절한 지점을 찾습니다.
            while newBrightness > 0 {
                newBrightness -= 0.01

                // 새로운 밝기 값으로 새 색상을 생성합니다.
                let newlyAdjustedColor = UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)

                // 새 색상과 배경의 명암비를 다시 계산합니다.
                let newContrastRatio = contrastRatio(between: newlyAdjustedColor, and: backgroundColor)

                // 목표 명암비를 만족하면 루프를 종료하고 해당 색상을 사용합니다.
                if newContrastRatio >= minimumContrastRatio {
                    adjustedColor = newlyAdjustedColor
                    break
                }

                // 만약 밝기가 0에 도달했는데도 명암비를 만족 못하면
                // 가장 어두운 버전의 색상이 됩니다.
                adjustedColor = newlyAdjustedColor
            }

            return adjustedColor
        }
    }

    /// 두 색상의 명암비를 계산하는 함수입니다.
    public func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
        let luminance1 = color1.relativeLuminance
        let luminance2 = color2.relativeLuminance

        let lighterLuminance = max(luminance1, luminance2)
        let darkerLuminance = min(luminance1, luminance2)

        return (lighterLuminance + 0.05) / (darkerLuminance + 0.05)
    }

}

#endif
