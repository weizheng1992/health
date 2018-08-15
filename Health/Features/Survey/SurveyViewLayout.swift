//
//  SurveyViewLayout.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import MessageKit

final class SurveyViewLayout: MessagesCollectionViewFlowLayout {
    
    lazy open var surveyViewCellSizeCalculator = SurveyViewCellSizeCalculator(layout: self)
    
    override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.kind {
        case .custom:
            return surveyViewCellSizeCalculator
        default:
            return super.cellSizeCalculatorForItem(at: indexPath)
        }
    }
}

