//
//  CGColorExtensions.swift
//  WiggleSDK
//
//  Created by 전선수 on 1/17/24.
//  Copyright © 2024 mykim. All rights reserved.
//

import QuartzCore

@available(iOS 13.0, *)
extension CGColor {
    /// CGColor - sRGB clear
    public static let clear = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0)
    /// CGColor - sRGB black
    public static let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    /// hex(UInt32), alpha 값 기반으로 CGColor를 생성하는 factory 메서드
    public static func makeBaseCGColor(hex color: UInt32, alpha: CGFloat = 1) -> CGColor {
        let r = UInt8(((color >> 16) & 0xff)) // red
        let g = UInt8(((color >> 8) & 0xff)) // green
        let b = UInt8((color & 0xff)) // blue
        return .init(srgbRed: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
