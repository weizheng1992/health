//
//  HTTPClient+News.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import Foundation
import Alamofire

extension HTTPClient {
    
    func fetchNewsChannels(_ completion: ((APIResponse<[NewsChannel]>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        return request(API.fetchNewsChannels, parameters: nil, completion: completion)
    }
    
    func fetchNews(channelID: Int?, begin: Int, end: Int, completion: ((APIResponse<[NewsItem]>?, Error?) -> Swift.Void)? = nil) -> Alamofire.DataRequest {
        var parameters = Parameters()
        parameters["begin"] = begin
        parameters["end"] = end
        if let id = channelID {
            parameters["typeId"] = id
        }
        return request(API.fetchNews, parameters: parameters, completion: completion)
    }
    
}

extension API {
    static let fetchNewsChannels = API(endpoint: ":3080/member/news/type/list", method: .get)
    static let fetchNews = API(endpoint: ":3080/member/news/list", method: .get)
}
