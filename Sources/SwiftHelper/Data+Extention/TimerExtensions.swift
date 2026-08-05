//
//  TimerExtensions.swift
//  EZSwiftExtensions
//
//  Copyright (c) 2016 Lucas Farah. All rights reserved.
//

import Foundation

extension Timer {
    /**
         지정된 간격으로 실행되는 타이머를 생성하며, 일정 횟수 후 자동으로 중지됩니다.

         - Parameters:
         - repeatInterval: 타이머가 반복 실행되는 간격(초 단위).
         - repeatCount: 실행할 총 횟수 (기본값 `0`은 무한 반복).
         - delayStart: `true`일 경우 처음 실행을 `repeatInterval`만큼 지연 (기본값 `true`).
         - handler: 각 실행마다 호출되는 클로저. 현재 타이머와 실행 횟수를 반환.

         - Returns: 생성된 `Timer` 객체.

         - Note:
         1. `repeatCount`가 0이면 무한 반복되며, 수동으로 `invalidate()`를 호출해야 합니다.
         2. `repeatCount`가 설정된 경우, 지정된 횟수만큼 실행 후 자동으로 타이머가 중지됩니다.
         3.  중지만 되지 timer 객체는 nil 되지 않습니다. 수동으로 nil 처리 해줘야 합니다.
     */
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

    ///   Runs every x seconds, to cancel use: timer.invalidate()
    @discardableResult
    public static func schedule(repeatInterval: TimeInterval, delayStart: Bool = true, _ handler: @escaping (Timer?) -> Void) -> Timer {
        var fireDate: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        if delayStart {
            fireDate += repeatInterval
        }
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, repeatInterval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
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
