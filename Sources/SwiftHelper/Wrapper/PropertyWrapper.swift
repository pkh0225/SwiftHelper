//
//  PropertyWrapper.swift
//  SwiftHelper
//
//  Copyright © 2021 mykim. All rights reserved.
//

import Foundation
import os

@propertyWrapper
public struct Atomic<Value> {
    private let loadValue: () -> Value
    private let storeValue: (Value) -> Void

    public init(wrappedValue value: Value) {
        if #available(iOS 16.0, *) {
            let storage = OSAllocatedUnfairLock(initialState: value)
            self.loadValue = {
                storage.withLock { $0 }
            }
            self.storeValue = { newValue in
                storage.withLock { $0 = newValue }
            }
        }
        else {
            let lock = NSLock()
            let box = AtomicValueBox(value)
            self.loadValue = {
                lock.lock()
                defer { lock.unlock() }
                return box.value
            }
            self.storeValue = { newValue in
                lock.lock()
                defer { lock.unlock() }
                box.value = newValue
            }
        }
    }

    public var wrappedValue: Value {
        get { load() }
        set { store(newValue: newValue) }
    }

    public func load() -> Value {
        loadValue()
    }

    public func store(newValue: Value) {
        storeValue(newValue)
    }
}

private final class AtomicValueBox<Value>: @unchecked Sendable {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
}

@propertyWrapper
public struct PriceFormatWrapper {
    var priceStr: String
    public var wrappedValue: String {
        get { return priceStr }
        set {
            priceStr = newValue.convertPriceFormat()
        }
    }
    public init(wrappedValue: String) {
        self.priceStr = ""
        self.wrappedValue = wrappedValue
    }
}
/*
struct Solution {
    @Clamping(0...14) var pH: Double = 7.0
}
*/
@propertyWrapper
public struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    public init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper
public struct UserDefaultWrapper<Value> {
    let key: String
    let defaultValue: Value
    let groupID: String?

    public var wrappedValue: Value {
        get {
            var userDefault: UserDefaults
            if let groupId = self.groupID {
                userDefault = UserDefaults(suiteName: groupId)!
            }
            else {
                userDefault = UserDefaults.standard
            }
            return userDefault.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            var userDefault: UserDefaults
            if let groupId = self.groupID {
                userDefault = UserDefaults(suiteName: groupId)!
            }
            else {
                userDefault = UserDefaults.standard
            }

            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefault.removeObject(forKey: key)
            }
            else {
                userDefault.set(newValue, forKey: key)
            }
        }
    }

    public init(wrappedValue: Value, key: String, groupID: String? = nil) {
        self.key = key
        self.defaultValue = wrappedValue
        self.groupID = groupID
    }
}
