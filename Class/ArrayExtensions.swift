//
//  ArrayExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import Foundation


public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (lhs?, rhs?):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}

extension Array {
    public func isExist() -> Bool {
        return !self.isEmpty
    }
    
    public func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
    ///  Get a sub array from range of index
    public func get(at range: ClosedRange<Int>) -> Array {
        let halfOpenClampedRange = Range(range).clamped(to: Range(indices))
        return Array(self[halfOpenClampedRange])
    }

    ///   Checks if array contains at least 1 item which type is same with given element's type
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType}
    }

    ///   Decompose an array to a tuple with first element and the rest
    public func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]) : nil
    }

    ///   Iterates on each element of the array with its index. (Index, Element)
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }

    ///   Gets the object at the specified index, if it exists.
    public func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }

    ///   Prepends an object to the array.
    public mutating func insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    ///   Returns a random element from the array.
    public func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }

    ///   Reverse the given index. i.g.: reverseIndex(2) would be 2 to the last
    public func reverseIndex(_ index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }
        return Swift.max(count - 1 - index, 0)
    }

    ///   Shuffles the array in-place using the Fisher-Yates-Durstenfeld algorithm.
    public mutating func shuffle() {
        guard count > 1 else { return }
        var j: Int
        for i in 0..<(count-2) {
            j = Int(arc4random_uniform(UInt32(count - i)))
            if i != i+j { self.swapAt(i, i+j) }
        }
    }

    ///   Shuffles copied array using the Fisher-Yates-Durstenfeld algorithm, returns shuffled array.
    public func shuffled() -> Array {
        var result = self
        result.shuffle()
        return result
    }

    ///   Returns an array with the given number as the max number of elements.
    public func takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }

    ///   Checks if test returns true for all the elements in self
    public func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return !contains { !body($0) }
    }

    ///   Checks if all elements in the array are true or false
    public func testAll(is condition: Bool) -> Bool {
        return testAll { ($0 as? Bool) ?? !condition == condition }
    }
}

extension Array where Element: Equatable {

    ///   Checks if the main array contains the parameter array
    public func contains(_ array: [Element]) -> Bool {
        return array.testAll { self.index(of: $0) ?? -1 >= 0 }
    }

    ///   Checks if self contains a list of items.
    public func contains(_ elements: Element...) -> Bool {
        return elements.testAll { self.index(of: $0) ?? -1 >= 0 }
    }

    ///   Returns the indexes of the object
    public func indexes(of element: Element) -> [Int] {
        return enumerated().compactMap { ($0.element == element) ? $0.offset : nil }
    }

    ///   Returns the last index of the object
    public func lastIndex(of element: Element) -> Int? {
        return indexes(of: element).last
    }

    ///   Removes the first given object
    public mutating func removeFirst(_ element: Element) {
        guard let index = index(of: element) else { return }
        self.remove(at: index)
    }

    ///   Removes all occurrences of the given object(s), at least one entry is needed.
    public mutating func removeAll(_ firstElement: Element?, _ elements: Element...) {
        var removeAllArr = [Element]()
        
        if let firstElementVal = firstElement {
            removeAllArr.append(firstElementVal)
        }
        
        elements.forEach({element in removeAllArr.append(element)})
        
        removeAll(removeAllArr)
    }

    ///   Removes all occurrences of the given object(s)
    public mutating func removeAll(_ elements: [Element]) {
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elements.contains($0) }
    }

    ///   Difference of self and the input arrays.
    public func difference(_ values: [Element]...) -> [Element] {
        var result = [Element]()
        elements: for element in self {
            for value in values {
                //  if a value is in both self and one of the values arrays
                //  jump to the next iteration of the outer loop
                if value.contains(element) {
                    continue elements
                }
            }
            //  element it's only in self
            result.append(element)
        }
        return result
    }

    ///   Intersection of self and the input arrays.
    public func intersection(_ values: [Element]...) -> Array {
        var result = self
        var intersection = Array()

        for (i, value) in values.enumerated() {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if i > 0 {
                result = intersection
                intersection = Array()
            }

            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.forEach { (item: Element) -> Void in
                if result.contains(item) {
                    intersection.append(item)
                }
            }
        }
        return intersection
    }

    ///   Union of self and the input arrays.
    public func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }

    ///   Returns an array consisting of the unique elements in the array
    public func unique() -> Array {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
    
    // Remove first collection element that is equal to the given `object`:
    public mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array where Element: Hashable {

    ///   Removes all occurrences of the given object(s)
    public mutating func removeAll(_ elements: [Element]) {
        let elementsSet = Set(elements)
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elementsSet.contains($0) }
    }
}

// MARK: - Deprecated 1.8

extension Array {

    ///   Checks if array contains at least 1 instance of the given object type
    @available(*, deprecated: 1.8, renamed: "containsType(of:)")
    public func containsInstanceOf<T>(_ element: T) -> Bool {
        return containsType(of: element)
    }

    ///   Gets the object at the specified index, if it exists.
    @available(*, deprecated: 1.8, renamed: "get(at:)")
    public func get(_ index: Int) -> Element? {
        return get(at: index)
    }

    ///   Checks if all elements in the array are true of false
    @available(*, deprecated: 1.8, renamed: "testAll(is:)")
    public func testIfAllIs(_ condition: Bool) -> Bool {
        return testAll(is: condition)
    }
}

extension Array where Element: Equatable {

    ///   Removes the first given object
    @available(*, deprecated: 1.8, renamed: "removeFirst(_:)")
    public mutating func removeFirstObject(_ object: Element) {
        removeFirst(object)
    }
}

// MARK: - Deprecated 1.7

extension Array {

    ///   Prepends an object to the array.
    @available(*, deprecated: 1.7, renamed: "insertFirst(_:)")
    public mutating func insertAsFirst(_ newElement: Element) {
        insertFirst(newElement)
    }

}

extension Array where Element: Equatable {

    ///   Checks if the main array contains the parameter array
    @available(*, deprecated: 1.7, renamed: "contains(_:)")
    public func containsArray(_ array: [Element]) -> Bool {
        return contains(array)
    }

    ///   Returns the indexes of the object
    @available(*, deprecated: 1.7, renamed: "indexes(of:)")
    public func indexesOf(_ object: Element) -> [Int] {
        return indexes(of: object)
    }

    ///   Returns the last index of the object
    @available(*, deprecated: 1.7, renamed: "lastIndex(_:)")
    public func lastIndexOf(_ object: Element) -> Int? {
        return lastIndex(of: object)
    }

    ///   Removes the first given object
    @available(*, deprecated: 1.7, renamed: "removeFirstObject(_:)")
    public mutating func removeObject(_ object: Element) {
        removeFirstObject(object)
    }

}

// MARK: - Deprecated 1.6

extension Array {

    ///   Creates an array with values generated by running each value of self
    /// through the mapFunction and discarding nil return values.
    @available(*, deprecated: 1.6, renamed: "flatMap(_:)")
    public func mapFilter<V>(mapFunction map: (Element) -> (V)?) -> [V] {
        return flatMap { map($0) }
    }

    ///   Iterates on each element of the array with its index.  (Index, Element)
    @available(*, deprecated: 1.6, renamed: "forEachEnumerated(_:)")
    public func each(_ call: @escaping (Int, Element) -> Void) {
        forEachEnumerated(call)
    }

}

public typealias DictionaryClosure = (_ value: Dictionary<String,Any>?) -> Void

extension Array where Element == DictionaryClosure {
    public mutating func dequeue(_ value: Dictionary<String,Any>? = nil){
        objc_sync_enter(self)
        guard self.count > 0 || self.first != nil else { return }
        
        let work = self.removeFirst()
        defer { work(value) }
        objc_sync_exit(self)
    }
    
    public mutating func enqueue(_ work: @escaping DictionaryClosure) {
        objc_sync_enter(self)
        self.append(work)
        objc_sync_exit(self)
    }
    
}

extension Array where Element: NSObject {
    public func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy() as! Element)
        }
        return copiedArray
    }
}
