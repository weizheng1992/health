//
//  TodayViewModel.swift
//  Health
//
//  Created by Weichen Jiang on 8/14/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

enum TodayItemType: Int, Codable {
    case text
    case article
    case suggestion
    case alarm
    case drink
    case test
    case record
}

struct TodayItem: Codable {
    var type: TodayItemType?
    var title: String?
    var text: String?
    var date: Date?
    var url: String?
    var imageUrl: String?
}

extension TodayItem {
    
    func cellIdentifier() -> String? {
        guard let itemType = type else { return nil }
        
        switch itemType {
        case .text:
            return TodayViewTextCellIdentifier
        case .article:
            return TodayViewArticleCellIdentifier
        case .drink:
            return TodayViewDrinkCellIdentifier
        case .alarm:
            return TodayViewAlarmCellIdentifier
        case .record:
            return TodayViewRecordCellIdentifier
        case .test:
            return TodayViewTestCellIdentifier
        case .suggestion:
            return TodayViewSuggestionCellIdentifier
        }
    }
    
    func typeLabel() -> String? {
        guard let itemType = type else { return nil }
        
        switch itemType {
        case .text:
            return nil
        case .article:
            return JKString("today.items.type.article")
        case .drink:
            return JKString("today.items.type.drink")
        case .alarm:
            return JKString("today.items.type.alarm")
        case .record:
            return JKString("today.items.type.record")
        case .test:
            return JKString("today.items.type.test")
        case .suggestion:
            return JKString("today.items.type.suggestion")
        }
    }
    
    func typeIcon() -> UIImage? {
        guard let itemType = type else { return nil }
        
        switch itemType {
        case .text:
            return nil
        case .article:
            return UIImage(named: "Today-Article")
        case .drink:
            return UIImage(named: "Today-Drink")
        case .alarm:
            return UIImage(named: "Today-Alarm")
        case .record:
            return UIImage(named: "Today-Record")
        case .test:
            return UIImage(named: "Today-Test")
        case .suggestion:
            return UIImage(named: "Today-Suggestion")
        }
    }
    
    func rowHeight() -> CGFloat {
        guard let itemType = type else { return 0.0 }
        
        switch itemType {
        case .text:
            let textHeight = text?.boundingRect(
                with: CGSize(width: UIScreen.main.bounds.width - 15.0 * 2.0 - 80.0 - 16.0 * 2.0, height: CGFloat(MAXFLOAT)),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)],
                context: nil
                ).height ?? 0
            return textHeight > 0.0 ? textHeight + 15.0 * 2.0 + 30.0 + 5.0 : 0.0
        case .article:
            return 112.0 + 30.0 + 5.0
        case .drink:
            return 112.0 + 30.0 + 5.0
        case .alarm:
            return 112.0 + 30.0 + 5.0
        case .record:
            return 168.0 + 30.0 + 5.0
        case .test:
            return 104.0 + 30.0 + 5.0
        case .suggestion:
            return 112.0 + 30.0 + 5.0
        }
    }
    
}

struct TodaySpecialistInfo: Codable {
    var id: Int?
    var name: String?
    var avatarUrl: String?
}

class TodayDataModel: Codable {
    var specialistInfo: TodaySpecialistInfo?
    var items: [TodayItem]?
}
