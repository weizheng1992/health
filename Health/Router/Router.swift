//
//  Router.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import Alamofire

public final class Router {
    
    // MARK: Singleton
    
    public static let shared = Router()
    
    // MARK: Public Methods
    
    public func register(handlerType: RouteHandler.Type, for route: String) {
        
    }
    
    public func handle(url: URLConvertible, additionalParameters: [String: Any]? = nil, callback: RouteCallback? = nil) throws {
        do {
            let request = try RouteRequest(url: url, additionalParameters: additionalParameters, callback: callback)
            try handle(request: request)
        } catch {
            throw error
        }
    }
    
    public func handle(request: RouteRequest) throws {
        
    }
    
}
