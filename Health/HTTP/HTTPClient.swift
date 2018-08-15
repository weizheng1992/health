//
//  HTTPClient.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import Alamofire

let APIBaseURL = "http://10.90.50.2"

struct API {
    let endpoint: String
    let method: HTTPMethod
}

enum APIError: Error {
    case error(code: Int?, message: String?)
}

struct APIResponse<T>: Codable where T: Codable {
    var code: Int
    var message: String?
    var data: T?
}

struct APIResponseData: Codable { }

final class HTTPClient {

    // MARK: Singleton

    static let shared = HTTPClient()

    // MARK: Public Methods
    
    func request<T>(_ api: API, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, completion: ((APIResponse<T>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        return request(APIBaseURL + api.endpoint, method: api.method, parameters: parameters, encoding: encoding, completion: completion)
    }
    
    func request<T>(_ url: URLConvertible, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, completion: ((APIResponse<T>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        return Alamofire.request(url, method: method, parameters: HTTPClient.parameters(with: parameters), encoding: encoding).responseData { response in
            if response.error == nil, let data = response.data {
                do {
                    let model = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                    completion?(model, APIError.error(code: model.code, message: model.message))
                } catch {
                    completion?(nil, error)
                }
            } else {
                if let e = response.error as NSError?, e.domain == NSURLErrorDomain, e.code == -999 { return }
                completion?(nil, response.error)
            }
        }
    }
    
    // MARK: Helper
    
    private static func parameters(with parameters: Parameters? = nil) -> Parameters {
        var newParameters = parameters ?? [:]
        if let user = App.shared.user {
            newParameters["token"] = user.token ?? ""
            newParameters["uid"] = user.userId ?? ""
        }
        return newParameters
    }
    
}
