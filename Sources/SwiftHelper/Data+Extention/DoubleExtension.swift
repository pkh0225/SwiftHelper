//
//  DoubleExtension.swift
//  WiggleSDK
//
//  Created by mykim on 2018. 9. 14..
//  Copyright © 2018년 mykim. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toString: String { return String(self) }

    public func dateToString(_ format: String) -> String {
        let date: Date = Date(timeIntervalSince1970: self)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        return formatter.string(from: date)
    }

    @inline(__always) public func decimalCut(_ count: Int = 3) -> Double {
        guard count > 0 else { return self }
        let point: Double = pow(10.0, Double(count))
        return Double(Int(self * point)) / point
    }
}
