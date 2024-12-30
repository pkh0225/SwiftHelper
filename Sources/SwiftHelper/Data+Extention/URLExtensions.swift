//
//  URLExtensions.swift
//  ssg
//
//  Created by leejaejin on 2020/06/10.
//  Copyright © 2020 emart. All rights reserved.
//

import Foundation

extension URL {
    // URL(string:)을 사용하면 url string 에 한글이 포함된 url 이거나 url encodeing 된 경우에 nil 을 반환하는 경우가 있어서 다시 decoding 하여 URL(string:)을 실행한다.
    public init?(urlString: String) {
        if let _ = URL(string: urlString) {
            self.init(string: urlString)
        }
        else {
            let urlEncodeString = urlString.urlQueryEncoded()

            if let _ = URL(string: urlEncodeString) {
                self.init(string: urlEncodeString)
            }
            else {
                self.init(string: urlString)
            }
        }
    }
}
