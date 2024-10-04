//
//  Closure.swift
//  Test
//
//  Created by 박길호 on 8/14/24.
//  Copyright © 2024 pkh. All rights reserved.
//

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
public typealias AuthorizationPhotoCallback = (_ status: Int, _ isAccess: Bool) -> Void

public typealias AnyPointClosure = (_ value: Any) -> CGPoint
public typealias CommonOnTextFieldNotificationClosure = (_ isShow: Bool, _ keyboardHeight: CGFloat, _ notification: Notification) -> Void
public typealias StringBoolClosure = (_ value1: String, _ value2: Bool) -> Void
public typealias StringAnyClosure = (_ value1: String, _ value2: Any) -> Void
public typealias ViewStringClosure = (_ view: UIView, _ value: String) -> CGPoint

public typealias TransitionAnimationClosure     = (_ fromViewController: UIViewController, _ toViewController: UIViewController, _ completion: @escaping VoidClosure) -> Void

public typealias LongTapMenuClosure             = (_ indexMenu: Int, _ indexPath: IndexPath, _ pointInCell: CGPoint ) -> Void
public typealias LongTapMenuScreennameClosure   = (_ indexPath: IndexPath, _ pointInCell: CGPoint ) -> String
public typealias LongTapMenuDataItemClosure     = (_ indexPath: IndexPath, _ pointInCell: CGPoint ) -> Any
public typealias LongTapMenuCellClosure         = (_ indexPath: IndexPath, _ pointInCell: CGPoint) -> Any
public typealias LongTapMenuShareClosure        = (_ dataItem: Any, _ cell: Any, _ screenNameSecond: String) -> Void
