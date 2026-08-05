//
//  CGFloatExtensions.swift
//  EZSwiftExtensions
//
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// 0.5 단위 버림 처림
/// 0.5 작으면 0
/// 0.5 보다 크면 0.5
/// - Returns: 0.5 단위 버림 처리
@inline(__always) public func floorUI(_ value: CGFloat) -> CGFloat {
    guard value != 0 else { return 0 }
    let roundValue = round(value)
    let floorValue = floor(value)
    if roundValue == floorValue {
        return CGFloat(roundValue)
    }
    return CGFloat(roundValue - 0.5)
}

/// - Returns: 화면 배율 단위 올림 처리
/// 3배수 디바이스 기준으로
/// 소수부분이 0 이면 값 그대로
/// 0.333 이하면 0.333
/// 0.666 이하면 0.666
/// 0.666 보다 크면 1
@inline(__always) public func ceilUI(_ value: CGFloat) -> CGFloat {
    guard value != 0 else { return 0 }
    let screenScale = UIScreen.main.scale
    guard screenScale > 0 else { return value }
    let floorValue = floor(value)
    for i in 0..<Int(screenScale) {
        let scaleFactor = decimalCut(CGFloat(i) / screenScale)
        if value - floorValue <= scaleFactor {
            return floorValue + scaleFactor
        }
    }
    return ceil(value)
}

/// 소수점 자르기
/// - Parameters:
///   - value: 소수점이 있는 숫자
///   - count: 몇자리 까지
/// - Returns: 소수점이 잘려진 숫자
@inline(__always) public func decimalCut(_ value: CGFloat?, count: Int = 3) -> CGFloat {
    guard let value, value != 0, count != 0 else { return 0 }
    let point: CGFloat = pow(10.0, CGFloat(count))
    return CGFloat(Int(value * point)) / point
}

/// 소수점 자르기
/// - Parameters:
///   - value: 소수점이 있는 숫자
///   - count: 몇자리 까지
/// - Returns: 소수점이 잘려진 숫자

@inline(__always) public func decimalCut(_ value: Double?, count: Int = 3) -> CGFloat {
    guard let value, value != 0, count != 0 else { return 0 }
    let point: CGFloat = pow(10.0, CGFloat(count))
    return CGFloat(Int(value * point)) / point
}

extension CGFloat {
    public var toString: String { return String(describing: self) }
    ///   Return the central value of CGFloat.
    public var center: CGFloat { return (self / 2) }

    @available(*, deprecated, renamed: "degreesToRadians")
    public func toRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }

    /// EZSwiftExtensions
    public func degreesToRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }

    /// EZSwiftExtensions
    public mutating func toRadiansInPlace() {
        self = (.pi * self) / 180.0
    }

    ///   Converts angle degrees to radians.
    public static func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (.pi * angle) / 180.0
    }

    ///   Converts radians to degrees.
    public func radiansToDegrees() -> CGFloat {
        return (180.0 * self) / .pi
    }

    ///   Converts angle radians to degrees mutable version.
    public mutating func toDegreesInPlace() {
        self = (180.0 * self) / .pi
    }

    /// EZSE : Converts angle radians to degrees static version.
    public static func radiansToDegrees(_ angleInDegrees: CGFloat) -> CGFloat {
        return (180.0 * angleInDegrees) / .pi
    }

    ///   Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFF)
    }

    ///   Returns a random floating point number in the range min...max, inclusive.
    public static func random(within: Range<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }

    ///   Returns a random floating point number in the range min...max, inclusive.
    public static func random(within: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }

}

#endif
