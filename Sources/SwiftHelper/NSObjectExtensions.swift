//
//  NSObjectExtensions.swift
//  ssg
//
//  Created by pkh on 2018. 1. 26..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation

@inline(__always) public func swiftClassFromString(_ className: String, bundleName: String = "WiggleSDK") -> AnyClass? {
    
    // get the project name
    if  let appName = Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as? String {
        // generate the full name of your class (take a look into your "YourProject-swift.h" file)
        let classStringName = "\(appName).\(className)"
        guard let aClass = NSClassFromString(classStringName) else {
            let classStringName = "\(bundleName).\(className)"
            guard let aClass = NSClassFromString(classStringName) else {
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


extension NSObject {
    private struct AssociatedKeys {
        static var className: UInt8 = 0
        static var iVarName: UInt8 = 0
        static var iVarValue: UInt8 = 0
    }
    
    public var toInt: Int {
        return unsafeBitCast(self, to: Int.self)
    }
    
    public var tag_name: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.iVarName) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.iVarName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var tag_value: Any? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.iVarValue)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.iVarValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var className: String {
        if let name = objc_getAssociatedObject(self, &AssociatedKeys.className) as? String {
            return name
        }
        else {
            let name = String(describing: type(of:self))
            objc_setAssociatedObject(self, &AssociatedKeys.className, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
        
        
    }
    
    public class var className: String {
        if let name = objc_getAssociatedObject(self, &AssociatedKeys.className) as? String {
            return name
        }
        else {
            let name = String(describing: self)
            objc_setAssociatedObject(self, &AssociatedKeys.className, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
    }
    
    public var stretch_image : Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.iVarName) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.iVarName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var strech_point : CGPoint? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.iVarName) as? CGPoint
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.iVarName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

