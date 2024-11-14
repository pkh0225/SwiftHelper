//
//  WeakWrapper.swift
//  TestSwiftHelper
//
//  Created by 박길호 on 9/20/24.
//  Copyright © 2024 pkh. All rights reserved.
//

import Foundation

/// 약한 참조를 배열이나 딕셔너리등에서 관리하기 위한 래퍼 클래스
///
/// 사용 예:
/// ```swift
/// class AAA {
///     var bbb: BBB?
///
///     deinit {
///         print("deinit AAA")
///     }
/// }
/// class BBB {
///     var array = [WeakWrapper<AAA>]()
///     var dic = [String: WeakWrapper<AAA>]()
///
///     deinit {
///         print("deinit BBB")
///    }
/// }
///
/// let a = AAA()
/// let b = BBB()   // BBB를 강하게 참조할 변수
///
/// a.bbb = b  // b를 a의 bbb에 설정
/// b.array.append(WeakWrapper(value: a))  // bbb.array에 약한 참조 추가
/// b.dic["111"] = WeakWrapper(value: a)
///```
public class WeakWrapper<T: AnyObject> {
    weak var value: T?

    public init(value: T) {
        self.value = value
    }
}

public struct UncheckedSendableWrapper<Value>: @unchecked Sendable {
    public let value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

public struct UncheckedSendableWrappers<Value1, Value2>: @unchecked Sendable {
    public let value1: Value1
    public let value2: Value2

    public init(value1: Value1, value2: Value2) {
        self.value1 = value1
        self.value2 = value2
    }
}




/// Deinit Checker
///
/// 사용 예:
/// ```swift
/// extension UIViewController {
///     private struct AssociatedKeys {
///         nonisolated(unsafe) static var deallocator: UInt8 = 0
///     }
///
///     class func swizzleMethodForDealloc() {
///         let originalSelector = #selector(viewDidLoad)
///         let swizzledSelector = #selector(swizzled_viewDidLoad)
///         guard
///             let originalMethod = class_getInstanceMethod(Self.self, originalSelector),
///             let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector)
///         else { return }
///         method_exchangeImplementations(originalMethod, swizzledMethod)
///     }
///
///     @objc private func swizzled_viewDidLoad() {
///         let deallocator = Deallocator { print("swizzled deinit: \(Self.self)") }
///         objc_setAssociatedObject(self, &AssociatedKeys.deallocator, deallocator, .OBJC_ASSOCIATION_RETAIN)
///     }
/// }
///```
public class Deallocator {
    var onDeallocate: () -> Void

    public init(onDeallocate: @escaping () -> Void) {
        self.onDeallocate = onDeallocate
    }

    deinit {
        onDeallocate()
    }
}
