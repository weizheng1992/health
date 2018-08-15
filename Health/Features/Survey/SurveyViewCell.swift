//
//  SurveyViewCell.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

class SurveyViewCell: UICollectionViewCell {
    
    var item: SurveyItem?
    var completion: ((SurveyItem) -> Swift.Void)?
    
    func configure(with item: SurveyItem, completion: ((SurveyItem) -> Swift.Void)? = nil) {
        self.item = item
        self.completion = completion
    }
    
}

// MARK: - SurveyViewDateCell

final class SurveyViewDateCell: SurveyViewCell {
    
    // MARK: Properties
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let maximumDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(year: -100)
        let minimumDate = calendar.date(byAdding: dateComponents, to: maximumDate)
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = maximumDate
        picker.minimumDate = minimumDate
        return picker
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.submit"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 18.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 13.0
        contentView.layer.cornerRadius = 6.0
        contentView.addSubview(cardView)
        
        cardView.addSubview(datePicker)
        cardView.addSubview(submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = CGRect(x: 16.0, y: 15.0, width: frame.width - 16.0 * 2.0, height: frame.height - 30.0)
        cardView.frame = contentView.bounds
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: cardView.frame.width, height: cardView.frame.height - 36.0 - 20.0 * 2.0)
        submitButton.frame = CGRect(x: 72.0, y: cardView.frame.height - 20.0 - 36.0, width: cardView.frame.width - 72.0 * 2.0, height: 36.0)
    }
    
    // MARK: Actions
    
    @objc
    private func submitButtonTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        item?.userAnswer = SurveyAnswer(id: nil, text: dateFormatter.string(from: datePicker.date), value: nil, nextQuestionId: item!.answers!.first!.nextQuestionId, sort: nil, unit: nil)
        completion?(item!)
    }
    
}

// MARK: - SurveyViewSingleSelectionCell

final class SurveyViewSingleSelectionCell: SurveyViewCell {
    
    // MARK: Properties
    
    override var item: SurveyItem? {
        didSet {
            aButton.setTitle(item?.answers?.first?.text, for: .normal)
            bButton.setTitle(item?.answers?.last?.text, for: .normal)
        }
    }
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    @objc dynamic
    private lazy var aButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.submit"), for: .normal)
        button.setTitleColor(.main, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 18.0
        button.layer.borderColor = UIColor.main.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc dynamic
    private lazy var bButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.submit"), for: .normal)
        button.setTitleColor(.main, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 18.0
        button.layer.borderColor = UIColor.main.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 13.0
        contentView.layer.cornerRadius = 6.0
        contentView.addSubview(cardView)
        
        cardView.addSubview(aButton)
        cardView.addSubview(bButton)
        
        addObserver(self, forKeyPath: "aButton.highlighted", options: .new, context: nil)
        addObserver(self, forKeyPath: "bButton.highlighted", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "aButton.highlighted")
        removeObserver(self, forKeyPath: "bButton.highlighted")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = CGRect(x: 16.0, y: 15.0, width: frame.width - 16.0 * 2.0, height: frame.height - 30.0)
        cardView.frame = contentView.bounds
        aButton.frame = CGRect(x: 20.0, y: 20.0, width: cardView.frame.width - 20.0 * 2.0, height: 36.0)
        bButton.frame = CGRect(x: 20.0, y: aButton.frame.maxY + 12.0, width: cardView.frame.width - 20.0 * 2.0, height: 36.0)
    }
    
    // MARK: Actions
    
    @objc
    private func submitButtonTapped(_ sender: UIButton) {
        if sender == aButton {
            item?.userAnswer = item?.answers?.first
        } else if sender == bButton {
            item?.userAnswer = item?.answers?.last
        }
        completion?(item!)
    }
    
}

extension SurveyViewSingleSelectionCell {
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "aButton.highlighted" {
            aButton.backgroundColor = aButton.isHighlighted ? .main : .white
        } else if keyPath == "bButton.highlighted" {
            bButton.backgroundColor = aButton.isHighlighted ? .main : .white
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

// MARK: - SurveyViewMultipleSelectionCell

final class SurveyViewMultipleSelectionCell: SurveyViewCell {
    
    // MARK: Properties
    
    override var item: SurveyItem? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(SurveyViewMultipleSelectionItemCell.self, forCellReuseIdentifier: "SurveyViewMultipleSelectionItemCell")
        return tableView
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.submit"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 18.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 13.0
        contentView.layer.cornerRadius = 6.0
        contentView.addSubview(cardView)
        
        cardView.addSubview(tableView)
        cardView.addSubview(submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = CGRect(x: 16.0, y: 15.0, width: frame.width - 16.0 * 2.0, height: frame.height - 30.0)
        cardView.frame = contentView.bounds
        tableView.frame = CGRect(x: 0.0, y: 0.0, width: cardView.frame.width, height: cardView.frame.height - 36.0 - 20.0 * 2.0)
        submitButton.frame = CGRect(x: 72.0, y: cardView.frame.height - 20.0 - 36.0, width: cardView.frame.width - 72.0 * 2.0, height: 36.0)
    }
    
    // MARK: Actions
    
    @objc
    private func submitButtonTapped(_ sender: UIButton) {
        if let data = item?.userAllAnswers, !data.isEmpty {
            completion?(item!)
        } else {
            
        }
    }
    
}

extension SurveyViewMultipleSelectionCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyViewMultipleSelectionItemCell", for: indexPath) as! SurveyViewMultipleSelectionItemCell
        cell.answer = item?.answers?[indexPath.row]
        cell.checkboxClosure = { [weak self] (answer, isChecked) in
            var map = self?.item?.userAllAnswers ?? [:]
            if isChecked {
                map[answer.id!] = answer
            } else {
                map.removeValue(forKey: answer.id!)
            }
            self?.item?.userAllAnswers = map
        }
        return cell
    }
    
}

extension SurveyViewMultipleSelectionCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let labelHeight = item?.answers?[indexPath.row].text?.boundingRect(
            with: CGSize(width: frame.width - 16.0 * 2.0 - 20.0 - 10.0 - 18.0 - 10.0, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)],
            context: nil
            ).height ?? 24.0
        return max(labelHeight, 24.0) + 20.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

final class SurveyViewMultipleSelectionItemCell: UITableViewCell {
    
    // MARK: Properties
    
    var answer: SurveyAnswer? {
        didSet {
            answerLabel.text = answer?.text
            checkbox.isSelected = false
            checkbox.layer.borderColor = UIColor.darkGray.cgColor
            checkbox.backgroundColor = .white
        }
    }
    
    var checkboxClosure: ((SurveyAnswer, Bool) -> ())?
    
    private lazy var checkbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Survey-Checkmark"), for: .selected)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(checkboxDidTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxDidTapped(_:))))
        return label
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(checkbox)
        contentView.addSubview(answerLabel)
        
        separatorInset = .zero
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        checkbox.frame = CGRect(x: 20.0, y: (frame.height - 18.0) / 2.0, width: 18.0, height: 18.0)
        answerLabel.frame = CGRect(x: checkbox.frame.maxX + 10.0, y: 0, width: frame.width - checkbox.frame.maxX - 10.0, height: frame.height - 1.0)
    }
    
    // MARK: Actions
    
    @objc
    private func checkboxDidTapped(_ sender: Any?) {
        checkbox.isSelected = !checkbox.isSelected
        checkbox.layer.borderColor = checkbox.isSelected ? UIColor.main.cgColor : UIColor.darkGray.cgColor
        checkbox.backgroundColor = checkbox.isSelected ? .main : .white
        checkboxClosure?(answer!, checkbox.isSelected)
    }
    
}

// MARK: - SurveyViewPickerCell

final class SurveyViewPickerCell: SurveyViewCell {
    
    // MARK: Properties
    
    override var item: SurveyItem? {
        didSet {
            if item?.question?.type == .value, item?.answers?.count == 2,
                let firstAnswer = item?.answers?.first, let lastAnswer = item?.answers?.last,
                let min = firstAnswer.value, let minValue = Int(min),
                let max = lastAnswer.value, let maxValue = Int(max), minValue < maxValue {
                var answers: [SurveyAnswer] = []
                for i in minValue...maxValue {
                    let valueText = String(i)
                    let newAnswer = SurveyAnswer(id: 0, text: valueText, value: valueText, nextQuestionId: firstAnswer.nextQuestionId, sort: i, unit: firstAnswer.unit)
                    answers.append(newAnswer)
                }
                item?.answers = answers
            }
            
            pickerView.reloadAllComponents()
            if pickerView.numberOfRows(inComponent: 0) > 0 {
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
        }
    }
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.submit"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 18.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 13.0
        contentView.layer.cornerRadius = 6.0
        contentView.addSubview(cardView)
        
        cardView.addSubview(pickerView)
        cardView.addSubview(submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = CGRect(x: 16.0, y: 15.0, width: frame.width - 16.0 * 2.0, height: frame.height - 30.0)
        cardView.frame = contentView.bounds
        pickerView.frame = CGRect(x: 0.0, y: 0.0, width: cardView.frame.width, height: cardView.frame.height - 36.0 - 20.0 * 2.0)
        submitButton.frame = CGRect(x: 72.0, y: cardView.frame.height - 20.0 - 36.0, width: cardView.frame.width - 72.0 * 2.0, height: 36.0)
    }
    
    // MARK: Actions
    
    @objc
    private func submitButtonTapped(_ sender: UIButton) {
        if item?.question?.type == .area {
            let aRow = pickerView.selectedRow(inComponent: 0)
            let bRow = pickerView.selectedRow(inComponent: 1)
            
            guard let areas = item?.areas, !areas.isEmpty else { return }
            guard let subAreas = areas[aRow].subAreas else { return }
            
            let text: String
            if bRow < subAreas.count {
                text = (areas[aRow].area?.name ?? "") + (subAreas[bRow].name ?? "")
            } else {
                text = (areas[aRow].area?.name ?? "")
            }
            
            item?.userAnswer = SurveyAnswer(id: nil, text: text, value: text, nextQuestionId: item!.answers!.first!.nextQuestionId, sort: nil, unit: nil)
        } else {
            item?.userAnswer = item?.answers?[pickerView.selectedRow(inComponent: 0)]
        }
        
        completion?(item!)
    }
    
}

extension SurveyViewPickerCell: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return item?.question?.type == .area ? 2 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if item?.question?.type == .area {
            switch component {
            case 0:
                return item?.areas?.count ?? 0
            case 1:
                return item?.areas?[pickerView.selectedRow(inComponent: 0)].subAreas?.count ?? 0
            default:
                return 0
            }
        }
        return item?.answers?.count ?? 0
    }
    
}

extension SurveyViewPickerCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if item?.question?.type == .area {
            switch component {
            case 0:
                return item?.areas?[row].area?.name
            case 1:
                return item?.areas?[pickerView.selectedRow(inComponent: 0)].subAreas?[row].name
            default:
                return nil
            }
        }
        return (item?.answers?[row].text ?? "") + " " + (item?.answers?[row].unit ?? "")
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if item?.question?.type == .area, component == 0 {
            pickerView.reloadComponent(1)
            
            guard let subAreas = item?.areas?[pickerView.selectedRow(inComponent: 0)].subAreas, !subAreas.isEmpty else { return }
            
            pickerView.selectRow(0, inComponent: 1, animated: false)
        }
    }
    
}
