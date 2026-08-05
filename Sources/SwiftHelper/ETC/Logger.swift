//
//  Logger.swift
//  SwiftHelper
//
//  Copyright © 2026 mykim. All rights reserved.
//

import Foundation
@_exported import os

extension Logger {
    // 앱의 번들 식별자를 서브시스템으로 사용
    private static let subsystem = Bundle.main.bundleIdentifier ?? "SwiftHelper"

    // 카테고리별 Logger 정의
    nonisolated public static let etc = Logger(subsystem: subsystem, category: "ETC")
    nonisolated public static let ui = Logger(subsystem: subsystem, category: "UI")
    nonisolated public static let network = Logger(subsystem: subsystem, category: "Network")
    nonisolated public static let cookie = Logger(subsystem: subsystem, category: "Cookie")
    nonisolated public static let `extension` = Logger(subsystem: subsystem, category: "Extension")
    nonisolated public static let `deinit` = Logger(subsystem: subsystem, category: "Deinit")
    nonisolated public static let parser = Logger(subsystem: subsystem, category: "parser")

    nonisolated public static let apiAutoTest = Logger(subsystem: subsystem, category: "apiAutoTest")
}

extension Logger {
    nonisolated public func logDebug(_ message: String) {
        self.debug("🔍 DEBUG: \(message)")
    }

    nonisolated public func logInfo(_ message: String) {
        self.info("ℹ️ INFO: \(message)")
    }

    nonisolated public func logNotice(_ message: String) {
        self.notice("✅ Notice: \(message)")
    }

    nonisolated public func logWarning(_ message: String) {
        self.warning("⚠️ WARNING: \(message)")
    }

    nonisolated public func logError(_ message: String) {
        self.error("🚨 ERROR: \(message)")
    }

    nonisolated public func logFault(_ message: String) {
        self.fault("💣 FAULT: \(message)")
    }
}

extension Logger {
    nonisolated public func logError(_ error: any Error, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        self.error("🚨 [\(fileName)] \(function) (Line \(line)) - Error: \(error.localizedDescription)")
    }
}
