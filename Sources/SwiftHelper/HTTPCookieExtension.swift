//
//  HTTPCookieExtension.swift
//  ssg
//
//  Created by mykim on 2018. 2. 5..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation

extension HTTPCookie {
    public func getCookieString() -> String {
        var str = ""
        str.append("\(name)=\(value);")
        str.append("path=\(path);")
        str.append("isSecure=\(isSecure ? "TRUE" : "FALSE");")
        str.append("sessionOnly=\(isSessionOnly ? "TRUE" : "FALSE");")
        str.append("domain=\(domain);")
        if let expiresDate = self.expiresDate {
            str.append("expiresDate=\(expiresDate);")
        }
        else {
            // println("getCookieString ==> \(str)")
        }

        return str
    }

}
