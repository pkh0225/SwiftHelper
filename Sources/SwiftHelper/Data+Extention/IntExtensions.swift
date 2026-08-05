//
//  IntExtensions.swift
//  EZSwiftExtensions
//
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    ///   Converts integer value to Double.
    public var toDouble: Double { return Double(self) }

    ///   Converts integer value to Float.
    public var toFloat: Float { return Float(self) }

    public var toCGFloat: CGFloat { return CGFloat(self) }

    ///   Converts integer value to String.
    public var toString: String { return String(self) }

    ///   Converts integer value to UInt.
    public var toUInt: UInt { return UInt(self) }

    ///   Converts integer value to Int32.
    public var toInt32: Int32 { return Int32(self) }

    ///   Converts integer value to Int64.
    public var toInt64: Int64 { return Int64(self) }

    ///   Converts integer value to a 0..<Int range. Useful in for loops.
    public var range: CountableRange<Int> { return 0..<self }

    ///   Returns a random integer number in the range min...max, inclusive.
    public static func random(within: Range<Int>) -> Int {
        let delta: Int = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
}

extension UInt {
    public var toInt: Int { return Int(self) }
}
