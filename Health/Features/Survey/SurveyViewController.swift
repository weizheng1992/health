//
//  SurveyViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import MapKit
import MessageKit

final class SurveyViewController: MessageKit.MessagesViewController {
    
    // MARK: Properties
    
    private var data: [Int: [SurveyAnswer]] = [:]
    private var items: [MessageType] = []
    private let user: Sender = Sender(id: "-1", displayName: "")
    private let server: Sender = Sender(id: "0", displayName: "")
    private var footer: SurveyViewFooter?
    
    private var isSubmitted: Bool = false
    private var isDone: Bool = false {
        didSet {
            let bottomInset: CGFloat
            if #available(iOS 11.0, *) {
                bottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
            } else {
                bottomInset = 0
            }
            
            let footerHeight = 60.0 + bottomInset
            
            messagesCollectionView.contentInset.bottom = footerHeight
            messagesCollectionView.scrollIndicatorInsets.bottom = footerHeight
            
            if footer == nil {
                footer = SurveyViewFooter()
                footer?.submitClosure = { [weak self] in
                    if self?.isSubmitted ?? false {
                        self?.pickSpecialist()
                    } else {
                        self?.submitSurvey()
                    }
                }
                view.addSubview(footer!)
            }
        }
    }
    
    override var inputAccessoryView: UIView? {
        return nil
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarTintColor = .black
        navigationItem.title = JKString("survey.title")
        
        messagesCollectionView.collectionViewLayout = SurveyViewLayout()
        messagesCollectionView.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.register(SurveyViewCell.self)
        messagesCollectionView.register(SurveyViewDateCell.self)
        messagesCollectionView.register(SurveyViewPickerCell.self)
        messagesCollectionView.register(SurveyViewSingleSelectionCell.self)
        messagesCollectionView.register(SurveyViewMultipleSelectionCell.self)
        
        let avatarSize = CGSize(width: 37.0, height: 37.0)
        let avatarPosition = AvatarPosition(vertical: AvatarPosition.Vertical.messageLabelTop)
        let layout = messagesCollectionView.collectionViewLayout as! MessagesCollectionViewFlowLayout
        layout.setMessageIncomingAvatarPosition(avatarPosition)
        layout.setMessageOutgoingAvatarPosition(avatarPosition)
        layout.setMessageIncomingAvatarSize(avatarSize)
        layout.setMessageOutgoingAvatarSize(avatarSize)
        
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        insertMessages([SurveyMessage(message: JKString("survey.message.hello"))], after: 1)
        getQuestion(0)
    }
    
    // MARK: Layout
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isDone else { return }
        
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            bottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        } else {
            bottomInset = 0
        }
        
        let footerHeight = 60.0 + bottomInset
        footer?.frame = CGRect(x: 0.0, y: view.frame.height - footerHeight, width: view.frame.width, height: footerHeight)
    }
    // MARK: Networking
    
    private func getQuestion(_ questionId: Int = 0) {
        let _ = HTTPClient.shared.getSurveyQuestion(questionId) { [weak self] (response, error) in
            if response?.code == 1000, let item = response?.data, let question = item.question {
                if item.question?.type == .area {
                    self?.loadAreas(for: item)
                } else {
                    self?.insertMessages([question, item], after: 2)
                }
            } else {
                let cancelAction = UIAlertAction(title: JKString("Cancel"), style: .cancel, handler: nil)
                let retryAction = UIAlertAction(title: JKString("Retry"), style: .default, handler: { (alert) in
                    self?.getQuestion(questionId)
                })
                self?.alert(.alert, title: JKString("Error"), message: response?.message ?? error?.localizedDescription ?? "", actions: [cancelAction, retryAction])
            }
        }
    }
    
    private func loadAreas(for item: SurveyItem) {
        let _ = HTTPClient.shared.loadAreas { [weak self] (response, error) in
            if response?.code == 1000, let areas = response?.data, !areas.isEmpty {
                item.areas = areas
                self?.insertMessages([item.question!, item], after: 1)
            } else {
                let cancelAction = UIAlertAction(title: JKString("Cancel"), style: .cancel, handler: nil)
                let retryAction = UIAlertAction(title: JKString("Retry"), style: .default, handler: { (alert) in
                    self?.loadAreas(for: item)
                })
                self?.alert(.alert, title: JKString("Error"), message: response?.message ?? error?.localizedDescription ?? "", actions: [cancelAction, retryAction])
            }
        }
    }
    
    private func submitSurvey() {
        navigationController?.showHUD()
        
        let _ = HTTPClient.shared.submitSurvey(data) { [weak self] (response, error) in
            self?.navigationController?.hideHUD()
            
            if response?.code == 1000 {
                self?.isSubmitted = true
                self?.pickSpecialist()
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.kind {
        case .custom:
            guard let item = message as? SurveyItem,
                let question = item.question,
                let type = question.type else {
                    return messagesCollectionView.dequeueReusableCell(SurveyViewCell.self, for: indexPath)
            }
            
            let cell: SurveyViewCell
            switch type {
            case .singleSelection:
                if let answers = item.answers, answers.count == 2 {
                    cell = messagesCollectionView.dequeueReusableCell(SurveyViewSingleSelectionCell.self, for: indexPath)
                } else {
                    cell = messagesCollectionView.dequeueReusableCell(SurveyViewPickerCell.self, for: indexPath)
                }
            case .multipleSelection:
                cell = messagesCollectionView.dequeueReusableCell(SurveyViewMultipleSelectionCell.self, for: indexPath)
            case .date:
                cell = messagesCollectionView.dequeueReusableCell(SurveyViewDateCell.self, for: indexPath)
            case .area, .value:
                cell = messagesCollectionView.dequeueReusableCell(SurveyViewPickerCell.self, for: indexPath)
            }
            
            cell.configure(with: item) { [weak self] newItem in
                if type == .multipleSelection {
                    var array: [String] = []
                    let nextQuestionId: Int = newItem.userAllAnswers?.values.first?.nextQuestionId ?? -1
                    newItem.userAllAnswers?.values.forEach {
                        if let text = $0.text {
                            array.append(text)
                        }
                    }
                    let answer = SurveyAnswer(id: -1, text: array.joined(separator: "\n"), value: nil, nextQuestionId: nextQuestionId, sort: nil, unit: nil)
                    self?.answer(newItem, with: answer)
                } else {
                    self?.answer(newItem, with: newItem.userAnswer!)
                }
            }
            return cell
        default:
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    // MARK: Helper
    
    private func insertMessages(_ messages: [MessageType], after seconds: Int = 0) {
        for (index, item) in messages.enumerated() {
            let s = index + seconds
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(s), execute: {
                self.items.append(item)
                self.messagesCollectionView.insertSections([self.items.count - 1])
                self.messagesCollectionView.scrollToBottom()
            })
        }
    }
    
    private func answer(_ item: SurveyItem, with answer: SurveyAnswer) {
        if let tagId = item.question?.tagId {
            var values: [SurveyAnswer] = []
            if let obj = item.userAnswer {
                values.append(obj)
            }
            if let obj = item.userAllAnswers?.values {
                obj.forEach { values.append($0) }
            }
            data[tagId] = values
        }
        
        items.removeLast()
        messagesCollectionView.reloadData()
        insertMessages([answer], after: 1)
        
        if answer.nextQuestionId != -1 {
            getQuestion(answer.nextQuestionId)
        } else {
            insertMessages([SurveyMessage(message: JKString("survey.message.end"))], after: 2)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                self.isDone = true
            })
        }
    }
    
    private func pickSpecialist() {
        let specialistPickerViewController = SpecialistPickerViewController()
        navigationController?.pushViewController(specialistPickerViewController, animated: true)
    }
    
}

// MARK: - MessagesDataSource

extension SurveyViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return user
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return items.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return items[indexPath.section]
    }
    
}

// MARK: - MessagesDisplayDelegate

extension SurveyViewController: MessagesDisplayDelegate {
    
    // MARK: Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return []
    }
    
    // MARK: All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 39 / 255.0, green: 191 / 255.0, blue: 155 / 255.0, alpha: 1.0) : .white
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.image = isFromCurrentSender(message: message) ? UIImage(named: "Avatar-User") : UIImage(named: "Avatar-AI")
        avatarView.backgroundColor = .clear
    }
    
}

// MARK: - MessagesLayoutDelegate

extension SurveyViewController: MessagesLayoutDelegate { }
