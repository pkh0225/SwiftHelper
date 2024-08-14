//
//  ArrayExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import Foundation
import UIKit

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

    public func contains<T>(obj: T) -> Bool where T: Equatable {
        return self.filter({ $0 as? T == obj }).count > 0
    }

    ///   Serialize Dictionary into JSON string
    public func jsonString() -> String? {
        if let jsonData: Data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            if let jsonStr: String = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                return jsonStr
            }
            return ""
        }
        return nil
    }

    ///  Get a sub array from range of index
//    public func get(at range: ClosedRange<Int>) -> Array {
//        let halfOpenClampedRange = Range(range).clamped(to: Range(indices))
//        return Array(self[halfOpenClampedRange])
//    }

    ///   Checks if array contains at least 1 item which type is same with given element's type
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType }
    }

    ///   Decompose an array to a tuple with first element and the rest
//    public func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
//
//        if count > 0 {
//            return (self[0], self[1..<count])
//        }
//        else {
//            return nil
//        }
//    }

    ///   Iterates on each element of the array with its index. (Index, Element)
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }

    ///   Gets the object at the specified index, if it exists.
    public subscript(safe index: Int?) -> Element? {
        guard let index else { return nil }
        if indices.contains(index) {
            return self[index]
        }
        else {
            return nil
        }
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
//    public mutating func shuffle() {
//        guard count > 1 else { return }
//        var j: Int
//        for i in 0..<(count-2) {
//            j = Int(arc4random_uniform(UInt32(count - i)))
//            if i != i+j { self.swapAt(i, i+j) }
//        }
//    }

    ///   Shuffles copied array using the Fisher-Yates-Durstenfeld algorithm, returns shuffled array.
//    public func shuffled() -> Array {
//        var result = self
//        result.shuffle()
//        return result
//    }

    ///   Returns an array with the given number as the max number of elements.
    public func takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }

    public func sortForwardIndex(_ index: Int) -> Array {
        let result = self

        guard index > 0 else { return result }
        guard self[safe: index] != nil else { return Array() }

        var headData = Array()
        var tailData = Array()

        for (i, item) in result.enumerated() {
            if i >= index {
                headData.append(item)
            }
            else {
                tailData.append(item)
            }
        }

        headData.append(contentsOf: tailData)

        return headData
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
        return array.testAll { self.firstIndex(of: $0) ?? -1 >= 0 }
    }

    ///   Checks if self contains a list of items.
    public func contains(_ elements: Element...) -> Bool {
        return elements.testAll { self.firstIndex(of: $0) ?? -1 >= 0 }
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
        guard let index = firstIndex(of: element) else { return }
        self.remove(at: index)
    }

    ///   Removes all occurrences of the given object(s), at least one entry is needed.
    public mutating func removeAll(_ firstElement: Element?, _ elements: Element...) {
        var removeAllArr = [Element]()

        if let firstElementVal = firstElement {
            removeAllArr.append(firstElementVal)
        }

        elements.forEach({ element in removeAllArr.append(element) })

        removeAll(removeAllArr)
    }

    ///   Removes all occurrences of the given object(s)
    public mutating func removeAll(_ elements: [Element]) {
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elements.contains($0) }
    }

    ///   Difference of self and the input arrays.
    public func difference(_ values: [Element]...) -> [Element] {
        var result: [Element] = [Element]()
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
        if let index = firstIndex(of: object) {
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

extension Array where Element: Equatable {
    ///   Removes the first given object
    @available(*, deprecated, renamed: "removeFirst(_:)")
    public mutating func removeFirstObject(_ object: Element) {
        removeFirst(object)
    }
}

extension Array where Element == (_ value: [String: Any]?) -> Void {
    public mutating func dequeue(_ value: [String: Any]? = nil) {
        guard self.count > 0 || self.first != nil else { return }
        let work = self.removeFirst()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            work(value)
        }
    }

    public mutating func enqueue(_ work: @escaping (_ value: [String: Any]?) -> Void) {
        self.append(work)
    }

}

extension Array where Element == () -> Void {
    public mutating func dequeue() {
        guard self.count > 0 || self.first != nil else { return }
        let work = self.removeFirst()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            work()
        }
    }

    public mutating func enqueue(_ work: @escaping () -> Void) {
        self.append(work)
    }

}

extension Array where Element: NSObject {
    public func clone() -> Array {
        var copiedArray = [Element]()
        for element in self {
            copiedArray.append(element.copy() as! Element)
        }
        return copiedArray
    }
}

extension Array where Element == UIButton {
    public mutating func sw_addUtilityButton(with normal: UIImage?, selectedImg: UIImage?) {
        let button: UIButton = UIButton(type: .custom)
        button.setBackgroundImage(normal, for: .normal)
        button.setBackgroundImage(selectedImg, for: .highlighted)
        self.append(button)
    }
    public mutating func sw_addUtilityButton(with color: UIColor?, title: String?) {
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        self.append(button)
    }
    public mutating func sw_addUtilityButton(with color: UIColor?, attributedTitle title: NSAttributedString?) {
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = color
        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        self.append(button)
    }
    public mutating func sw_addUtilityButton(with color: UIColor?, icon: UIImage?) {
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = color
        button.setImage(icon, for: .normal)
        self.append(button)
    }
    public mutating func sw_addUtilityButton(with color: UIColor?, normalIcon: UIImage?, selectedIcon: UIImage?) {
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = color
        button.setImage(normalIcon, for: .normal)
        button.setImage(selectedIcon, for: .highlighted)
        button.setImage(selectedIcon, for: .selected)
        self.append(button)
    }
}

// extension Optional where Wrapped == Array<Any> {
//    public var count: Int {
//        return self?.count ?? 0
//    }
// }

extension Array where Element: UIView {
    /// reused된 View를 리턴
    /// - Parameters:
    ///   - parentView: 아이템뷰가 들어갈 부모뷰
    ///   - size: 아이템 기본 사이즈
    /// - Returns: reused 된 View
    @inline(__always) public mutating func getReusedView(parentView: UIView, size: CGSize = .zero) -> Element {
        func isXibFileExists(_ fileName: String) -> Bool {
            if let path: String = Bundle.main.path(forResource: fileName, ofType: "nib") {
                if FileManager.default.fileExists(atPath: path) {
                    return true
                }
            }
            return false
        }
        var view: Element?

        for item in self {
            if item.isHidden {
                item.isHidden = false
                view = item
                break
            }
        }

        if view == nil {
            if isXibFileExists(Element.className) {
                view = Element.fromXib()
                if size != .zero {
                    view?.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                }
            }
            else {
                view = Element(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }

            view?.isHidden = false
            self.append(view!)

            if let p = parentView as? UIStackView {
                p.addArrangedSubview(view!)
            }
            else {
                parentView.addSubview(view!)
            }

        }

        return view!
    }

    @inline(__always) public func setHiddenAll(_ value: Bool) {
        self.forEach { $0.isHidden = value }
    }

    @inline(__always) public func getNoHiddenViews() -> [Element] {
        return  self.filter({ $0.isHidden == false })
    }

    /// 아이템을 왼쪽에서부터 배치 ( reused 되는 cell에서는  width fit false로 두지 말것 )
    /// - Parameters:
    ///   - maxLineCount: 0: 무한,  1이상이면 maxLine
    ///   - spacing: 아이템 간격
    ///   - fit: filt 여부
    /// - Returns fit된 부모 사이즈
    @discardableResult
    @inline(__always) public func sizeThatFits(maxLineCount: Int, spacing: (inset: UIEdgeInsets, columnSpacing: CGFloat, lineSpacing: CGFloat), fit: (width: Bool, height: Bool)) -> CGSize {
        guard let superView = self[safe: 0]?.superview else { return .zero }

        var x: CGFloat = spacing.inset.left
        var y: CGFloat = spacing.inset.top
        var maxX: CGFloat = 0
        var maxY: CGFloat = spacing.inset.top
        var lineCount: Int = 0

        if superView.translatesAutoresizingMaskIntoConstraints == false, superView.ec.isWidth, maxLineCount == 1, fit.width == true {
            superView.ec.reset(.width)
            superView.layoutIfNeeded()
        }

        for v in getNoHiddenViews() {
            v.x = x
            v.y = y
            if v.maxX > superView.w {
                lineCount += 1

                if maxLineCount > 0, lineCount >= maxLineCount {
                    // 마지막 라인일 경우 사이즈넘치는애 히든처리하고 다음아이템중에 넣을자리 있는지 체크하기 위해 커언티뉴우
                    v.isHidden = true
                    continue
                }
                else {
                    x = spacing.inset.left
                    if maxY == spacing.inset.top {
                        y = maxY
                    }
                    else {
                        y = maxY + spacing.lineSpacing
                    }

                    v.x = x
                    v.y = y
                }
            }

            x = v.maxX + spacing.columnSpacing
            maxX = Swift.max(maxX, v.maxX)
            maxY = Swift.max(maxY, v.maxY)
        }

        let contentSize = CGSize(width: maxX + spacing.inset.right, height: maxY + spacing.inset.bottom)

        if fit.width {
            if superView.translatesAutoresizingMaskIntoConstraints == false, superView.ec.isWidth {
                superView.ec.width = contentSize.width
            }
            else if superView.w != contentSize.w {
                superView.w = contentSize.w
            }
        }
        if fit.height {
            if superView.translatesAutoresizingMaskIntoConstraints == false, superView.ec.isHeight {
                superView.ec.height = contentSize.height
            }
            else if superView.h != contentSize.h {
                superView.h = contentSize.h
            }
        }

        return contentSize
    }

    /// 아이템을 배치
    /// - Parameters:
    ///   - maxLineCount: 0: 무한,  1이상이면 maxLine
    ///   - spacing: 아이템 간격
    ///   - fit: filt 여부
    /// - Returns fit된 부모 사이즈
    @discardableResult
    @inline(__always) public func sizeThatFitsVertical(maxLineCount: Int, spacing: (inset: UIEdgeInsets, lineSpacing: CGFloat), fit: (width: Bool, height: Bool)) -> CGSize {
        guard let superView = self[safe: 0]?.superview else { return .zero }

        var y: CGFloat = spacing.inset.top
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0

        for (i, v) in getNoHiddenViews().enumerated() {
            if maxLineCount > 0, i >= maxLineCount {
                v.isHidden = true
                continue
            }

            v.x = spacing.inset.left
            v.y = y
            y = v.maxY + spacing.lineSpacing
            maxX = Swift.max(maxX, v.maxX)
            maxY = v.maxY
        }

        let contentSize = CGSize(width: maxX + spacing.inset.right, height: maxY + spacing.inset.bottom)

        if fit.width {
            if superView.w != contentSize.w {
                superView.w = contentSize.w
            }
            if superView.ec.isWidth {
                superView.ec.width = contentSize.width
            }
        }
        if fit.height {
            if superView.h != contentSize.h {
                superView.h = contentSize.h
            }
            if superView.ec.isHeight {
                superView.ec.height = contentSize.height
            }
        }

        return contentSize
    }
}

@available(iOS 13.0, *)
extension Sequence {
    public func concurrentMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        let tasks = map { element in
            Task {
                await transform(element)
            }
        }

        return await tasks.asyncMap { task in
            await task.value
        }
    }

    public func asyncMap<T>(_ transform: (Element) async -> T) async -> [T] {
        var values = [T]()
        for element in self {
            await values.append(transform(element))
        }
        return values
    }

    public func concurrentForEach(_ operation: @escaping (Element) async -> Void) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await operation(element)
                }
            }
        }
    }
}
