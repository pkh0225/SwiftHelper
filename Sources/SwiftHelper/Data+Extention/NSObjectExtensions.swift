//
//  NSObjectExtensions.swift
//  ssg
//
//  Created by pkh on 2018. 1. 26..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation
import UIKit

final class ObjectInfoMap: Sendable {
    let ivarInfoList: [IvarInfo]

    init(ivarInfoList: [IvarInfo]) {
        self.ivarInfoList = ivarInfoList
    }
}

final class CacheManager: Sendable {
    static let shared = CacheManager()
    nonisolated(unsafe) private var cache = NSCache<NSString, ObjectInfoMap>()
    private let queue = DispatchQueue(label: "com.cacheManager.queue")

    init() {
        self.cache.countLimit = 500
    }

    func setObject(_ obj: ObjectInfoMap, forKey key: String) {
        self.queue.async(flags: .barrier) {
            self.cache.setObject(obj, forKey: key as NSString)
        }
    }

    func object(forKey key: String) -> ObjectInfoMap? {
        return self.queue.sync {
            self.cache.object(forKey: key as NSString)
        }
    }
}

@inline(__always) public func swiftClassFromString(_ className: String, bundleName: String = "WiggleSDK") -> AnyClass? {
    // get the project name
    if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        // generate the full name of your class (take a look into your "YourProject-swift.h" file)
        let classStringName: String = "\(appName).\(className)"
        guard let aClass: AnyClass = NSClassFromString(classStringName) else {
            let classStringName: String = "\(bundleName).\(className)"
            guard let aClass: AnyClass = NSClassFromString(classStringName) else {
//                print(">>>>>>>>>>>>> [ \(className) ] : swiftClassFromString Create Fail <<<<<<<<<<<<<<")
                return nil

            }
            return aClass
        }
        return aClass
    }
//    print(">>>>>>>>>>>>> [ \(className) ] : swiftClassFromString Create Fail <<<<<<<<<<<<<<")
    return nil
}

struct  IvarInfo {
    enum IvarInfoClassType: String {
        case any
        case array
        case dictionary
        case int
        case string
        case float
        case cgfloat
        case double
        case bool
        case exceptType // 예외 항목

        public init(string: String) {
            let value = string.lowercased()
            self = .init(rawValue: value) ?? .exceptType
        }
    }

    var label: String = ""
    var classType: IvarInfoClassType = .exceptType
    var stringClassTypeName: String = ""
    var subClassType: AnyClass?
    var subValueType: IvarInfoClassType = .exceptType
}

@inline(__always) func getDictionaryExcludSuper(mirrored_object: Mirror) -> [String: Any] {
    var dict: [String: Any] = [String: Any]()
    for (label, value) in mirrored_object.children {
        guard let label else { continue }
        if let objList = value as? [NSObject] {
            var dicList: [[String: Any]] = []
            for obj in objList {
                let dic = obj.toDictionary()
                dicList.append(dic)
            }
            dict[label] = dicList
        }
        else {
            dict[label] = value as AnyObject
        }

    }

    return dict
}

@inline(__always) func getDictionary(mirrored_object: Mirror) -> [String: Any] {
    var dict: [String: Any] = [String: Any]()
    for (label, value) in mirrored_object.children {
        guard let label else { continue }
        guard label != "_debugAnyData" else { continue }
        guard label != "_debugJsonDic" else { continue }

        if value is String || value is Int || value is Float || value is CGFloat || value is Double || value is Bool || value is CGPoint || value is CGSize || value is CGRect || value is UIEdgeInsets {
            dict[label] = value as AnyObject
        }
        else if let objList = value as? [String] {
            dict[label] = objList
        }
        else if let objList = value as? [Int] {
            dict[label] = objList
        }
        else if let objList = value as? [Float] {
            dict[label] = objList
        }
        else if let objList = value as? [CGFloat] {
            dict[label] = objList
        }
        else if let objList = value as? [Double] {
            dict[label] = objList
        }
        else if let objList = value as? [NSObject] {
            var dicList: [[String: Any]] = []
            for obj in objList {
                let dic = obj.toDictionary()
                dicList.append(dic)
            }
            dict[label] = dicList
        }
        else if let obj = value as? NSObject {
            let dic = obj.toDictionary()
            dict[label] = dic
        }
        else {
            dict[label] = value as AnyObject
        }
    }
    if let parent: Mirror = mirrored_object.superclassMirror {
        let dict2: [String: Any] = getDictionary(mirrored_object: parent)
        for (key, value) in dict2 {
            dict.updateValue(value, forKey: key)
        }
    }

    return dict
}

@inline(__always) func getIvarInfoList(_ classType: NSObject.Type) -> [IvarInfo] {
    var className: String = ""

    let mirror: Mirror = Mirror(reflecting: classType.init())
    var ivarDataList: [IvarInfo] = [IvarInfo]()
    ivarDataList.reserveCapacity(mirror.children.count)

    for case let (label?, value) in mirror.children {
        let label = label.replace("$__lazy_storage_$_", "")
        className = String(describing: type(of: value))

        if className.contains("Array<Any>") || className.contains(".Type") || className.contains("Dictionary<") || className.contains("Optional<Any>") || className.contains("Optional<AnyObject>") {
            ivarDataList.append( IvarInfo(label: label, classType: .any, stringClassTypeName: className, subClassType: nil) )
        }
        else if className.contains("Array<") {
            className = className.replace(">", "")
            className = className.replace("Array<", "")
            className = className.replace("Optional<", "")
            if className == "String" || className == "Int" || className == "CGFloat" || className == "Float" || className == "Double" || className == "Bool" {
                ivarDataList.append( IvarInfo(label: label, classType: .array, stringClassTypeName: className, subValueType: IvarInfo.IvarInfoClassType(string: className)) )
            }
            else {
                ivarDataList.append( IvarInfo(label: label, classType: .array, stringClassTypeName: className, subClassType: swiftClassFromString(className)) )
            }
        }
        else if className.contains("Optional<") || className.contains("ImplicitlyUnwrappedOptional<") {
            className = className.replace(">", "")
            className = className.replace("ImplicitlyUnwrappedOptional<", "")
            className = className.replace("Optional<", "")
            ivarDataList.append( IvarInfo(label: label, classType: .dictionary, stringClassTypeName: className, subClassType: swiftClassFromString(className)) )
        }
        else {
            if value is String {
                ivarDataList.append( IvarInfo(label: label, classType: .string, stringClassTypeName: className, subClassType: nil) )
            }
            else if value is Int {
                ivarDataList.append( IvarInfo(label: label, classType: .int, stringClassTypeName: className, subClassType: nil) )
            }
            else if value is Float {
                ivarDataList.append( IvarInfo(label: label, classType: .float, stringClassTypeName: className, subClassType: nil) )
            }
            else if value is CGFloat {
                ivarDataList.append( IvarInfo(label: label, classType: .cgfloat, stringClassTypeName: className, subClassType: nil) )
            }
            else if value is Double {
                ivarDataList.append( IvarInfo(label: label, classType: .double, stringClassTypeName: className, subClassType: nil) )
            }
            else if value is Bool {
                ivarDataList.append( IvarInfo(label: label, classType: .bool, stringClassTypeName: className, subClassType: nil) )
            }
            else {
                if Mirror(reflecting: value).displayStyle == .class {
                    ivarDataList.append( IvarInfo(label: label, classType: .dictionary, stringClassTypeName: className, subClassType: swiftClassFromString(className)) )
                }
                else  if Mirror(reflecting: value).displayStyle == .`enum` || Mirror(reflecting: value).displayStyle == .struct {
                    ivarDataList.append( IvarInfo(label: label, classType: .exceptType, stringClassTypeName: className, subClassType: nil) )
                }
                else {
                    ivarDataList.append( IvarInfo(label: label, classType: .any, stringClassTypeName: className, subClassType: nil) )
                }
            }
        }
    }

    if let superClass = class_getSuperclass(classType) {
        let superIvarDataList = getIvarInfoList(superClass as! NSObject.Type)
        if superIvarDataList.count > 0 {
            ivarDataList += superIvarDataList
        }
    }

    return ivarDataList
}

extension NSObject {
    @inline(__always) public func toDictionary() -> [String: Any] {
        let mirrored_object: Mirror = Mirror(reflecting: self)
        return getDictionary(mirrored_object: mirrored_object)
    }

    @inline(__always) public func toDictionaryExcludeSuperClass() -> [String: Any] {
        let mirrored_object: Mirror = Mirror(reflecting: self)
        return getDictionaryExcludSuper(mirrored_object: mirrored_object)
    }

    @inline(__always) func ivarInfoList() -> [IvarInfo] {
//        print(String(describing: type(of:self)))
        if let info = CacheManager.shared.object(forKey: self.className) {
            return info.ivarInfoList
        }
        else {
            let infoList: [IvarInfo] = getIvarInfoList(type(of: self))
            let info: ObjectInfoMap = ObjectInfoMap(ivarInfoList: infoList )
            CacheManager.shared.setObject(info, forKey: self.className)
            return infoList
        }
//        return getIvarInfoList(type(of:self))
    }
}

extension NSObject {
    private struct AssociatedKeys {
        nonisolated(unsafe) static var observerAble: UInt8 = 0
        nonisolated(unsafe) static var isRequestImpression: UInt8 = 0
    }

    public var toInt: Int {
        return unsafeBitCast(self, to: Int.self)
    }

    public var className: String { String(describing: type(of:self)) }
    public class var className: String { String(describing: self) }

    public var observerAble: (key: Notification.Name, closure: ((_ value: String) -> Void)?)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.observerAble) as? (key: Notification.Name, ((_ value: String) -> Void)?)
        }
        set {
            if objc_getAssociatedObject(self, &AssociatedKeys.observerAble) == nil {
                NotificationCenter.default.addObserver(self, selector: #selector(onObserver), name: newValue?.key, object: nil)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.observerAble, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var isRequestImpression: Bool {
        get {
            if let isRequestImpression: Bool = objc_getAssociatedObject(self, &AssociatedKeys.isRequestImpression) as? Bool {
                return isRequestImpression
            }
            else {
                let isRequestImpression: Bool = false
                objc_setAssociatedObject(self, &AssociatedKeys.isRequestImpression, isRequestImpression, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return isRequestImpression
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isRequestImpression, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private func onObserver() {
        observerAble?.closure?(observerAble?.key.rawValue ?? "")
    }
}
