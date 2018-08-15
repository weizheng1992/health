//
//  RouteRequest.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import Alamofire

public enum CompassError: Error {
    case invalidURL(url: URLConvertible)
    case schemeNotMatch(url: URLConvertible)
    case hostNotMatch(url: URLConvertible)
    case urlNotMatch(url: URLConvertible)
}

public typealias RouteCallback = (CompassError?, Any?) -> Void

public final class RouteRequest {
    
    public private(set) var url: URL
    
    public private(set) var queryParameters: [String: String]?
    public private(set) var routeParameters: [String: String]?
    public var additionalParameters: [String: Any]?
    
    public var callback: RouteCallback?
    
    public init(url: URLConvertible, additionalParameters: [String: Any]? = nil, callback: RouteCallback? = nil) throws {
        do {
            self.url = try url.asURL()
        } catch {
            throw CompassError.invalidURL(url: url)
        }
        
        self.queryParameters = self.url.queryParameters
        self.additionalParameters = additionalParameters
        self.callback = callback
    }
    
}
