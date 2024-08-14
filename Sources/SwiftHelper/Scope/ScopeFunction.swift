//
//  ScopeFunction.swift
//  WiggleSDK
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 8/13/24.
//  Copyright © 2024 mykim. All rights reserved.
//

import UIKit

@inline(__always) public func with<T, R>(_ object: T, _ block: (T) -> R) -> R {
    return block(object)
}

public protocol Appliable {}
extension Appliable {
    @discardableResult
    @inline(__always) public func apply(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }

    @discardableResult
    @inline(__always) public func run<T>(_ block: (Self) -> T) -> T {
        return block(self)
    }

    @discardableResult
    @inline(__always) public func `let`<T>(_ block: (Self) -> T) -> T {
        return block(self)
    }

    @inline(__always) public func des() -> String {
        var stringList = ["\n\t****** \(String(describing: type(of: self))) ******"]
        let mirror: Mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            stringList.append("\t\(label) : \(value)")
        }

        stringList.append(Array(repeating: "*", count: stringList[0].count - 2).joined())
        stringList.append("\n")
        return stringList.joined(separator: "\n\t")
    }
}

extension NSObject: Appliable {}
extension Appliable where Self: AnyObject {}
extension Bool: Appliable {}
extension String: Appliable {}
extension Character: Appliable {}
extension Int: Appliable {}
extension UInt: Appliable {}
extension Float: Appliable {}
extension Double: Appliable {}
extension CGFloat: Appliable {}
extension Array: Appliable {}
extension Set: Appliable {}
extension Dictionary: Appliable {}
extension UIEdgeInsets: Appliable {}
extension UIRectEdge: Appliable {}
extension CGRect: Appliable {}
extension CGPoint: Appliable {}
extension CGSize: Appliable {}
