//
//  CommonFunc.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import Foundation

open class CommonFunc {
    open class func language() -> String {
        let defaults = UserDefaults.standard
        let appleLanguages = defaults.object(forKey: "AppleLanguages")
        guard let languages = appleLanguages as? Array<String> else {
            return ""
        }
        
        guard languages.count > 0 else {
            return ""
        }
        
        return languages[0]
    }
}
