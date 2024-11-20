//
//  DispatchQueue.swift
//  WiggleSDK
//
//  Created by  bdb on 2018. 4. 26..
//  Copyright © 2018년 mykim. All rights reserved.
//

import UIKit

@preconcurrency public func gcd_main_safe(_ work: @escaping @convention(block) () -> Void) {
    let ucsw = UncheckedSendableWrapper(work)
    if Thread.isMainThread {
        ucsw.value()
    }
    else {
        DispatchQueue.main.async {
            ucsw.value()
        }
    }
}

@preconcurrency public func gcd_main_after(_ delay: Double, _ work: @escaping @convention(block) () -> Void) {
    let ucsw = UncheckedSendableWrapper(work)
    if delay <= 0 {
        DispatchQueue.main.async {
            ucsw.value()
        }
    }
    else {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            ucsw.value()
        }
    }
}

public func printTimeElapsedWhenRunningCode(title: String, operation: () -> Void) {
    let startTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed: Double = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(String(format: "%.10f", timeElapsed)) s.")
}

public func timeElapsedInSecondsWhenRunningCode(operation: () -> Void) -> Double {
    let startTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed: Double = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}
/**
 예제
 */
// DispatchQueue.once(token: TopDetailCollectionViewCell.className) {
//    if let cell : TopDetailCollectionViewCell = Bundle.loadNib(TopDetailCollectionViewCell.className)  {
//        cell.configure(self.dataItem.item!)
//        cell.layoutIfNeeded()
//        let cellSize = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        print(cellSize.height)
//    }
// }

// 앱 실행중 한번임
public extension DispatchQueue {
    nonisolated(unsafe) private static var _onceTracker = [String]()

    class func once(file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }

    /**
        같은 함수가 아닌 여러곳에서 중복실행을 방지 하고 싶을때는 아래 함수를 사용 token을 꼭 만들어서 사용해야 함
     
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }
}

public final class ActionQueue: Sendable {
    public static let shared = ActionQueue()
    private let queue = DispatchQueue(label: "com.ActionQueue.queue")
    nonisolated(unsafe) private var actions: [(_ value: [String: Any]?) -> Void] = []

    public init() {}
    
    public func nextRun(_ value: [String: Any]? = nil) {
        queue.sync {
            guard !self.actions.isEmpty, let work = self.actions.first else { return }
            let workWrapper = UncheckedSendableWrapper(work)
            let valueWrapper = UncheckedSendableWrapper(value)
            self.actions.removeFirst()
            DispatchQueue.main.async {
                workWrapper.value(valueWrapper.value)
            }
        }
    }

    public func addAction(_ work: @escaping @convention(block) (_ value: [String: Any]?) -> Void) {
        let workWrapper = UncheckedSendableWrapper(work)
        self.queue.async(flags: .barrier) {
            self.actions.append(workWrapper.value)
        }
    }
}
