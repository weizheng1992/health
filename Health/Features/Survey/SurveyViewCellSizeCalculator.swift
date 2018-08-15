//
//  SurveyViewCellSizeCalculator.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import MessageKit

final class SurveyViewCellSizeCalculator: MessageSizeCalculator {
    
    override func messageContainerSize(for message: MessageType) -> CGSize {
        guard let item = message as? SurveyItem,
            let question = item.question,
            let type = question.type else {
            return .zero
        }
        
        switch type {
        case .singleSelection:
            if let answers = item.answers, answers.count == 2 {
                return CGSize(width: messagesLayout.itemWidth, height: 124.0 + 30.0)
            } else {
                return CGSize(width: messagesLayout.itemWidth, height: 270.0 + 30.0)
            }
        case .multipleSelection:
            if let answers = item.answers, !answers.isEmpty {
                var height: CGFloat = 0.0
                answers.forEach {
                    let labelHeight = $0.text?.boundingRect(
                        with: CGSize(width: messagesLayout.itemWidth - 16.0 * 2.0 - 20.0 - 10.0 - 18.0 - 10.0, height: CGFloat(MAXFLOAT)),
                        options: .usesLineFragmentOrigin,
                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)],
                        context: nil
                        ).height ?? 24.0
                    height += max(labelHeight, 24.0) + 20.0
                }
                return CGSize(width: messagesLayout.itemWidth, height: height + 36.0 + 20.0 * 2.0 + 30.0)
            } else {
                return .zero
            }
        case .date:
            return CGSize(width: messagesLayout.itemWidth, height: 270.0 + 30.0)
        case .area:
            return CGSize(width: messagesLayout.itemWidth, height: 270.0 + 30.0)
        case .value:
            return CGSize(width: messagesLayout.itemWidth, height: 270.0 + 30.0)
        }
    }
    
}
