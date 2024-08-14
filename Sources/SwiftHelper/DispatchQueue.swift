//
//  DispatchQueue.swift
//  WiggleSDK
//
//  Created by  bdb on 2018. 4. 26..
//  Copyright © 2018년 mykim. All rights reserved.
//

import UIKit

public func gcd_main_safe(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    }
    else {
        DispatchQueue.main.async(execute: block)
    }
}

public func gcd_main_after(_ delay: Double, _ block: @escaping () -> Void) {
    if delay <= 0 {
        DispatchQueue.main.async {
            block()
        }
    }
    else {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
}
/// 여러개의 비동기코드를 처리한 후 완료 이벤트를 받고 싶을때 사용
///
/// 예제
/// gcd_group([{ (group) in
///   내부에서 async로 처리됨
///    for i in (0..<10) {
///        print("1:\(i)")
///    }
///    }, { (group) in
///   내부에서 async로 처리됨
///        for i in (0..<10) {
///            print("2:\(i)")
///        }
///    }, { (group) in
///   ❗️내부에서 async로 처리되는데 또 async를 되어질때 (통신단 등등..)
///        let queue = DispatchQueue(label: "queue\(1234)")
///        group.enter() ❗️<-- group에 등록❗️
///        queue.async {
///            for i in (0..<1000) {
///                print("----3:\(i)")
///            }
///            group.leave() ❗️<-- group에 해제❗️
///        }
///
///    }]) {
///        print("\n\n\t--- completion ---\n\n")
/// }
/// - Parameters:
///   - works: 비동기로 실행할 코드
///   - completion: 비동기로 처리된 코드가 다 수행된 후 완료 이벤트
public func gcd_group(_ works: [(_ group: DispatchGroup) -> Void], completion: @escaping () -> Void) {
    let group = DispatchGroup()

    for (idx, work) in works.enumerated() {
        let queue = DispatchQueue(label: "queue\(idx)")
        queue.async(group: group) {
            work(group)
        }
    }
    group.wait()
    group.notify(queue: .main) {
        completion()
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
    private static var _onceTracker = [String]()

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
