//
//  BoolExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 16/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

extension Bool {
    ///   Converts Bool to Int.
    public var toInt: Int { return self ? 1 : 0 }

    ///   Return inverted value of bool.
    public var toggled: Bool {
        return !self
    }
}
