//
//  CGFloatExtensions.swift
//  EZSwiftExtensions
//
//  Created by Cem Olcay on 12/08/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// 소수점 자르기
/// - Parameters:
///   - value: 소수점이 있는 숫자
///   - count: 몇자리 까지
/// - Returns: 소수점이 잘려진 숫자

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

    /**
      EZSE :Returns the shortest angle between two angles. The result is always between
      -π and π.

      Inspired from : https://github.com/raywenderlich/SKTUtils/blob/master/SKTUtils/CGFloat%2BExtensions.swift
     */
    public static func shortestAngleInRadians(from first: CGFloat, to second: CGFloat) -> CGFloat {
        let twoPi: CGFloat = CGFloat(.pi * 2.0)
        var angle: CGFloat = (second - first).truncatingRemainder(dividingBy: twoPi)
        if angle >= .pi {
            angle -= twoPi
        }
        if angle <= -.pi {
            angle += twoPi
        }
        return angle
    }

    @inline(__always) public func decimalCut(_ count: Int = 3) -> CGFloat {
        guard count > 0 else { return self }
        let point: CGFloat = pow(10.0, CGFloat(count))
        return CGFloat(Int(self * point)) / point
    }

}

#endif
