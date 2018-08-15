//
//  Survey.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import MessageKit

// MARK: - SurveyItem

final class SurveyItem: Codable {
    var question: SurveyQuestion?
    var answers: [SurveyAnswer]?
    
    private enum CodingKeys: String, CodingKey {
        case question = "studyFlowQuestion"
        case answers = "studyFlowAnswers"
    }
}

extension SurveyItem: MessageType {
    
    var sender: Sender {
        return Sender(id: "1", displayName: "")
    }
    
    var messageId: String {
        let id = question?.id == nil ? UUID().uuidString : String(question!.id!)
        return "#" + id
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .custom(self)
    }
    
}

extension SurveyItem {
    
    private struct AssociatedKeys {
        static var userAnswer: SurveyAnswer = SurveyAnswer(id: nil, text: nil, value: nil, nextQuestionId: 0, sort: nil, unit: nil)
        static var userAllAnswers: [Int: SurveyAnswer] = [:]
        static var areas: [AreaInfo] = []
    }
    
    var userAnswer: SurveyAnswer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.userAnswer) as? SurveyAnswer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.userAnswer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var userAllAnswers: [Int: SurveyAnswer]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.userAllAnswers) as? [Int: SurveyAnswer]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.userAllAnswers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var areas: [AreaInfo]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.areas) as? [AreaInfo]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.areas, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

// MARK: - SurveyQuestion

struct SurveyQuestion: Codable {
    var id: Int?
    var type: SurveyQuestionType?
    var text: String?
    var tagId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case text = "questionDesc"
        case tagId = "tagDictId"
    }
}

extension SurveyQuestion: MessageType  {
    
    var sender: Sender {
        return Sender(id: "0", displayName: "")
    }
    
    var messageId: String {
        return id == nil ? UUID().uuidString : String(id!)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text ?? "")
    }
    
}

enum SurveyQuestionType: Int, Codable {
    case singleSelection = 1
    case multipleSelection = 2
    case date = 3
    case value = 4
    case area = 5
}

// MARK: - SurveyAnswer

struct SurveyAnswer: Codable {
    var id: Int?
    var text: String?
    var value: String?
    var nextQuestionId: Int
    var sort: Int?
    var unit: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case text = "answerDesc"
        case value = "answerValue"
        case nextQuestionId
        case sort
        case unit
    }
}

extension SurveyAnswer: MessageType {
    
    var sender: Sender {
        return Sender(id: "-1", displayName: "")
    }
    
    var messageId: String {
        return id == nil ? UUID().uuidString : String(id!)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text((text ?? "") + " " + (unit ?? ""))
    }
    
}

// MARK: - Area

struct AreaInfo: Codable {
    var area: Area?
    var subAreas: [Area]?
}

struct Area: Codable {
    var id: Int?
    var level: Int?
    var name: String?
    var parentId: Int?
}

// MARK: - SurveyMessage

struct SurveyMessage: MessageType {
    let id: String = UUID().uuidString
    var message: String
    
    var sender: Sender {
        return Sender(id: "0", displayName: "")
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(message)
    }
}
