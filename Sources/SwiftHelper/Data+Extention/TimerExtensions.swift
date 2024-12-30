//
//  TimerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lucas Farah on 15/07/15.
//  Copyright (c) 2016 Lucas Farah. All rights reserved.
//

import Foundation

extension Timer {
    ///   Runs every x seconds, to cancel use: timer.invalidate()
    @discardableResult
    public class func schedule(repeatInterval: TimeInterval, delayStart: Bool = true, _ handler: @escaping (Timer?) -> Void) -> Timer {
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
    public class func schedule(delay: TimeInterval, _ handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate: CFAbsoluteTime = delay + CFAbsoluteTimeGetCurrent()
        let timer: CFRunLoopTimer? = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

}
