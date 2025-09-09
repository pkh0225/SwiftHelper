//
//  Logger.swift
//  SwiftHelper
//
//  Created by 박길호 on 9/9/25.
//

import Foundation
import OSLog

// MARK: - 로그 레벨 정의
public enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case notice = "NOTICE"
    case error = "ERROR"
    case fault = "FAULT"

    var osLogType: OSLogType {
        switch self {
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            return .default
        case .error:
            return .error
        case .fault:
            return .fault
        }
    }
}

// MARK: - 커스텀 로거 클래스
public class Logger {
    public var isDebugPrintEnabled: Bool = false

    private let subsystem: String
    private let category: String
    private let osLog: OSLog

    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "MyApp", category: String = "General") {
        self.subsystem = subsystem
        self.category = category
        self.osLog = OSLog(subsystem: subsystem, category: category)
    }

    @inline(__always) private func getLogMessage(message: String, file: String, function: String, line: Int) -> String {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "[HH:mm:ss.SSS]"
        let dateString: String = dateFormatter.string(from: Date())
        let logMessage = "[\(fileName):\(line)]\(dateString) \(function) - \(message)"
        return logMessage
    }

    // MARK: - 각 레벨별 로깅 메서드

    /// Debug 레벨 로그 (개발 중 디버깅 정보)
    public func debug(_ message: String,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {

        let logMessage = getLogMessage(message: message, file: file, function: function, line: line)

        os_log("%@", log: osLog, type: .debug, logMessage)

        #if DEBUG
        if isDebugPrintEnabled { print("🐛 [DEBUG] \(logMessage)") }
        #endif
    }

    /// Info 레벨 로그 (일반적인 정보)
    public func info(_ message: String,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
        let logMessage = getLogMessage(message: message, file: file, function: function, line: line)

        os_log("%@", log: osLog, type: .info, logMessage)

        #if DEBUG
        if isDebugPrintEnabled { print("ℹ️ [INFO] \(logMessage)") }
        #endif
    }

    /// Notice 레벨 로그 (주목할 만한 이벤트)
    public func notice(_ message: String,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
        let logMessage = getLogMessage(message: message, file: file, function: function, line: line)

        os_log("%@", log: osLog, type: .default, logMessage)

        #if DEBUG
        if isDebugPrintEnabled { print("📢 [NOTICE] \(logMessage)") }
        #endif
    }

    /// Error 레벨 로그 (에러 상황)
    public func error(_ message: String,
               error: Error? = nil,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
        var logMessage = getLogMessage(message: message, file: file, function: function, line: line)

        if let error = error {
            logMessage += " Error: \(error.localizedDescription)"
        }

        os_log("%@", log: osLog, type: .error, logMessage)

        #if DEBUG
        if isDebugPrintEnabled { print("❌ [ERROR] \(logMessage)") }
        #endif
    }

    /// Fault 레벨 로그 (심각한 오류)
    public func fault(_ message: String,
               error: Error? = nil,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
        var logMessage = getLogMessage(message: message, file: file, function: function, line: line)

        if let error = error {
            logMessage += " Critical Error: \(error.localizedDescription)"
        }

        os_log("%@", log: osLog, type: .fault, logMessage)

        #if DEBUG
        print("🔥 [FAULT] \(logMessage)")
        #endif

        // 심각한 오류는 추가 처리 (예: 크래시 리포팅)
        // crashlytics.record(error: error)
    }
}

// MARK: - 전역 로거 인스턴스
public extension Logger {
    static let shared = Logger()

    // 카테고리별 로거들
    static let network = Logger(category: "Network")
    static let ui = Logger(category: "UI")
    static let database = Logger(category: "Database")
    static let auth = Logger(category: "Authentication")
}

// MARK: - 로그 필터링을 위한 확장
public extension Logger {
    /// 특정 레벨 이상의 로그만 출력하는 메서드
    func log(_ level: LogLevel,
             _ message: String,
             error: Error? = nil,
             file: String = #file,
             function: String = #function,
             line: Int = #line) {

        switch level {
        case .debug:
            debug(message, file: file, function: function, line: line)
        case .info:
            info(message, file: file, function: function, line: line)
        case .notice:
            notice(message, file: file, function: function, line: line)
        case .error:
            self.error(message, error: error, file: file, function: function, line: line)
        case .fault:
            fault(message, error: error, file: file, function: function, line: line)
        }
    }
}

// MARK: - 간편 사용을 위한 전역 함수들
public func logDebug(_ message: String,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    Logger.shared.debug(message, file: file, function: function, line: line)
}

public func logInfo(_ message: String,
             file: String = #file,
             function: String = #function,
             line: Int = #line) {
    Logger.shared.info(message, file: file, function: function, line: line)
}

public func logNotice(_ message: String,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
    Logger.shared.notice(message, file: file, function: function, line: line)
}

public func logError(_ message: String,
              error: Error? = nil,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    Logger.shared.error(message, error: error, file: file, function: function, line: line)
}

public func logFault(_ message: String,
              error: Error? = nil,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    Logger.shared.fault(message, error: error, file: file, function: function, line: line)
}
