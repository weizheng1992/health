//
//  HTTPClient+User.swift
//  Health
//
//  Created by Weichen Jiang on 8/9/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import Foundation
import Alamofire

extension HTTPClient {
    
    func signIn(with mobile: String, code: String, completion: ((APIResponse<User>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var parameters = Parameters()
        parameters["mobilePhone"] = mobile
        parameters["sms"] = code
        parameters["productId"] = 2
        parameters["deviceId"] = Info.Application.identifierForVendor?.uuidString
        
        return request(API.signIn, parameters: parameters, completion: completion)
    }
    
    func getVerifyCodeToken(with mobile: String, completion: ((APIResponse<String>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var parameters = Parameters()
        parameters["mobilePhone"] = mobile
        
        return request(API.getVerifyCodeToken, parameters: parameters, completion: completion)
    }
    
    func sendVerifyCode(to mobile: String, token: String, completion: ((APIResponse<APIResponseData>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var parameters = Parameters()
        parameters["mobilePhone"] = mobile
        parameters["token"] = token
        
        return request(API.sendVerifyCode, parameters: parameters, completion: completion)
    }
    
}

extension API {
    static let signIn = API(endpoint: ":3080/member/user/login", method: .post)
    static let getVerifyCodeToken = API(endpoint: ":2080/sso/sms/token", method: .post)
    static let sendVerifyCode = API(endpoint: ":2080/sso/sms/message", method: .post)
}
