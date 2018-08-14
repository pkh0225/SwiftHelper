//
//  NSMutableAttributedStringExtensions.swift
//  ssg
//
//  Created by pkh on 2018. 1. 16..
//  Copyright © 2018년 emart. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
