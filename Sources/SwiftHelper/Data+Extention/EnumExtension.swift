//
//  EnumExtension.swift
//  SwiftHelper
//
//  Copyright © 2025 mykim. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Equatable {
    public var index: Int {
        return Self.allCases.enumerated().first(where: { $0.element == self })?.offset ?? 0
    }
}

extension RawRepresentable where RawValue == String {
    public init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
