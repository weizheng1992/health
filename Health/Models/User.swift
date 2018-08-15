//
//  User.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

struct User: Codable {
    var userId: Int?
    var memberId: Int?
    var token: String?
    var mobile: String?
    var isFirstRegister: Bool?
}
