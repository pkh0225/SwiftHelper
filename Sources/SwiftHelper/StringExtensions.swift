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

public var cacheLocalizedNibs = NSCache<NSString, Bundle>()

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

extension Character {
    public func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars

        return scalars[scalars.startIndex].value
    }

}

extension String {
    public var isValid: Bool {
        if self.isEmpty || self.count == 0 || self.trim().count == 0 || self == "(null)" || self == "null" || self == "nil" {
            return false
        }

        return true
    }

    public var isNormalURL: Bool {
        if self.hasPrefix("http") || self.hasPrefix("https") || self.hasPrefix("about:blank") {
            return true
        }

        return false
    }

    public var isSsgURL: Bool {
        let isSSGPage: Bool = URL(urlString: self)?.host?.contains(".ssg.com") ?? false

        return isSSGPage
    }

    public func trim() -> String {
        let str: String = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return str
    }

    public func height(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        return self.size(maxWidth: maxWidth, font: font).height
    }

    public func width(maxHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintSize: CGSize = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceilUI(boundingBox.width)
    }

    public func size(maxWidth: CGFloat, font: UIFont) -> CGSize {
        let constraintSize: CGSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceilUI(boundingBox.width), height: ceilUI(boundingBox.height))
    }

    public func size(maxSize: CGSize, font: UIFont) -> CGSize {
        let constraintSize: CGSize = maxSize
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceilUI(boundingBox.width), height: ceilUI(boundingBox.height))
    }

    public func size(_ font: UIFont) -> CGSize {
        let constraintSize: CGSize = CGSize(width: .greatestFiniteMagnitude, height: font.xHeight)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceilUI(boundingBox.width), height: ceilUI(boundingBox.height))
    }

    public func width(_ font: UIFont) -> CGFloat {
        return size(font).width
    }

    public func convertPriceFormat() -> String {
        guard self.isValid else {
            return ""
        }

        guard let value = Double(self) else { return self }

        let price: NSNumber = NSNumber(floatLiteral: value)
        let formatter: NumberFormatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        if let result: String = formatter.string(from: price) {
            return result
        }
        return ""
    }

    public func generateCICode128BarcodeImage(scaleX x: CGFloat, scaleY y: CGFloat) -> UIImage? {
        let data: Data? = self.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform: CGAffineTransform = CGAffineTransform(scaleX: x, y: y)
            if let output: CIImage = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    public func isValidEmail() -> Bool {
        let regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTestPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTestPredicate.evaluate(with: self)
    }

    public func isVAlidPhoneNumber() -> Bool {
        let regex: String = "[235689][0-9]{6}([0-9]{3})?"
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }

//    public func isValidUrl() -> Bool {
//        let types: NSTextCheckingResult.CheckingType = [.link]
//        let detector = try? NSDataDetector(types: types.rawValue)
//        guard (detector != nil && self.count > 0) else { return false }
//        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) > 0 {
//            return true
//        }
//        return false
//    }

    @discardableResult
    public func isValidUrl() -> [NSTextCheckingResult] {
        do {
            let detector: NSDataDetector = try NSDataDetector(types: NSTextCheckingTypes((NSTextCheckingResult.CheckingType.link).rawValue))
            return detector.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        }
        catch let error {
            print("\(self) --> \(error.localizedDescription)")
            return []
        }
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
    public subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
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
//    public func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
//        if subString.isEmpty {
//            return -1
//        }
//        var searchOption: NSString.CompareOptions
//        if fromEnd {
//            searchOption = NSString.CompareOptions.anchored
//        }
//        else {
//            searchOption = NSString.CompareOptions.backwards
//        }
//        if caseInsensitive {
//            searchOption.insert(NSString.CompareOptions.caseInsensitive)
//        }
//        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
//            return self.distance(from: self.startIndex, to: range.lowerBound)
//        }
//        return -1
//    }

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
        }
        catch _ as NSError {
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

    public func contains(_ strings: [String]) -> Bool {
        for str: String in strings {
            let isExists: Bool = self.contains(str)
            if isExists {
                return true
            }
        }

        return false
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

    public func toInt64() -> Int64 {
        if let num = NumberFormatter().number(from: self) {
            return num.int64Value
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
        if trimmedString == "true" || trimmedString == "y" || trimmedString == "yes" || trimmedString == "1" {
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
        for i in 0...count {
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
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
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
    public mutating func urlDecode() {
        self = urlDecoded()
    }

    public var asterisk: String {
        get {
            let value = self
            var translate: String = ""
            for _ in value {
                translate.append("*")
            }

            return translate
        }
    }

    public func removeSpecialCharsFromString() -> String {
        let filter: Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(self.filter { filter.contains($0) })
    }
}

extension String {
    public func urlAddParameters(_ params: [String: String]) -> String {
        guard var components: URLComponents = URLComponents(string: self) else { return self }

        var queryItems: [URLQueryItem] = []

        if let items = components.queryItems {
            queryItems = items
        }

        let addItems = params.map { key, value -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }

        queryItems.append(contentsOf: addItems)
        components.queryItems = queryItems

        guard let newUrlString: String = components.url?.absoluteString else { return self }
        return newUrlString
    }

    public func urlFromQueryString() -> (host: String, path: String, queryItems: [String: String])? {
        guard let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return nil }
        guard let urlComponents = URLComponents(string: url), let host = urlComponents.host, let scheme = urlComponents.scheme else { return nil }
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

        return (host: scheme + "://" + host, path: urlComponents.path, queryItems: params)
    }

    public func pathFromQueryString() -> (path: String, queryItems: [String: String])? {
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
        return (path: urlComponents.path, queryItems: params)
    }

    public func objectFromQueryString() -> [String: String]? {
        guard let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return nil }
        guard let urlComponents = URLComponents(string: url) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        var params: [String: String] = Dictionary()
        for item: URLQueryItem in queryItems {
            if let value = item.value {
                let v = value.removingPercentEncoding
                if v?.contains("#") ?? false {
                    params[item.name] = v?.split("#").first
                }
                else {
                    params[item.name] = v
                }

            }
            else {
                params[item.name] = ""
            }
        }
        return params
    }

    public func makeUrlStringWith(_ filterParams: [String]) -> String {
        guard var components = URLComponents(string: self) else { return self }
        guard let urlParams = self.objectFromQueryString() else { return self }

        let params = urlParams.mapFilter { key, value -> (String, String)? in
            if filterParams.contains(key) {
                return nil
            }
            return (key, value)
        }

        components.queryItems = params.map { key, value -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }

        guard let newUrlString: String = components.url?.absoluteString else { return self }
        return newUrlString

    }
}

extension String {
    public func maximumText(_ count: Int) -> String {
        if self.count > count {
            return self.substring(from: 0, to: count - 1)
        }
        else {
            return self
        }
    }

    public func stringFromIndex(_ count: Int) -> String? {
        if self.count > count {
            return  self[(count - 1)...count]
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
        var retString = self

        retString = retString.replace("&nbsp;", " ")
        retString = retString.replace("&amp;", "&")
        retString = retString.replace("&gt;", ">")
        retString = retString.replace("&lt;", "<")
        retString = retString.replace("&quot;", "\"")
        retString = retString.replace("&lt;", "<")

        return retString
    }
    
    public func removeProtolAndQa() -> String {
        return self.replace("http://", "").replace("https://", "").replace("qa-", "").replace("stg-", "")
    }
}

extension String {
    public func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    public func strike() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }

    public func underLine() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }

    public func attributedString(_ font: UIFont, _ textColor: UIColor, _ lineSpace: CGFloat) -> NSAttributedString {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.lineSpacing = lineSpace

        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]

        let attributedText = NSAttributedString(string: self, attributes: attributes)
        return attributedText
    }

    public func mutableAttributedString(_ font: UIFont, _ textColor: UIColor, _ lineSpace: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.lineSpacing = lineSpace

        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]

        let attributedText = NSMutableAttributedString(string: self, attributes: attributes)
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
                    attrString.addAttributes([NSAttributedString.Key.font: font], range: range)
                }

                if let color = item.color {
                    attrString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
                }

                if let lineColor = item.lineColor {
                    attrString.addAttributes([NSAttributedString.Key.underlineColor: lineColor], range: range)
                }
            }
        }

        return attrString
    }

    public func expectedNumberOfLines(byWidth width: CGFloat, font: UIFont) -> Int {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let targetRect = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return Int(floor(targetRect.size.height / font.lineHeight))
    }

//    public func makeParams<T, K>(_ params: Dictionary<T, K>) -> String? {
    public func makeParams(_ params: [String: String]) -> String? {
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

    public func dateToString(_ format: String) -> String {
        let value = self.toDouble() / 1000.0

        let date = Date(timeIntervalSince1970: value)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        return formatter.string(from: date)
    }

    public func dateWithFormat(_ format: DateFormat) -> Date {
        let language = WG_CommonFunc.language()
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
        if self.count >= 8 {
            var str: String = ""
            if isNewLine {
                str = String(format: "%@/%@%@(%@)", self[4...6], self[6...8], "\n", self.getYoilWithDateString(self.dateWithFormat(DateFormat.DateFormatYYYYMMDD)))
            }
            else {
                str = String(format: "%@/%@%@(%@)", self[4...6], self[6...8], "", self.getYoilWithDateString(self.dateWithFormat(DateFormat.DateFormatYYYYMMDD)))
            }
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

    public func getDateInfoString() -> String {
        if self.count > 7 {
            let retString = String(format: "%@%@%@%@%@%@", self[0...3], "년 ", self[4...5], "월 ", self[6...7], "일 ")
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

    public mutating func deleteCharactersInRange(_ nsRange: NSRange) {
        self.removeSubrange(self.index(self.startIndex, offsetBy: nsRange.location)...self.index(self.startIndex, offsetBy: nsRange.length) )
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

    public func nsRangeOfStringIgnoreUpper(_ matchString: String) -> NSRange {
        let selfRowString = self.lowercased()
        let matchRowString = matchString.lowercased()

        if let range: Range<String.Index> = selfRowString.range(of: matchRowString.lowercased()) {
            return NSRange(range, in: selfRowString)
        }
        return NSRange(location: NSNotFound, length: 0)
    }

    public func colorOfKeyword(_ keyword: String, _ keywordColor: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range: NSRange = self.nsRangeOfString(keyword)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: keywordColor, range: range)
        }
        return attributedString
    }

    public func colorOfkeywordIgnoreUpper(_ keyword: String, _ keywordColor: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range: NSRange = self.nsRangeOfStringIgnoreUpper(keyword)
        if range.location != NSNotFound && self.count >= (range.location + range.length) {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: keywordColor, range: range)
        }
        return attributedString
    }

    public func convertHtml() -> NSAttributedString {
        guard let data = data(using: .unicode) else { return NSAttributedString() }
           do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
           }
           catch {
               return NSAttributedString()
           }
       }

    public func tempRemoveDevStr() -> String {
        let retStr: String = self.replacingOccurrences(of: "dev-", with: "")
        let result: String = retStr.replacingOccurrences(of: "qa-", with: "")
        return result
    }

    public func substring(from: Int, to: Int) -> String {
        return self[from..<to]
    }

    public func substring(from: Int) -> String {
        return self[from..<self.count]
    }

    public func substring(to: Int) -> String {
        return self[0..<to]
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
            if uppercaseKey == "DOMAIN" {
                var prefixValue = value
                if !prefixValue.hasPrefix(".") && !prefixValue.hasPrefix("www") {
                    prefixValue = ".\(prefixValue)"
                }
                cookieProperties[HTTPCookiePropertyKey.domain] = prefixValue
            }
            else if uppercaseKey == "VERSION" {
                cookieProperties[HTTPCookiePropertyKey.version] = value
            }
            else if (uppercaseKey == "MAX-AGE") || (uppercaseKey == "MAXAGE") {
                cookieProperties[HTTPCookiePropertyKey.maximumAge] = value
            }
            else if uppercaseKey == "PATH" {
                cookieProperties[HTTPCookiePropertyKey.path] = value
            }
            else if uppercaseKey == "ORIGINURL" {
                cookieProperties[HTTPCookiePropertyKey.originURL] = value
            }
            else if uppercaseKey == "PORT" {
                cookieProperties[HTTPCookiePropertyKey.port] = value
            }
            else if (uppercaseKey == "SECURE") || (uppercaseKey == "ISSECURE") {
                cookieProperties[HTTPCookiePropertyKey.secure] = value
            }
            else if uppercaseKey == "COMMENT" {
                cookieProperties[HTTPCookiePropertyKey.comment] = value
            }
            else if uppercaseKey == "COMMENTURL" {
                cookieProperties[HTTPCookiePropertyKey.commentURL] = value
            }
            else if uppercaseKey == "EXPIRES" {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
                dateFormatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm:ss zzz"
                cookieProperties[HTTPCookiePropertyKey.expires] = dateFormatter.date(from: value)
            }
            else if uppercaseKey == "DISCART" {
                cookieProperties[HTTPCookiePropertyKey.discard] = value
            }
            else if uppercaseKey == "NAME" {
                cookieProperties[HTTPCookiePropertyKey.name] = value
            }
            else if uppercaseKey == "VALUE" {
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
    public func toDictionary() -> [String: Any]? {
        let convString = replacingOccurrences(of: "\r\n", with: "\\n")
        if let data = convString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch {
                print("\(self) --> \(error.localizedDescription)")
            }
        }
        return nil
    }
}

extension NSAttributedString {
    public func height(maxWidth: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceilUI(boundingBox.height)
    }

    public func width(maxHeight: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceilUI(boundingBox.width)
    }

    // width, Height 입력 받아 line 갯수 찾기
    public func numberOfLines(width: CGFloat, maxHeight: CGFloat) -> Int {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(maxHeight)))
        let frameSetterRef: CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)

        let linesNS: NSArray  = CTFrameGetLines(frameRef)

        guard let lines = linesNS as? [CTLine] else { return 0 }
        return lines.count
    }
}

extension String {
    public var lastPathComponent: String {
        get {
            //  URL lastPathComponent는 url주소의 path의 마지막 값이 나옴.. 파라미처까지 계산을 못함..
//            if let url = URL(urlString: self) {
//                return url.lastPathComponent
//            }
            return (self as NSString).lastPathComponent
        }
    }
    public var pathExtension: String {
        get {
//            if let url = URL(urlString: self) {
//                return url.pathExtension
//            }
            return (self as NSString).pathExtension
        }
    }
    public var stringByDeletingLastPathComponent: String {
        get {
//            if let url = URL(urlString: self) {
//                return url.deletingLastPathComponent().absoluteString
//            }
            return (self as NSString).deletingLastPathComponent
        }
    }
    public var stringByDeletingPathExtension: String {
        get {
//            if let url = URL(urlString: self) {
//                return url.deletingPathExtension().absoluteString
//            }
            return (self as NSString).deletingPathExtension
        }
    }
    public var pathComponents: [String] {
        get {
//            if let url = URL(urlString: self) {
//                return url.pathComponents
//            }
            return (self as NSString).pathComponents
        }
    }
    public func stringByAppendingPathComponent(path: String) -> String {
//        if let url = URL(urlString: self) {
//            return url.appendingPathComponent(path).absoluteString
//        }
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }

    public func stringByAppendingPathExtension(ext: String) -> String? {
//        if let url = URL(urlString: self) {
//            return url.appendingPathExtension(ext).absoluteString
//        }
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}

extension String {
    public mutating func insert(_ string: String, index: Int) {
        guard string.isValid else { return }
        self.insert(contentsOf: string, at: self.index(string.startIndex, offsetBy: index) )
    }
}

extension Optional where Wrapped == String {
    public var isValid: Bool {
        return self?.isValid ?? false
    }
}

extension String {
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    public func utf8DecodedString() -> String {
         let data = self.data(using: .utf8)
         let message = String(data: data!, encoding: .nonLossyASCII)
        return message ?? ""

    }

    public func utf8EncodedString() -> String {
         let messageData = self.data(using: .nonLossyASCII)
         let text = String(data: messageData!, encoding: .utf8)
         return text ?? ""
    }
}

extension String {
    public func sortForIndex(_ comp: String) -> ComparisonResult {
        /*
         기본 localizedCaseInsensitiveCompare는 숫자, 영문(대소무시), 한글 순 정렬
         한글 > 영문(대소구분 없음) > 숫자 > $
         그외 특수문자는 전부 무시한채 인덱싱
         $는 예외
        
         self 가 @"ㄱ" 보다 작고 (한글이 아니고) , comp 가 @"ㄱ"보다 같거나 클때 - 무조건 크다
         비교하면 -1 0 1 이 작다, 같다, 크다 순이므로 +1 을 하면 한글일때 YES 아니면 NO 가 된다.
         self 가 한글이고 comp 가 한글이 아닐때 무조건 작다인 조건과
         self 가 글자(한/영)이 아니고 comp가 글자(한/영)일떄 무조건 크다인 조건을 반영한다.
        **/

//        let left = "\(obj1.localizedCaseInsensitiveCompare("ㄱ").rawValue + 1 != 0 ? "0" : (obj1.localizedCaseInsensitiveCompare("a").rawValue + 1) == 0 ? "2" : "1")\(obj1)"
//        let right = "\(obj2.localizedCaseInsensitiveCompare("ㄱ").rawValue + 1 != 0 ? "0" : (obj2.localizedCaseInsensitiveCompare("a").rawValue + 1) == 0 ? "2" : "1")\(obj2)"
//        let comparisonResult = left.localizedCaseInsensitiveCompare(right)

        let shan = self.localizedCaseInsensitiveCompare("ㄱ").rawValue + 1
        let seng = self.localizedCaseInsensitiveCompare("a").rawValue + 1
//        var left = "\(shan != 0 ? "0" : seng == 0 ? "2" : "1")\(self)"
        var left = ""
        if shan != 0 {
            left = "0\(self)"
        }
        else if seng == 0 {
            left = "2\(self)"
        }
        else {
            left = "1\(self)"
        }

        let chan = comp.localizedCaseInsensitiveCompare("ㄱ").rawValue + 1
        let ceng = comp.localizedCaseInsensitiveCompare("a").rawValue + 1
//        var right = "\(chan != 0 ? "0" : ceng == 0 ? "2" : "1")\(comp)"
        var right = ""
        if chan != 0 {
            right = "0\(comp)"
        }
        else if ceng == 0 {
            right = "2\(comp)"
        }
        else {
            right = "1\(comp)"
        }
        return left.localizedCaseInsensitiveCompare(right)
    }

}

extension String {
    /*
     en : 영어
     ko : 한국어
     zh-Hant : 중국어 번체
     */
    public func localized(language: String = "ko", tableName: String = "Localizable", comment: String = "") -> String {
        let key = "\(language)_\(tableName)"

        if let bundle = cacheLocalizedNibs.object(forKey: key as NSString) {
            return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: comment)
        }
        else {
            if let path = Bundle.main.path(forResource: language, ofType: "lproj"), let bundle = Bundle(path: path) {
//                cacheLocalizedNibs.countLimit = 50
                cacheLocalizedNibs.setObject(bundle, forKey: key as NSString)
                return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: comment)
            }
            else {
                return self
            }
        }
    }

//    func localized(bundle: Bundle = .main, tableName: String = "Localizable", comment: String = "") -> String {
//         return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: comment)
//    }
}

public func swizzleReplacingCharacters() {
    let originalMethod = class_getInstanceMethod(
        NSString.self, #selector(NSString.replacingCharacters(in:with:)))

    let swizzledMethod = class_getInstanceMethod(
        NSString.self, #selector(NSString.swizzledReplacingCharacters(in:with:)))

    guard let original = originalMethod, let swizzled = swizzledMethod else {
        return
    }

    method_exchangeImplementations(original, swizzled)
}

// https://openradar.appspot.com/7428013
// https://console.firebase.google.com/project/ssgswift-456fc/crashlytics/app/ios:com.emart.ssg/issues/0acb9f63a605fee5ff024f87ec773c7d?time=last-seven-days&sessionId=
extension NSString {
    @objc public func swizzledReplacingCharacters(in range: NSRange, with replacement: String) -> String {
        /// By simply calling the original method the nil argument is handled. :shrug: :ok:
        ///
        /// (yes, we will call the original method and not ourselves even though it looks like it,
        /// because the methods have been swapped.)
        return self.swizzledReplacingCharacters(in: range, with: replacement)
    }
}

extension String {
    public var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            let attr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attr
        }
        catch {
            return NSMutableAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
