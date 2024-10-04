//
//  ScopeFunction.swift
//  WiggleSDK
//
//  Created by 박길호 on 8/13/24.
//  Copyright © 2024 mykim. All rights reserved.
//

import UIKit

@inline(__always) public func with<T, R>(_ object: T, _ block: (T) -> R) -> R {
    return block(object)
}

/// Kotlin Scope Function
public protocol ScopeAble {}

extension ScopeAble {
    @discardableResult
    @inline(__always) public func apply(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }

//    @discardableResult
//    @inline(__always) public func also(_ block: (inout Self) throws -> Void) rethrows -> Self {
//        var copy = self
//        try block(&copy)
//        return copy
//    }

    @discardableResult
    @inline(__always) public func run<T>(_ block: (inout Self) throws -> T) rethrows -> T {
        var copy = self
        return try block(&copy)
    }

//    @discardableResult
//    @inline(__always) public func `let`<T>(_ block: (inout Self) throws -> T) rethrows -> T {
//        var copy = self
//        return try block(&copy)
//    }

    @inline(__always) public func takeIf(_ block: (Self) throws -> Bool) rethrows -> Self? {
        return try block(self) ? self : nil
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

extension NSObject: ScopeAble {}
extension ScopeAble where Self: AnyObject {}
extension ScopeAble where Self: Any {}
//extension Bool: ScopeAble {}
//extension String: ScopeAble {}
//extension Character: ScopeAble {}
//extension Int: ScopeAble {}
//extension Int8: ScopeAble {}
//extension Int16: ScopeAble {}
//extension Int32: ScopeAble {}
//extension Int64: ScopeAble {}
//extension UInt: ScopeAble {}
//extension UInt8: ScopeAble {}
//extension UInt16: ScopeAble {}
//extension UInt32: ScopeAble {}
//extension UInt64: ScopeAble {}
//extension Float: ScopeAble {}
//@available(iOS 14.0, *)
//extension Float16: ScopeAble {}
//extension Double: ScopeAble {}
//extension CGFloat: ScopeAble {}

extension Array: ScopeAble {}
extension Set: ScopeAble {}
extension Dictionary: ScopeAble {}
extension JSONDecoder: ScopeAble {}
extension JSONEncoder: ScopeAble {}

extension UIEdgeInsets: ScopeAble {}
extension UIRectEdge: ScopeAble {}
extension UIOffset: ScopeAble{}

extension CGRect: ScopeAble {}
extension CGPoint: ScopeAble {}
extension CGSize: ScopeAble {}
