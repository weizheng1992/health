//
//  News.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

struct NewsItem: Codable {
    var id: Int?
    var title: String?
    var content: String?
    var imageUrl: String?
    var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content = "desp"
        case imageUrl = "logo"
        case url = "returnUrl"
    }
}

struct NewsChannel: Codable {
    var id: Int
    var name: String?
}
