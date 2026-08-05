//
//  DefineClosure.swift
//  SwiftHelper
//
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

public typealias VoidClosure                = () -> Void
public typealias IntegerClosure             = (_ value: Int) -> Void
public typealias FloatClosure               = (_ value: Float) -> Void
public typealias CGFloatClosure             = (_ value: CGFloat) -> Void
public typealias StringClosure              = (_ value: String) -> Void
public typealias BoolClosure                = (_ value: Bool) -> Void
public typealias AnyClosure                 = (_ value: Any?) -> Void
public typealias AnyBoolClosure             = (_ value: Any?) -> Bool
public typealias URLClosure                 = (_ value: URL) -> Void
public typealias ImageClosure               = (_ value: UIImage?) -> Void
public typealias DictionaryClosure          = (_ value: [String: Any]?) -> Void
public typealias ArrayClosure               = (_ value: [Any]?) -> Void
public typealias BoolReturnClosure          = () -> Bool
public typealias RectClosure                = (_ value: CGRect) -> Void
public typealias SizeClosure                = (_ value: CGSize) -> Void
public typealias PoiontClosure              = (_ value: CGPoint) -> Void
public typealias OnButtonClosure            = (_ sender: UIButton?) -> Void
public typealias ActionClosure              = (_ actionType: String, _ data: Any?) -> Void
public typealias CompletionClosure          = (_ completion: @escaping BoolClosure) -> Void
public typealias ScrollViewCallback         = (_ scrollView: UIScrollView) -> Void

public typealias IntStringClosure = (Int, String) -> Void
public typealias StringBoolClosure = (_ value1: String, _ value2: Bool) -> Void
public typealias StringAnyClosure = (_ value1: String, _ value2: Any) -> Void
