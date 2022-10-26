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
    public class func schedule(repeatInterval: TimeInterval, _ handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate = CFAbsoluteTimeGetCurrent() + repeatInterval
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, repeatInterval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

    ///   Run function after x seconds
    public class func schedule(delay: TimeInterval, _ handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

}
