//
//  IntExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 16/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    ///   Checks if the integer is even.
    public var isEven: Bool { return (self % 2 == 0) }

    ///   Checks if the integer is odd.
    public var isOdd: Bool { return (self % 2 != 0) }

    ///   Checks if the integer is positive.
    public var isPositive: Bool { return (self > 0) }

    ///   Checks if the integer is negative.
    public var isNegative: Bool { return (self < 0) }

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

    ///   Returns number of digits in the integer.
    public var digits: Int {
        if self == 0 {
            return 1
        }
        else if Int(fabs(Double(self))) <= LONG_MAX {
            return Int(log10(fabs(Double(self)))) + 1
        }
//        else {
//            return -1; //out of bound
//        }
    }

    ///   The digits of an integer represented in an array(from most significant to least).
    /// This method ignores leading zeros and sign
    public var digitArray: [Int] {
        var digits: [Int] = [Int]()
        let array: [String.Element] = Array(self.toString)
        for char in array {
            if let digit: Int = Int(String(char)) {
                digits.append(digit)
            }
        }
        return digits
    }

    ///   Returns a random integer number in the range min...max, inclusive.
    public static func random(within: Range<Int>) -> Int {
        let delta: Int = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
}

extension UInt {
    ///   Convert UInt to Int
    public var toInt: Int { return Int(self) }

    ///   Greatest common divisor of two integers using the Euclid's algorithm.
    /// Time complexity of this in O(log(n))
    public static func gcd(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        let remainder: UInt = firstNum % secondNum
        if remainder != 0 {
            return gcd(secondNum, remainder)
        }
        else {
            return secondNum
        }
    }

    ///   Least common multiple of two numbers. LCM = n * m / gcd(n, m)
    public static func lcm(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        return firstNum * secondNum / UInt.gcd(firstNum, secondNum)
    }
}

extension Int {
    public var f: CGFloat { return CGFloat(self) }
}

extension Float {
    public var f: CGFloat { return CGFloat(self) }
}

extension Double {
    public var f: CGFloat { return CGFloat(self) }
}

extension CGFloat {
    public var swf: Float { return Float(self) }
}
