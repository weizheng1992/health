//
//  URL+JK.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import Foundation

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else { return nil }
        
        var parameters: [String: String] = [:]
        
        for queryItem in queryItems {
            parameters[queryItem.name] = queryItem.value
        }
        
        return parameters
    }
    
    public mutating func appendQueryParameters(_ parameters: [String: String]) {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        self = urlComponents.url!
    }
    
}
