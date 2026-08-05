//
//  URLExtensions.swift
//  ssg
//
//  Copyright © 2020 emart. All rights reserved.
//

import Foundation

extension URL {
    public func getParams() -> [String: String]? {
        guard let urlComponents: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems: [URLQueryItem] = urlComponents.queryItems else { return nil }
        var params: [String: String] = Dictionary()
        for item: URLQueryItem in queryItems {
            if let value = item.value {
                params[item.name] = value
            }
            else {
                params[item.name] = ""
            }
        }
        return params
    }

}
