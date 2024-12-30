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
}
