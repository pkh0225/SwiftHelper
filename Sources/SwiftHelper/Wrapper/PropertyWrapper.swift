//
//  PropertyWrapper.swift
//  Test
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 8/14/24.
//  Copyright © 2024 pkh. All rights reserved.
//
import Foundation

@propertyWrapper
public struct Atomic<Value> {
    private var value: Value
    private let lock = NSLock()

    public init(wrappedValue value: Value) {
        self.value = value
    }

    public var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    public func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    public mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
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
            userDefault.set(newValue, forKey: key)

        }
    }

    public init(wrappedValue: Value, key: String, groupID: String? = nil) {
        self.key = key
        self.defaultValue = wrappedValue
        self.groupID = groupID
    }
}
