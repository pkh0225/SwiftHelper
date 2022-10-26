//
//  LocaleExtensions.swift
//  WiggleSDK
//
//  Created by iSunSoo on 2018. 8. 29..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation

extension Locale {
    /*
     *  @ params:   Int value of weekday
     *  @ returns:  "mon"..."sun" or "월"..."일" 중 해당 요일
     *  @ desc:     day(요일)의 Integer 값을 넘기면 해당 Locale에 맞는 String을 가져온다.
     *  @ author:   by iSunSoo
     */
    public func dayName(dayIndex: Int?) -> String? {
        guard let dayIndex = dayIndex else { return nil }
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = self
        return dateFormatter.shortWeekdaySymbols[dayIndex].lowercased()
    }
}
