//
//  DispatchQueue.swift
//  SwiftHelper
//
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

let ssgConcurrentQueue = DispatchQueue(label: "queue_ssg_concurrent_label", qos: .userInitiated, attributes: .concurrent)

public func gcd_thread(_ block: @escaping () -> Void) {
    ssgConcurrentQueue.async {
        block()
    }
}

public func gcd_thread_after(_ delay: Double, _ block: @escaping () -> Void) {
    ssgConcurrentQueue.asyncAfter(deadline: .now() + delay, execute: {
        block()
    })
}

public final class ActionQueue {
    public static let shared = ActionQueue()
    private let actions = Queue<(_ value: [String: Any]?) -> Void>()

    public var isEmpty: Bool {
        return actions.isEmpty
    }

    public func nextRun(_ value: [String: Any]? = nil) {
        guard !actions.isEmpty, let work = actions.dequeue() else { return }
        DispatchQueue.main.async {
            work(value)
        }
    }

    public func addAction(_ work: @escaping (_ value: [String: Any]?) -> Void) {
        actions.enqueue(work)
    }
}
