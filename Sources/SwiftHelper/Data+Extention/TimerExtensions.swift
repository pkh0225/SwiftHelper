//
//  TimerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lucas Farah on 15/07/15.
//  Copyright (c) 2016 Lucas Farah. All rights reserved.
//

import Foundation

extension Timer {
    // 지정된 횟수만큼 실행되는 CFRunLoop 기반 타이머 생성
    @discardableResult
    public static func schedule(repeatInterval: TimeInterval, repeatCount: Int = 0, delayStart: Bool = true, _ handler: @escaping (Timer, Int) -> Void) -> Timer {
        var count = 0
        var fireDate: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()

        if delayStart {
            fireDate += repeatInterval
        }

        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, repeatInterval, 0, 0) { runLoopTimer in
            count += 1
            handler(timer!, count)

            if repeatCount != 0, count >= repeatCount {
                CFRunLoopTimerInvalidate(runLoopTimer) // 타이머 중지
            }
        }

        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }

    ///   Run function after x seconds
    @discardableResult
    public static func schedule(delay: TimeInterval, _ handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate: CFAbsoluteTime = delay + CFAbsoluteTimeGetCurrent()
        let timer: CFRunLoopTimer? = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }


}
