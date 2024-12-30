//
//  DateExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import Foundation

// 날짜 유틸리티
public enum DateFormat: Int {
    case DateFormatYYYYMMDD = 0,                   //  19780102
    DateFormatYYYYMMDDWithDash,                    //  1978-01-02
    DateFormatYYYYMMDDWithDot,                     //  1978.01.02
    DateFormatYYYYMMDDHH24MIWithDash,              //  1978-01-02 23:59
    DateFormatYYYYMMDDHH24MIWithDot,               //  1978.01.02 23:59
    DateFormatYYYYMMDDHH24MISS,                    //  19780102235959
    DateFormatYYYYMMDDhhMISS,                      //  19780102115959
    DateFormatYYYYMMDDHH24,                        //  1978010223
    DateFormatYYYYMMDDHH24MISSWithDash,            //  1978-01-02 23:59:59
    DateFormatYYYYMMDDHH24MISSWithDot,             //  1978.01.02 23:59:59
    DateFormatAMPM,                                //  AM/PM
    DateFormatDD,                                  //  DD 02
    DateFormatMMDDWithDash,                        //  10-30
    DateFormatMMDDWithDot,                         //  10.30
    DateFormatMMDDWithSlash,                       //  10/30
    DateFormatHH24MISSDot,                         //  23:59:59
    DateFormatHH24MIDot,                           //  23:59
    DateFormathhMIDot,                             //  11:59
    DateFormatAMPMhhMIDot,                         //  pm11:59
    DateFormatYYYYMMDDHH24MISSWithSlashAndDot,     //  2013/12/30 23:59
    DateFormatYYYYMMDDAMPMhhMISSWithSlashAndDot,   //  2013/12/30 pm 11:59
    DateFormatYYYYMMDDWithDotWithDay               //  2018.11.30(금)
}

extension Date {
    public static let minutesInAWeek = 24 * 60 * 7

    public func dateFormat(_ format: DateFormat) -> String {
        switch format {
        case .DateFormatMMDDWithDash:
            return "MM-dd"
        case .DateFormatMMDDWithDot:
            return "MM.dd"
        case .DateFormatMMDDWithSlash:
            return "MM/dd"
        case .DateFormatYYYYMMDD:
            return "yyyyMMdd"
        case .DateFormatYYYYMMDDWithDash:
            return "yyyy-MM-dd"
        case .DateFormatYYYYMMDDWithDot:
            return "yyyy.MM.dd"
        case .DateFormatYYYYMMDDHH24MIWithDash:
            return "yyyy-MM-dd HH:mm"
        case .DateFormatYYYYMMDDHH24MIWithDot:
            return "yyyy.MM.dd HH:mm"
        case .DateFormatYYYYMMDDHH24MISS:
            return "yyyyMMddHHmmss"
        case .DateFormatYYYYMMDDhhMISS:
            return "yyyyMMddhhmmss"
        case .DateFormatYYYYMMDDHH24:
            return "yyyyMMddHH"
        case .DateFormatYYYYMMDDHH24MISSWithDash:
            return "yyyy-MM-dd HH:mm:ss"
        case .DateFormatYYYYMMDDHH24MISSWithDot:
            return "yyyy.MM.dd HH:mm:ss"
        case .DateFormatAMPM:
            return "a"
        case .DateFormatDD:
            return "dd"
        case .DateFormatHH24MISSDot:
            return "HH:mm:ss"
        case .DateFormatHH24MIDot:
            return "HH:mm"
        case .DateFormatAMPMhhMIDot:
            return "a hh:mm"
        case .DateFormathhMIDot:
            return "hh:mm"
        case .DateFormatYYYYMMDDHH24MISSWithSlashAndDot:
            return "yyyy/MM/dd HH:mm"
        case .DateFormatYYYYMMDDAMPMhhMISSWithSlashAndDot:
            return "yyyy/MM/dd a hh:mm"
        case .DateFormatYYYYMMDDWithDotWithDay:
            return "yyyy.MM.dd(E)"
        }
    }

    public func dateStringWithFormat(_ format: DateFormat) -> String {
        return self.dateStringWithFormat(format, 0)
    }

    public static func language() -> String {
        let defaults: UserDefaults = UserDefaults.standard
        let appleLanguages: Any? = defaults.object(forKey: "AppleLanguages")
        guard let languages: [String] = appleLanguages as? [String] else {
            return ""
        }

        guard languages.count > 0 else {
            return ""
        }

        return languages[0]
    }

    public func dateStringWithFormat(_ format: DateFormat, _ days: Int) -> String {
        let language: String = Self.language()
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: language)
        formatter.dateFormat = self.dateFormat(format)

        let now: Date = self
        let dateString: String = formatter.string(from: now.addDays(days))
        return dateString
    }

    public func dateStringWithLocaleFormat(_ format: DateFormat, _ locale: Locale) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormat(format)
        formatter.locale = locale

        let dateString: String = formatter.string(from: self)
        return dateString

    }

    public func dateWithFormat(format: DateFormat) -> String {
        var formatter: DateFormatter?
        let language: String = Self.language()
        if formatter == nil {
            formatter = DateFormatter()
            formatter?.locale = NSLocale(localeIdentifier: language) as Locale
        }
        formatter?.dateFormat = self.dateFormat(format)
        let dateString: String = formatter?.string(from: self) ?? ""
        return dateString
    }

    ///   Initializes Date from string and format
    public init?(fromString string: String, format: String) {
        let formatter: DateFormatter = DateFormatter()
        let language: String = Self.language()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: language) as Locale
        if let date = formatter.date(from: string) {
            self = date
        }
        else {
            return nil
        }
    }

    ///   Initializes Date from string returned from an http response, according to several RFCs / ISO
    public init?(httpDateString: String) {
        if let rfc1123 = Date(fromString: httpDateString, format: "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz") {
            self = rfc1123
            return
        }
        if let rfc850 = Date(fromString: httpDateString, format: "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z") {
            self = rfc850
            return
        }
        if let asctime = Date(fromString: httpDateString, format: "EEE MMM d HH':'mm':'ss yyyy") {
            self = asctime
            return
        }
        if let iso8601DateOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd") {
            self = iso8601DateOnly
            return
        }
        if let iso8601DateHrMinOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mmxxxxx") {
            self = iso8601DateHrMinOnly
            return
        }
        if let iso8601DateHrMinSecOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            self = iso8601DateHrMinSecOnly
            return
        }
        if let iso8601DateHrMinSecMs = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx") {
            self = iso8601DateHrMinSecMs
            return
        }
        // self.init()
        return nil
    }

    ///   Converts Date to String
    public func toString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }

    ///   Converts Date to String, with format
    public func toString(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    ///   Calculates how many days passed from now to date
    public func daysInBetweenDate(_ date: Date) -> Double {
        var diff: Double = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / 86400)
        return diff
    }

    ///   Calculates how many hours passed from now to date
    public func hoursInBetweenDate(_ date: Date) -> Double {
        var diff: Double = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / 3600)
        return diff
    }

    ///   Calculates how many minutes passed from now to date
    public func minutesInBetweenDate(_ date: Date) -> Double {
        var diff: Double = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / 60)
        return diff
    }

    ///   Calculates how many seconds passed from now to date
    public func secondsInBetweenDate(_ date: Date) -> Double {
        var diff: Double = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }

    ///   Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
//    public func timePassed() -> String {
//        let date = Date()
//        let calendar = Calendar.current
//        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
//        var str: String
//        
//        if components.year! >= 1 {
//            components.year == 1 ? (str = "year") : (str = "years")
//            return "\(components.year!) \(str) ago"
//        }
//        else if components.month! >= 1 {
//            components.month == 1 ? (str = "month") : (str = "months")
//            return "\(components.month!) \(str) ago"
//        }
//        else if components.day! >= 1 {
//            components.day == 1 ? (str = "day") : (str = "days")
//            return "\(components.day!) \(str) ago"
//        }
//        else if components.hour! >= 1 {
//            components.hour == 1 ? (str = "hour") : (str = "hours")
//            return "\(components.hour!) \(str) ago"
//        }
//        else if components.minute! >= 1 {
//            components.minute == 1 ? (str = "minute") : (str = "minutes")
//            return "\(components.minute!) \(str) ago"
//        }
//        else if components.second! >= 1 {
//            components.second == 1 ? (str = "second") : (str = "seconds")
//            return "\(components.second!) \(str) ago"
//        }
//        else {
//            return "Just now"
//        }
//    }

    ///   Check if date is in future.
    public var isFuture: Bool {
        return self > Date()
    }

    ///   Check if date is in past.
    public var isPast: Bool {
        return self < Date()
    }

    //   Check date if it is today
    public var isToday: Bool {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: self) == format.string(from: Date())
    }

    ///   Check date if it is yesterday
    public var isYesterday: Bool {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let yesterDay: Date? = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return format.string(from: self) == format.string(from: yesterDay!)
    }

    ///   Check date if it is tomorrow
    public var isTomorrow: Bool {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let tomorrow: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        return format.string(from: self) == format.string(from: tomorrow!)
    }

    ///   Check date if it is within this month.
    public var isThisMonth: Bool {
        let today: Date = Date()
        return self.month == today.month && self.year == today.year
    }

    ///   Check date if it is within this week.
    public var isThisWeek: Bool {
        return self.minutesInBetweenDate(Date()) <= Double(Date.minutesInAWeek)
    }

    ///   Get the era from the date
    public var era: Int {
        return Calendar.current.component(Calendar.Component.era, from: self)
    }

    /// EZSE : Get the year from the date
    public var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }

    /// EZSE : Get the month from the date
    public var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }

    /// EZSE : Get the weekday from the date
    public var weekday: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }

    // EZSE : Get the month from the date
    public var monthAsString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }

    // EZSE : Get the day from the date
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    ///   Get the hours from date
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    ///   Get the minute from date
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    ///   Get the second from the date
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }

    /// EZSE : Gets the nano second from the date
    public var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }

    public var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }

    public func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        // Declare Variables
        var isGreater = false

        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        // Return Result
        return isGreater
    }

    public func isLessThanDate(_ dateToCompare: Date) -> Bool {
        // Declare Variables
        var isLess = false

        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }

        // Return Result
        return isLess
    }

    public func equalToDate(_ dateToCompare: Date) -> Bool {
        // Declare Variables
        var isEqualTo = false

        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        // Return Result
        return isEqualTo
    }

    public func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)

        // Return Result
        return dateWithDaysAdded
    }

    public func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)

        // Return Result
        return dateWithHoursAdded
    }

    #if os(iOS) || os(tvOS)

    /// EZSE : Gets the international standard(ISO8601) representation of date
    public var iso8601: String {
        let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }

    #endif

    public func dateNowCheck() -> Bool {
        let calendar: Calendar = Calendar.current
        let componentsForFirstDate: DateComponents? = calendar.dateComponents([.day, .month, .year], from: self)
        let componentsForSecondDate: DateComponents? = calendar.dateComponents([.day, .month, .year], from: Date())
        if componentsForFirstDate?.year == componentsForSecondDate?.year && componentsForFirstDate?.month == componentsForSecondDate?.month && componentsForFirstDate?.day == componentsForSecondDate?.day {
            return true
        }
        else {
            return false
        }
    }

    public func date(_ year: Int, _month: Int, _ day: Int) -> (Int?, Int?, Int?) {
        let calendar: Calendar = Calendar.current
        let components: DateComponents? = calendar.dateComponents([.day, .month, .year], from: self)
        let cDay: Int? = components?.day
        let cMonth: Int? = components?.month
        let cYear: Int? = components?.year

        return (cDay, cMonth, cYear)
    }

}
