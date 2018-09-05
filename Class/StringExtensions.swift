//
//  StringExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//
// swiftlint:disable line_length

#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS)
    import UIKit
#endif


public class ColorChangeTextItem {

    public var text: String = ""
    public var font: UIFont?
    public var color: UIColor?
    public var lineColor: UIColor?
    
    public init() {}
    
    public init(text: String, font: UIFont? = nil, color: UIColor? = nil, lineColor: UIColor? = nil) {
        self.text = text
        self.font = font
        self.color = color
        self.lineColor = lineColor
    }
}

extension Character
{
    public func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }

}

extension String {
    
    public func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    public var isValid: Bool {
        if self.isEmpty || self.length == 0 || self.trim().length == 0 || self == "(null)" || self == "null" {
            return false
        }
        
        return true
    }
    
    public func trim() -> String {
        let seperator = CharacterSet(charactersIn: " \t\r\n\\f")
        let str = self.trimmingCharacters(in: seperator)
        return str
    }

    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let size = self.textSize(width, font)
        return ceil(size.height)
    }
    
    public func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    public func textSize(_ width: CGFloat, _ font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    public func size(_ font: UIFont) -> CGSize {
        let result = self.size(withAttributes: [NSAttributedStringKey.font: font])
        return CGSize(width: ceil(result.width), height: ceil(result.height))
    }
    
    public func width(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: font.xHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    public func convertPriceFormat() -> String {
        guard self.count > 0 else {
            return ""
        }
        
        guard let value = Double(self) else { return self }
        
        let price = NSNumber(floatLiteral: value)
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(from: price)!
    }
    
    public func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTestPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTestPredicate.evaluate(with: self)
    }
    
    public func isVAlidPhoneNumber() -> Bool {
        let regex = "[235689][0-9]{6}([0-9]{3})?"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }

    public func isValidUrl() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && self.count > 0) else { return false }
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) > 0 {
            return true
        }
        return false
    }
    
    public func isKorString() -> Bool {
        for i in 0..<self.count {
            let code = self[i].unicodeScalarCodePoint()
            if code >= 44032 && code <= 55203 {
                return true
            }
        }
        return false
    }
    
    ///   Cut string from integerIndex to the end
    public subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    ///   Cut string from range
    public subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }
    
    ///   Cut string from closedrange
    public subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
    }
    
    ///   Character count
    public var length: Int {
        return self.count
    }
    
    ///   Counts number of instances of the input inside String
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    ///   Capitalizes first character of String
    public mutating func capitalizeFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
    
    ///   Capitalizes first character of String, returns a new string
    public func capitalizedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    ///   Uppercases first 'count' self of String
//    public mutating func uppercasePrefix(_ count: Int) {
//        guard self.count > 0 && count > 0 else { return }
//        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
//                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
//    }
    
    ///   Uppercases first 'count' characters of String, returns a new string
//    public func uppercasedPrefix(_ count: Int) -> String {
//        guard self.count > 0 && count > 0 else { return self }
//        var result = self
//        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
//                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
//        return result
//    }
    
    ///   Uppercases last 'count' characters of String
//    public mutating func uppercaseSuffix(_ count: Int) {
//        guard self.count > 0 && count > 0 else { return }
//        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
//                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
//    }
    
    ///   Uppercases last 'count' characters of String, returns a new string
//    public func uppercasedSuffix(_ count: Int) -> String {
//        guard self.count > 0 && count > 0 else { return self }
//        var result = self
//        result.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
//                               with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
//        return result
//    }
    
    ///   Uppercases string in range 'range' (from range.startIndex to range.endIndex)
//    public mutating func uppercase(range: CountableRange<Int>) {
//        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
//        guard self.count > 0 && (0..<length).contains(from) else { return }
//        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
//                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
//    }
    
    ///   Uppercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
//    public func uppercased(range: CountableRange<Int>) -> String {
//        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
//        guard self.count > 0 && (0..<length).contains(from) else { return self }
//        var result = self
//        result.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
//                               with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
//        return result
//    }
    
    ///   Lowercases first character of String
    public mutating func lowercaseFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
    }
    
    ///   Lowercases first character of String, returns a new string
    public func lowercasedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
    
    ///   Lowercases first 'count' self of String
//    public mutating func lowercasePrefix(_ count: Int) {
//        guard self.count > 0 && count > 0 else { return }
//        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
//                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
//    }
    
    ///   Lowercases first 'count' self of String, returns a new string
//    public func lowercasedPrefix(_ count: Int) -> String {
//        guard self.count > 0 && count > 0 else { return self }
//        var result = self
//        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
//                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
//        return result
//    }
    
    ///   Lowercases last 'count' self of String
//    public mutating func lowercaseSuffix(_ count: Int) {
//        guard self.count > 0 && count > 0 else { return }
//        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
//                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
//    }
    
    ///   Lowercases last 'count' self of String, returns a new string
//    public func lowercasedSuffix(_ count: Int) -> String {
//        guard self.count > 0 && count > 0 else { return self }
//        var result = self
//        result.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
//                               with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
//        return result
//    }
    
    ///   Lowercases string in range 'range' (from range.startIndex to range.endIndex)
//    public mutating func lowercase(range: CountableRange<Int>) {
//        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
//        guard self.count > 0 && (0..<length).contains(from) else { return }
//        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
//                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
//    }
    
    ///   Lowercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
//    public func lowercased(range: CountableRange<Int>) -> String {
//        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
//        guard self.count > 0 && (0..<length).contains(from) else { return self }
//        var result = self
//        result.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
//                               with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
//        return result
//    }
    
    ///   Checks if string is empty or consists only of whitespace and newline self
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    ///   Trims white space and new line characters
    public mutating func trimed() {
        self = self.trimmed()
    }
    
    ///   Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    ///   Position of begining character of substing
    public func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
        if subString.isEmpty {
            return -1
        }
        var searchOption = fromEnd ? NSString.CompareOptions.anchored : NSString.CompareOptions.backwards
        if caseInsensitive {
            searchOption.insert(NSString.CompareOptions.caseInsensitive)
        }
        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    ///   split string using a spearator string, returns an array of string
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    ///   split string with delimiters, returns an array of string
    public func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    ///   Returns if String is a number
    public func isNumber() -> Bool {
        if NumberFormatter().number(from: self) != nil {
            return true
        }
        return false
    }
    
    ///   Extracts URLS from String
    public var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }
        
        let text = self
        
        if let detector = detector {
            detector.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), using: {(result: NSTextCheckingResult?, _, _) -> Void in
                if let result = result, let url = result.url {
                    urls.append(url)
                }
            })
        }
        
        return urls
    }
    
    ///   Checking if String contains input with comparing options
    public func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }
    
    ///   Converts String to Int
    public func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        }
        else {
            return 0
        }
    }
    
    ///   Converts String to Double
    public func toDouble() -> Double {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        }
        else {
            return 0
        }
    }
    
    ///   Converts String to Float
    public func toFloat() -> Float {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        }
        else {
            return 0
        }
    }
    
    ///   Converts String to CGFloat
    public func toCGFloat() -> CGFloat {
        if let num = NumberFormatter().number(from: self) {
            return CGFloat(num.floatValue)
        }
        else {
            return 0
        }
    }
    
    ///   Converts String to Bool
    public func toBool() -> Bool {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "Y" || trimmedString == "y" || trimmedString == "True" {
            return true
        }
        else {
            return false
        }
    }
    
    ///  Returns the first index of the occurency of the character in String
    public func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in self.enumerated() where c == char {
            return index
        }
        return nil
    }

    ///   Checks if String contains Emoji
    public func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    #if os(iOS)
    
    ///   copy string to pasteboard
    public func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    
    #endif
    
    
//        URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
//        URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
//        URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
//        URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
//        URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
//        URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
//   URL encode a string (percent encoding special chars)
    public func urlQueryEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    //   URL encode a string (percent encoding special chars) mutating version
    mutating func urlEncode() {
        self = urlEncoded()
    }
    
    //   Removes percent encoding from string
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    
    // EZSE : Mutating versin of urlDecoded
    mutating func urlDecode() {
        self = urlDecoded()
    }
}

extension String {
    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
    
    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
}

extension String {
    
    public func urlAddParameters(_ params: [String: String]) -> String {
        guard var components = URLComponents(string: self) else { return self}
        
        components.queryItems = params.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let newUrlString: String = components.url?.absoluteString else { return self}
        return newUrlString
    }
    
    public func objectFromQueryString() -> Dictionary<String, String>? {
        guard let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return nil }
        guard let urlComponents = URLComponents(string: url) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        var params: [String: String] = Dictionary()
        for item: URLQueryItem in queryItems {
            if let value = item.value {
                params[item.name] = value.removingPercentEncoding
            }
            else {
                params[item.name] = ""
            }
        }
        return params
    }
    
    public func makeUrlStringWith(_ filterParams: [String]) -> String {
        guard var components = URLComponents(string: self) else { return self}
        guard let urlParams = self.objectFromQueryString() else { return self }
        
        let params = urlParams.mapFilter { (key, value) -> (String, String)? in
            if filterParams.contains(key) {
                return nil
            }
            return (key, value)
        }
        
        components.queryItems = params.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let newUrlString: String = components.url?.absoluteString else { return self}
        return newUrlString
        
    }
}

extension String {
    public func maximumText(_ count: Int) -> String {
        if self.length > count {
            return self.substring(from: 0, to: count - 1)
        }
        else {
            return self
        }
    }
    
    public func stringFromIndex(_ count: Int) -> String? {
        
        if self.length > count {
            return  self[(count-1)...count]
        }
        else {
            return nil
        }
    }

}

extension String {
    public func replace(_ of: String, _ with: String) -> String {
        return self.replacingOccurrences(of: of, with: with, options: .literal, range: nil)
    }
    
    public func replaceFilterWithString() -> String {
        return self.replace("&amp;", "&")
    }
}

extension String {
    
    public func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    public func strike() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
    
    public func attributedString(_ font: UIFont, _ textColor: UIColor, _ lineSpace: CGFloat) -> NSAttributedString {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.lineSpacing = lineSpace
        
        let attributes = [NSAttributedStringKey.font:font,
                          NSAttributedStringKey.foregroundColor:textColor,
                          NSAttributedStringKey.paragraphStyle:paragraphStyle]
        
        let attributedText = NSAttributedString(string: self, attributes: attributes)
        return attributedText
    }
    
    public func colorFontChangeSourceText(_ replaceText: [ColorChangeTextItem]) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: self)
        
        if replaceText.isEmpty {
            return attrString
        }
        
        for item in replaceText {
            
            guard item.text.isValid else {
                continue
            }
            
            if let textRange: Range = self.range(of: item.text) {
                let range = self.nsRange(from: textRange)
                
                if let font = item.font {
                    attrString.addAttributes([NSAttributedStringKey.font:font], range: range)
                }
                
                if let color = item.color {
                    attrString.addAttributes([NSAttributedStringKey.foregroundColor:color], range: range)
                }
                
                if let lineColor = item.lineColor {
                    attrString.addAttributes([NSAttributedStringKey.underlineColor:lineColor], range: range)
                }
            }
        }
        
        return attrString
    }
    
//    public func makeParams<T, K>(_ params: Dictionary<T, K>) -> String? {
    public func makeParams(_ params: Dictionary<String, String>) -> String? {

        var string = self
        var index = 0
        for (key, value) in params {
            if index == 0 {
                string += "?"
            }
            else {
                string += "&"
            }
            
            string = string.appendingFormat("%@=%@", key, value)
            index += 1
        }
        
        return string
    }
    
    public func dateWithFormat(_ format: DateFormat) -> Date {
        
        let language = CommonFunc.language()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language)
        formatter.dateFormat = Date().dateFormat(format)
        
        if let dateString = formatter.date(from: self) {
            return dateString
        }
        else {
            return Date()
        }
    }
    
    public func getYoilWithDateString(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let weekDayComponents = calendar.component(.weekday, from: date)
        
        switch weekDayComponents {
        case 1: return "일"
        case 2: return "월"
        case 3: return "화"
        case 4: return "수"
        case 5: return "목"
        case 6: return "금"
        case 7: return "토"
        default: return ""
        }
    }
    
    public func getCapaDateWithDateString(_ isNewLine: Bool) -> String {
        
        if self.length >= 8 {
            let str = String(format: "%@/%@%@(%@)", self[4...6], self[6...8], isNewLine ? "\n" : "", self.getYoilWithDateString(self.dateWithFormat(DateFormat.DateFormatYYYYMMDD)))
            
            return str
        }
        else {
             return self
        }
    }
    
    public func getDateString(_ splitStr: String) -> String {
        if self.count > 7 {
            let retString = String(format: "%@%@%@%@%@", self[0...3], splitStr, self[4...5], splitStr, self[6...7])
            return retString
        }
        else {
            return ""
        }
    }
    
    public func deleteMatch(_ matchString: String) -> String {
        var sourceString = self
        
        guard sourceString.isValid else {
            return sourceString
        }
        
        if let range = rangeOfString(matchString) {
            sourceString.removeSubrange(range)
        }
        
        return sourceString
    }
    
    public func deleteMatchStrings(_ matchStrings: [String]) -> String {
        var sourceString = self
        
        guard matchStrings.count > 0 else {
            return sourceString
        }
        
        for str in matchStrings {
            sourceString = sourceString.deleteMatch(str)
        }
        
        return sourceString
    }
}

extension String {
    public func rangeOfString(_ matchString: String) -> Range<String.Index>? {
        if let range: Range<String.Index> = self.range(of: matchString) {
//            let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
          return range
        }
        
        return nil
    }
    
    public func nsRangeOfString(_ matchString: String) -> NSRange {
        if let range: Range<String.Index> = self.range(of: matchString) {
            return nsRange(from: range)
        }
        return NSRange(location: NSNotFound, length: 0)
    }
    
    public func colorOfKeyword(_ keyword: String, _ keywordColor: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range: NSRange = self.nsRangeOfString(keyword)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: keywordColor, range: range)
        }
        return attributedString
    }
    
    public func tempRemoveDevStr() -> String {
        let retStr: String = self.replacingOccurrences(of: "dev-", with: "")
        let result: String = retStr.replacingOccurrences(of: "qa-", with: "")
        return result
    }
    
    public func substring(from: Int, to: Int) -> String {
        return self[from..<to]
    }
}

///   Pattern matching of strings via defined functions
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}

///   Can be used in switch-case
public func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {

    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

///   Can be used in switch-case
public func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}


// cookie
extension String {

    public func cookieMap() -> [String: Any] {
        var cookieMap: [String: Any]!
        let cookieKeyValueStrings = components(separatedBy: ";")
        for cookieKeyValueString: String in cookieKeyValueStrings {
            let separatorRange: NSRange = cookieKeyValueString.nsRangeOfString("=")
            if separatorRange.location != NSNotFound && separatorRange.location > 0 && separatorRange.location < (cookieKeyValueString.count - 1) {
                var key: String = cookieKeyValueString.substring(from: 0, to: separatorRange.location)
                var value: String = cookieKeyValueString.substring(from: separatorRange.location, to: separatorRange.location)
                key = key.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                cookieMap[key] = value
            }
        }
        return cookieMap
    }
    
    public func cookieProperties() -> [HTTPCookiePropertyKey: Any] {
        let cookieMap = self.cookieMap()
        var cookieProperties: [HTTPCookiePropertyKey: Any] = Dictionary()
        for key: String in cookieMap.keys {
            guard let value = cookieMap[key] as? String else { continue }
            let uppercaseKey: String = key.uppercased()
            if (uppercaseKey == "DOMAIN") {
                var prefixValue = value
                if !prefixValue.hasPrefix(".") && !prefixValue.hasPrefix("www") {
                    prefixValue = ".\(prefixValue)"
                }
                cookieProperties[HTTPCookiePropertyKey.domain] = prefixValue
            }
            else if (uppercaseKey == "VERSION") {
                cookieProperties[HTTPCookiePropertyKey.version] = value
            }
            else if (uppercaseKey == "MAX-AGE") || (uppercaseKey == "MAXAGE") {
                cookieProperties[HTTPCookiePropertyKey.maximumAge] = value
            }
            else if (uppercaseKey == "PATH") {
                cookieProperties[HTTPCookiePropertyKey.path] = value
            }
            else if (uppercaseKey == "ORIGINURL") {
                cookieProperties[HTTPCookiePropertyKey.originURL] = value
            }
            else if (uppercaseKey == "PORT") {
                cookieProperties[HTTPCookiePropertyKey.port] = value
            }
            else if (uppercaseKey == "SECURE") || (uppercaseKey == "ISSECURE") {
                cookieProperties[HTTPCookiePropertyKey.secure] = value
            }
            else if (uppercaseKey == "COMMENT") {
                cookieProperties[HTTPCookiePropertyKey.comment] = value
            }
            else if (uppercaseKey == "COMMENTURL") {
                cookieProperties[HTTPCookiePropertyKey.commentURL] = value
            }
            else if (uppercaseKey == "EXPIRES") {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
                dateFormatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm:ss zzz"
                cookieProperties[HTTPCookiePropertyKey.expires] = dateFormatter.date(from: value)
            }
            else if (uppercaseKey == "DISCART") {
                cookieProperties[HTTPCookiePropertyKey.discard] = value
            }
            else if (uppercaseKey == "NAME") {
                cookieProperties[HTTPCookiePropertyKey.name] = value
            }
            else if (uppercaseKey == "VALUE") {
                cookieProperties[HTTPCookiePropertyKey.value] = value
            }
            else {
                cookieProperties[HTTPCookiePropertyKey.name] = key
                cookieProperties[HTTPCookiePropertyKey.value] = value
            }
        }
        if cookieProperties[HTTPCookiePropertyKey.path] == nil {
            cookieProperties[HTTPCookiePropertyKey.path] = "/"
        }
        return cookieProperties
    }
    

    public func cookie() -> HTTPCookie {
        let cookieProperties = self.cookieProperties()
        let cookie = HTTPCookie(properties: cookieProperties)
        return cookie!
    }
    
}

extension String {
    public func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension NSAttributedString {
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}
