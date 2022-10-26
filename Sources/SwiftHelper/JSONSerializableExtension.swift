//
//  JSONSerializableExtension.swift
//  WiggleSDK
//
//  Created by mykim on 2018. 8. 20..
//  Copyright © 2018년 mykim. All rights reserved.
//

import Foundation

public protocol JSONSerializable {
    var JSONRepresentation: [String: Any] { get }
}

extension JSONSerializable {
    public var JSONRepresentation: [String: Any] {
        var representation: [String: Any] = [String: Any]()

        let mirrored_object: Mirror = Mirror(reflecting: self)

        representation = getMirrorToDic(mirrored_object: mirrored_object)

        return representation
    }

    private func getMirrorToDic(mirrored_object: Mirror) -> [String: Any] {
//        print("mirrored_object: \(mirrored_object)")
        var representation: [String: Any] = [String: Any]()

        for case let (label?, value) in mirrored_object.children {
//            print("label: \(label), value: \(value)")
            if label == "_descriptionTab" {
                continue
            }
            if label == "_debugJsonDic" {
                continue
            }
            if label == "_debugAnyData" {
                continue
            }

            let mir = Mirror(reflecting: value)
            if mir.displayStyle == .enum {
                let valueArray = "\(value)".split(separator: ".")
                let caseName = "\(valueArray.last ?? "")"
                representation[label] = caseName
            }
            else {
                switch value {
                case let value as [Any]:
                    var addArray = [Any]()
                    for item in value {
                        if let subArray: [JSONSerializable] = item as? [JSONSerializable] {
                            var addSubArray: [[String: Any]] = [[String: Any]]()
                            for subItem: JSONSerializable in subArray {
                                let dic = subItem.JSONRepresentation
                                if dic.isEmpty == false {
                                    addSubArray.append(dic)
                                }
                            }
                            if addSubArray.isEmpty == false {
                                addArray.append(addSubArray)
                            }

                        }
                        else if let strArray: String = item as? String {
                            if strArray.isEmpty == false {
                                addArray.append(strArray)
                            }
                        }
                        else if let item: JSONSerializable = item as? JSONSerializable {
                            let dic = item.JSONRepresentation
                            if dic.isEmpty == false {
                                addArray.append(dic)
                            }
                        }
                        else if let dic: [String: String] = item as? [String: String] {
                            if dic.isEmpty == false {
                                addArray.append(dic)
                            }
                        }
                    }

                    if addArray.isEmpty == false {
                        representation[label] = addArray
                    }

                case let value as [String: Any]:
                    if value.isEmpty == false {
                        representation[label] = value
                    }

                case let value as JSONSerializable:
                    let dic = value.JSONRepresentation
                    if dic.isEmpty == false {
                        representation[label] = value.JSONRepresentation
                    }

                case let value as AnyObject:
                    representation[label] = "\(value)"

                default:
                    print("mirrored_object: \(mirrored_object)")
                    print(" Ignore any unserializable properties")
                    print("label: \(label), value: \(value)")
                    break
                }
            }
        }

        if let parent: Mirror = mirrored_object.superclassMirror {
            let dic: [String: Any] = getMirrorToDic(mirrored_object: parent)
            if dic.isEmpty == false {
                representation += dic
            }

        }
        return representation

    }
}

extension JSONSerializable {
    public func toJSON() -> String? {
        let representation: [String: Any] = JSONRepresentation
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [.prettyPrinted])
            return String(data: data, encoding: String.Encoding.utf8)
        }
        catch {
            return nil
        }
    }
}

extension Optional: JSONSerializable {
    public var JSONRepresentation: [String: Any] {
        guard let x = self else { return [String: Any]() }
        if let value: JSONSerializable = x as? JSONSerializable {
            return value.JSONRepresentation
        }
        return [String: Any]()
    }

}
