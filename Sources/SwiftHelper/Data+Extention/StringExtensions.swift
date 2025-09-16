//
//  StringExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//
// swiftlint:disable line_length

import UIKit

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

// MARK: - Check
extension String {
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    public var isValid: Bool {
        return !(self.isEmpty || self.trim().isEmpty || self == "(null)" || self == "null" || self == "nil")
    }

    public var isNormalURL: Bool {
        return self.hasPrefix("http") || self.hasPrefix("https") || self.hasPrefix("about:blank")
    }

    ///   Returns if String is a number
    public func isNumber() -> Bool {
        return NumberFormatter().number(from: self) != nil
    }

    public var isValidJsonStr: Bool {
        return self.trimmingCharacters(in: ["{", "}"]).isValid
    }

    /// isValid 검사를 해서 성공이면 자기 자신을 return하고 아니면 default 값을 return 한다.
    /// - Parameter value: default Value
    /// - Returns: isValid 검사를 해서 성공이면 자기 자신을 return하고 아니면 default 값을 return 한다.
    public func isValidOrDefault(_ value: String = "") -> String {
        return self.isValid ? self : value
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
}

// MARK: - convert
extension String {
    public func convertPriceFormat() -> String {
        guard self.isValid else { return "" }
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

    public func addWon(_ tildeDispYn: Bool = false) -> String {
        guard self.isValid else { return "" }
        if tildeDispYn {
            return self + "원~"
        }
        return self + "원"
    }
    public func generateCICode128BarcodeImage() -> UIImage? {
        let data: Data? = self.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let aImage = filter.outputImage {
                return UIImage(ciImage: aImage)
            }
        }
        return nil
    }

    public func generateCICode128BarcodeImageNew() -> Data? {
        return self.generateCICode128BarcodeImage()?.pngData()
    }
}

// MARK: - URL
extension String {
    //        URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
    //        URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
    //        URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
    //        URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
    //        URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
    //        URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
    //   URL encode a string (percent encoding special chars)
    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

    public func urlAllEncoded() -> String {
        let charSet = CharacterSet(charactersIn: "|!@#$%&*()+'\";:=,/?[] ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? self
    }

    //   Removes percent encoding from string
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }

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

    public func removeUrlString(with keys: [String]) -> String {
        guard var components: URLComponents = URLComponents(string: self) else { return self }
        var queryItems: [URLQueryItem] = []
        if let items = components.queryItems {
            queryItems = items
        }

        for key in keys {
            queryItems = queryItems.filter { $0.name != key }
        }
        components.queryItems = queryItems

        guard let newUrlString: String = components.url?.absoluteString else { return self }
        return newUrlString
    }

    public func removeParameters() -> String? {
        guard let url = URL(string: self) else {
            print("잘못된 URL 형식입니다.")
            return nil
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = nil  // 쿼리 파라미터 제거
        components?.fragment = nil  // 프래그먼트(#) 제거 (필요시)

        return components?.url?.absoluteString
    }
}

// MARK: - Range
extension String {
    public func substring(from: Int, to: Int) -> String {
        return self[from..<to]
    }

    public func substring(from: Int) -> String {
        return self[from..<self.count]
    }

    public func substring(to: Int) -> String {
        return self[0..<to]
    }
    ///   Cut string from closedrange
    public subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
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

    ///   Character count
    public var length: Int {
        return self.count
    }

    ///   Counts number of instances of the input inside String
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }

    ///   split string using a spearator string, returns an array of string
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trim().isEmpty
        }
    }

    ///   split string with delimiters, returns an array of string
    public func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trim().isEmpty
        }
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

    ///  Returns the first index of the occurency of the character in String
    public func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in self.enumerated() where c == char {
            return index
        }
        return nil
    }

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

        return retString
    }

    public func removeProtocol() -> String {
        return self.replace("http://", "").replace("https://", "").replace("qa-", "").replace("stg-", "")
    }

    public func removeLastSlash() -> String {
        guard self.last == "/" else { return self }
        var value = self
        value.removeLast()
        return value
    }
}

extension String {
    public func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    public func expectedNumberOfLines(byWidth width: CGFloat, font: UIFont) -> Int {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let targetRect = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return Int(floor(targetRect.size.height / font.lineHeight))
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
        let language = Date.language()
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
    public func nsRangeOfStringIgnoreUpper(_ matchString: String) -> NSRange {
        let selfRowString = self.lowercased()
        let matchRowString = matchString.lowercased()

        if let range: Range<String.Index> = selfRowString.range(of: matchRowString.lowercased()) {
            return NSRange(range, in: selfRowString)
        }
        return NSRange(location: NSNotFound, length: 0)
    }
}

// MARK: - Swift Collection(Dic, Array) Support
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

    public func toArray() -> [Any]? {
        let convString = replacingOccurrences(of: "\r\n", with: "\\n")
        if let data = convString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            }
            catch {
                print("\(self) --> \(error.localizedDescription)")
            }
        }
        return nil
    }
}

extension Optional where Wrapped == String {
    public var isValid: Bool {
        return self?.isValid ?? false
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
    public var decodingNewLine: String {
        return self.replacingOccurrences(of: "\\n", with: "\n")
    }
}

// MARK: - Converts
extension String {
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
            return CGFloat(num.doubleValue)
        }
        else {
            return 0
        }
    }

    ///   Converts String to Bool
    public func toBool() -> Bool {
        let trimmedString = trim().lowercased()
        return trimmedString == "true" || trimmedString == "y" || trimmedString == "yes" || trimmedString == "1"
    }
}

// MARK: - Size
extension String {
    /**
        - parameters:
            - maxwidth : 최대로 보여주고 싶은 Width의 값.
            - font : 문자열을 넣을 곳의 폰트
        - returns: 문자열의 실제 Rect의 높이
    */
    public func height(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintSize: CGSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle(withHangul: true)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return boundingBox.height
    }

    /**
        - parameters:
            - maxHeight : 최대로 보여주고 싶은 Rect의 높이. default 1줄이므로 0.
            - font : 문자열을 넣을 곳의 폰트
        - returns: 문자열의 실제 Rect의 길이
    */
    public func width(maxHeight: CGFloat = 0, font: UIFont) -> CGFloat {
        let constraintSize: CGSize = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        let paragraphStyle = NSMutableParagraphStyle(withHangul: true)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return boundingBox.width
    }

    /**
        - parameters:
            - maxWidth: 최대 width를 제한하여 boundingRect 구해야 할 경우
            - maxSize : 최대로 size를 제한하여 boundingRect 구해야 할 경우. 이것마저 없으면 default 1줄일 때의 사이즈를 구한다.
            - font : 문자열을 넣을 곳의 폰트
        - returns: 문자열의 실제 Rect의 크기
    */
    public func size(maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude,
                     maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0),
                     font: UIFont) -> CGSize {
        let constraintSize: CGSize
        if maxWidth < .greatestFiniteMagnitude {
            // 개발자가 최대 width를 제한한 경우, 높이는 무한대까지 늘어날 수 있다고 둔다.
            constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        }
        else {
            // 아닌 경우에는 개발자가 세팅한 maxSize 내에서의 boundingBox를 구해오며, 이 값도 주지 않은 경우 1줄에서의 size를 구한다.
            constraintSize = maxSize
        }
        let paragraphStyle = NSMutableParagraphStyle(withHangul: true)
        let boundingBox: CGRect = self.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }

    ///  숫자:숫자 형태로 된 문자열에서 ":"(콜론 문자열)을 보고 비율값을 return하는 함수
    public func bannerImageSize() -> CGSize? {
        let array = self.split(":") // 150:62
        guard let wStr = array[safe: 0], let hStr = array[safe: 1] else { return nil }
        let w = wStr.toCGFloat()
        let h = hStr.toCGFloat()
        return CGSize(width: w, height: h)
    }
}

// MARK: - NSMutableAttributedString
extension String {
    // 검색모듈 SRCH_DESCRIPTION에서 디폴트 pretendard 폰트로 노출되기 위해 만들어둠 (24.9.3)
    public var htmlToAttributedStringWithBold: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            let attr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            // 변환된 문자열의 폰트 속성을 검사하고 시스템 기본 폰트인 경우 Pretendard로 대체
            attr.enumerateAttribute(.font, in: NSRange(location: 0, length: attr.length), options: []) { (value, range, _) in
                if let font = value as? UIFont {
                    if font.fontName.contains("TimesNewRoman") {
                        guard let regularFont = UIFont(name: "gothic-regular", size: font.pointSize), let boldFont = UIFont(name: "gothic-bold", size: font.pointSize) else { return }
                        attr.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: attr.length))

                        if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                            attr.addAttribute(.font, value: boldFont, range: range)
                        }
                    }
                }
            }

            return attr
        }
        catch {
            return NSMutableAttributedString()
        }
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
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle(withHangul: true)
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
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle(withHangul: true)
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
}

// MARK: - HTML
extension String {
    public var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let attr = try? NSMutableAttributedString(data: data,
                                                      options: [
                                                        .documentType: NSAttributedString.DocumentType.html,
                                                        .characterEncoding: String.Encoding.utf8.rawValue
                                                      ],
                                                      documentAttributes: nil)
            return attr
        }
    }
    // HTML 태그 제거 함수 (변환 실패 시 대체용)
    public func stripHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "",
                                      options: .regularExpression,
                                      range: nil)
    }

    public func htmlToAttributedStringWithCustomFont(_ font: UIFont) -> NSAttributedString? {
        if let attributedText = self.replace("\\n", "\n").replace("\n", "<br>").htmlToAttributedString {
            return attributedText.applyCustomFont(font)
        }
        else {
            return NSAttributedString(string: self.stripHTMLTags())
        }
    }
}

// MARK: - swizzle
public func swizzleReplacingCharacters() {
    let originalMethod = class_getInstanceMethod(NSString.self, #selector(NSString.replacingCharacters(in:with:)))
    let swizzledMethod = class_getInstanceMethod(NSString.self, #selector(NSString.swizzledReplacingCharacters(in:with:)))

    guard let original = originalMethod, let swizzled = swizzledMethod else { return }

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
