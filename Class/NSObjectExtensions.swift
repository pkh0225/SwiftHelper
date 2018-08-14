//
//  NSObjectExtensions.swift
//  ssg
//
//  Created by pkh on 2018. 1. 26..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation

private var Object_class_Name_Key : UInt8 = 0
private var Object_iVar_Name_Key : UInt8 = 0
private var Object_iVar_Value_Key : UInt8 = 0

public var Object_Info_Dic = [String: [IvarInfo]]()

//let valueTypesMap: Dictionary<String, Any> = [
//    "c" : Int8.self,
//    "s" : Int16.self,
//    "i" : Int32.self,
//    "q" : Int.self, //also: Int64, NSInteger, only true on 64 bit platforms
//    "S" : UInt16.self,
//    "I" : UInt32.self,
//    "Q" : UInt.self, //also UInt64, only true on 64 bit platforms
//    "B" : Bool.self,
//    "d" : Double.self,
//    "f" : Float.self,
//    "{" : Decimal.self
//]


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

public struct  IvarInfo {
    
    public enum IvarInfoClassType {
        case any
        case array
        case dictionary
        case int
        case string
        case float
        case bool
    }
    
    public var label: String = ""
    public var classType: IvarInfoClassType = .any
    public var subClassType: AnyClass?
    
    public init(label: String, classType: IvarInfoClassType, subClassType: AnyClass?, value: Any?) {
        self.label = label
        self.classType = classType
        self.subClassType = subClassType // subClas가 custom class인 array, dictionary 일때만 사용.
    }
}



@inline(__always) public func getDictionary(mirrored_object: Mirror) -> [String: Any] {
    var dict = [String: Any]()
    for (label, value) in mirrored_object.children {
        guard let label = label else { continue }
        if label == "_descriptionTab" {
            continue
        }
        dict[label] = value as AnyObject
    }
    if let parent = mirrored_object.superclassMirror {
        let dict2 = getDictionary(mirrored_object: parent)
        for (key,value) in dict2 {
            dict.updateValue(value, forKey:key)
        }
    }
    
    return dict
}

@inline(__always) public func getIvarInfoList(_ classType: NSObject.Type) -> [IvarInfo] {
    
    
    let mirror = Mirror(reflecting: classType.init())
    var ivarDataList = [IvarInfo]()
    ivarDataList.reserveCapacity(mirror.children.count)
    
    for case let (label?, value) in mirror.children {
//        print("label: \(label), class: \(self.className) value: \(value)")
        if label == "_descriptionTab" {
            continue
        }
        
        var className = String(describing: type(of: value))
        
        if className.contains("Array<String>") || className.contains("Array<Any>") || className.contains(".Type") || className.contains("Dictionary<") || className.contains("Optional<Any>") || className.contains("Optional<AnyObject>") {
            ivarDataList.append( IvarInfo(label: label, classType: .any, subClassType: nil, value: nil) )
        }
        else if className.contains("Array<") {
            className = className.replace(">", "")
            className = className.replace("Array<", "")
            ivarDataList.append( IvarInfo(label: label, classType: .array, subClassType: swiftClassFromString(className) , value: nil) )
        }
        else if className.contains("Optional<") || className.contains("ImplicitlyUnwrappedOptional<") {
            className = className.replace(">", "")
            className = className.replace("ImplicitlyUnwrappedOptional<", "")
            className = className.replace("Optional<", "")
            ivarDataList.append( IvarInfo(label: label, classType: .dictionary, subClassType: swiftClassFromString(className), value: nil) )
        }
        else {
            if value is String {
                ivarDataList.append( IvarInfo(label: label, classType: .string, subClassType: nil, value: nil) )
            }
            else if value is Int {
                ivarDataList.append( IvarInfo(label: label, classType: .int, subClassType: nil, value: nil) )
            }
            else if value is Float {
                ivarDataList.append( IvarInfo(label: label, classType: .float, subClassType: nil, value: nil) )
            }
            else if value is Bool {
                ivarDataList.append( IvarInfo(label: label, classType: .bool, subClassType: nil, value: nil) )
            }
            else {
                ivarDataList.append( IvarInfo(label: label, classType: .any, subClassType: nil, value: nil) )
            }
            
            
        }
        
    }
    
    if let superClass = class_getSuperclass(classType),
        superClass != PKHParser.self {
        let superIvarDataList = getIvarInfoList(superClass as! NSObject.Type)
        if superIvarDataList.count > 0 {
            ivarDataList += superIvarDataList
        }
    }
    
    
    
    return ivarDataList
}

//@inline(__always) func getTypesOfProperties(_ clazz: NSObject.Type) -> Dictionary<String, Any>? {
//    var count = UInt32()
//    guard let properties = class_copyPropertyList(clazz, &count) else { return nil }
//    var types: Dictionary<String, Any> = [:]
//    for i in 0..<Int(count) {
//        let property: objc_property_t = properties[i]
//        guard let name = getNameOf(property: property) else { continue }
//        let type = getTypeOf(property: property)
//        types[name] = type
//    }
//    free(properties)
//    return types
//}
//
//@inline(__always) func getNameOf(property: objc_property_t) -> String? {
//    guard
//        let name: NSString = NSString(utf8String: property_getName(property))
//        else { return nil }
//    return name as String
//}
//
//@inline(__always) func getTypeOf(property: objc_property_t) -> Any {
//    guard let attributesAsNSString: NSString = NSString(utf8String: property_getAttributes(property)!) else { return Any.self }
//    let attributes = attributesAsNSString as String
//    let slices = attributes.components(separatedBy: "\"")
//    guard slices.count > 1 else { return valueType(withAttributes: attributes) }
//    let objectClassName = slices[1]
//    let objectClass = NSClassFromString(objectClassName) as! NSObject.Type
//    return objectClass
//}
//
//@inline(__always) func valueType(withAttributes attributes: String) -> Any {
//    let letter = attributes[1..<2]
//    guard let type = valueTypesMap[letter] else { return Any.self }
//    return type
//}

extension NSObject {
    
    @inline(__always) public func ivarToDictionary() -> [String: Any] {
        let mirrored_object = Mirror(reflecting: self)
        return getDictionary(mirrored_object:mirrored_object)
    }
    
    @inline(__always) public func ivarInfoList() -> [IvarInfo] {
//        print(String(describing: type(of:self)))
        if let info = Object_Info_Dic[self.className] {
            return info
        }
        else {
            let info = getIvarInfoList(type(of:self))
            Object_Info_Dic[self.className] = info
            return info
        }
        
        
//        return getIvarInfoList(type(of:self))
    }
}

extension NSObject {
    
    public var tag_name: String? {
        get {
            return objc_getAssociatedObject(self, &Object_iVar_Name_Key) as? String
        }
        set {
            objc_setAssociatedObject(self, &Object_iVar_Name_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var tag_value: Any? {
        get {
            return objc_getAssociatedObject(self, &Object_iVar_Value_Key)
        }
        set {
            objc_setAssociatedObject(self, &Object_iVar_Value_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var className: String {
        if let name = objc_getAssociatedObject(self, &Object_class_Name_Key) as? String {
            return name
        }
        else {
            let name = String(describing: type(of:self))
            objc_setAssociatedObject(self, &Object_class_Name_Key, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
        
        
    }
    
    public class var className: String {
        if let name = objc_getAssociatedObject(self, &Object_class_Name_Key) as? String {
            return name
        }
        else {
            let name = NSStringFromClass(self).components(separatedBy: ".").last ?? ""
            objc_setAssociatedObject(self, &Object_class_Name_Key, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
    }
}

