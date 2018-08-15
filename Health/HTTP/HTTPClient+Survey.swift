//
//  HTTPClient+Survey.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import Foundation
import Alamofire

extension HTTPClient {
    
    func getSurveyQuestion(_ questionId: Int, completion: ((APIResponse<SurveyItem>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        return request(API.getSurveyQuestion, parameters: [ "questionId": questionId ], completion: completion)
    }
    
    func submitSurvey(_ data: [Int: [SurveyAnswer]], completion: ((APIResponse<APIResponseData>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var array: [[String: Any]] = []
        for (key, value) in data {
            value.forEach {
                array.append(["tagDictId": key, "tagValue": $0.value ?? ""])
            }
        }
        
        var parameters = Parameters()
        parameters["answers"] = array
        parameters["deviceId"] = Info.Application.identifierForVendor?.uuidString
        
        return request(API.submitSurvey, parameters: parameters, encoding: JSONEncoding.default, completion: completion)
    }
    
    func loadAreas(_ completion: ((APIResponse<[AreaInfo]>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        return request(API.getAreas, parameters: nil, completion: completion)
    }
    
    func loadSpecialists(_ completion: ((APIResponse<[Specialist]>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var parameters = Parameters()
        parameters["deviceId"] = Info.Application.identifierForVendor?.uuidString
        
        return request(API.loadSpecialists, parameters: parameters, completion: completion)
    }
    
    func bindSpecialist(_ specialistId: Int, completion: ((APIResponse<APIResponseData>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest  {
        var parameters = Parameters()
        parameters["deviceId"] = Info.Application.identifierForVendor?.uuidString
        parameters["managerId"] = specialistId
        
        return request(API.bindSpecialist, parameters: parameters, completion: completion)
    }
    
    func acceptTelephoneReturn(_ completion: ((APIResponse<APIResponseData>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var parameters = Parameters()
        parameters["type"] = 1
        
        return request(API.acceptTelephoneReturn, parameters: parameters, completion: completion)
    }
    
}

extension API {
    static let getSurveyQuestion = API(endpoint: ":3080/member/studyflow/question", method: .get)
    static let submitSurvey = API(endpoint: ":3080/member/studyflow/add", method: .post)
    static let getAreas = API(endpoint: ":3080/member/studyflow/cities", method: .get)
    static let loadSpecialists = API(endpoint: ":4080/doctor/manager/managerInfo", method: .get)
    static let bindSpecialist = API(endpoint: ":4080/doctor/manager/sign", method: .get)
    static let acceptTelephoneReturn = API(endpoint: ":3080/member/user/visit", method: .post)
}
