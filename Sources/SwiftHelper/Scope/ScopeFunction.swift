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
    /// 주어진 블록을 인스턴스의 변경 가능한 복사본에 적용합니다.
    ///
    /// 이 메서드는 인스턴스의 변경 가능한 복사본을 생성하고, 제공된 클로저에 전달합니다.
    /// 클로저를 실행한 후, 수정된 복사본을 반환합니다.
    ///
    /// - Parameter block: 인스턴스와 동일한 타입의 `inout` 매개변수를 받는 클로저입니다.
    ///                   이 클로저는 인스턴스를 직접 수정할 수 있습니다.
    /// - Returns: 클로저가 실행된 후 수정된 인스턴스의 복사본을 반환합니다.
    /// - Throws: 제공된 클로저에서 발생한 오류를 다시 던집니다.
    ///
    /// 사용 예:
    /// ```swift
    /// let label = UILabel() {
    ///     $0.text = "안녕하세요, Swift!"
    ///     $0.textColor = .blue
    /// }
    ///
    /// print("UILabel 텍스트: \(label.text ?? "")")
    /// print("UILabel 텍스트 색상: \(label.textColor!)")
    /// ```
    ///
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

    /// 주어진 블록을 인스턴스의 변경 가능한 복사본에 실행합니다.
    ///
    /// 이 메서드는 인스턴스의 변경 가능한 복사본을 생성하고, 제공된 클로저를 실행한 후
    /// 클로저의 결과를 반환합니다.
    ///
    /// - Parameter block: 인스턴스와 동일한 타입의 `inout` 매개변수를 받는 클로저입니다.
    ///                   이 클로저는 인스턴스를 직접 수정할 수 있으며, 반환값은 제네릭 타입 `T`입니다.
    /// - Returns: 클로저가 실행된 결과를 반환합니다.
    /// - Throws: 제공된 클로저에서 발생한 오류를 다시 던집니다.
    ///
    /// 사용 예:
    /// ```swift
    /// let originalLabel = UILabel()
    /// originalLabel.text = "안녕하세요"
    /// originalLabel.textColor = .black
    ///
    /// print("원래 UILabel 텍스트: \(originalLabel.text ?? "")") // 원래 UILabel 텍스트: 안녕하세요
    /// print("수정된 UILabel 텍스트 색상: \(originalLabel.textColor!)") // 원래 UILabel 텍스트 색상: 0 0 0 1
    ///
    /// // run을 사용하여 UILabel을 수정하고 결과를 가져옵니다.
    /// let textLength = originalLabel.run { label in
    ///     label.text = "안녕하세요, Swift!"
    ///     label.textColor = .blue
    ///     return label.text?.count ?? 0 // 텍스트 길이를 반환
    /// }
    ///
    /// print("수정된 UILabel 텍스트: \(originalLabel.text ?? "")") // 수정된 UILabel 텍스트: 안녕하세요, Swift!
    /// print("수정된 UILabel 텍스트 색상: \(originalLabel.textColor!)") // 수정된 UILabel 텍스트 색상: UIExtendedSRGBColorSpace 0 0 1 1
    /// print("수정된 텍스트 길이: \(textLength)") // 수정된 텍스트 길이: 18
    /// ```
    ///
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

    /// 주어진 블록의 결과에 따라 인스턴스를 반환합니다.
    ///
    /// 이 메서드는 인스턴스에 대해 제공된 클로저를 실행하고,
    /// 클로저가 `true`를 반환할 경우 인스턴스를 반환합니다.
    /// 그렇지 않으면 `nil`을 반환합니다.
    ///
    /// - Parameter block: 인스턴스를 인자로 받아 `Bool` 값을 반환하는 클로저입니다.
    /// - Returns: 클로저가 `true`를 반환하면 인스턴스를, 그렇지 않으면 `nil`을 반환합니다.
    ///
    /// 사용 예:
    /// ```swift
    /// let label = UILabel()
    /// label.text = "안녕하세요!"
    /// label.textColor = .black
    ///
    /// // takeIf를 사용하여 UILabel이 특정 조건을 만족하는지 확인합니다.
    /// let validText = label.takeIf { $0.text?.count ?? 0 > 5 }?.text ?? "5개 이상 있지 않습니다."
    ///
    /// ```
    ///
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
