//
//  TodayViewCell.swift
//  Health
//
//  Created by Weichen Jiang on 8/13/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import AlamofireImage

let TodayViewTextCellIdentifier = "TodayViewTextCellIdentifier"
let TodayViewArticleCellIdentifier = "TodayViewArticleCellIdentifier"
let TodayViewDrinkCellIdentifier = "TodayViewDrinkCellIdentifier"
let TodayViewAlarmCellIdentifier = "TodayViewAlarmCellIdentifier"
let TodayViewRecordCellIdentifier = "TodayViewRecordCellIdentifier"
let TodayViewTestCellIdentifier = "TodayViewTestCellIdentifier"
let TodayViewSuggestionCellIdentifier = "TodayViewSuggestionCellIdentifier"

// MARK: -

class TodayViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var item: TodayItem? {
        didSet {
            iconImageView.image = item?.typeIcon()
            typeLabel.text = item?.typeLabel()
        }
    }
    
    private lazy var dashLine: VerticalDashLineView = VerticalDashLineView(
        frame: CGRect(x: 40.0, y: 25.0, width: 1.0, height: frame.height - 25.0 - 10.0),
        length: 5.0,
        spacing: 1.0,
        color: UIColor(red: 180 / 255.0, green: 180 / 255.0, blue: 180 / 255.0, alpha: 1.0)
    )
    
    private lazy var iconView: UIView = {
        let iconView = UIView()
        iconView.backgroundColor = UIColor(red: 202 / 255.0, green: 205 / 255.0, blue: 214 / 255.0, alpha: 1.0)
        iconView.layer.cornerRadius = 32.0 / 2.0
        iconView.addSubview(iconImageView)
        return iconView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20.0 / 2.0
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        return label
    }()
    
    private lazy var shadowContentView: UIView = {
        let shadowContentView = UIView()
        shadowContentView.backgroundColor = .white
        shadowContentView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowContentView.layer.shadowOffset = .zero
        shadowContentView.layer.shadowOpacity = 0.3
        shadowContentView.layer.shadowRadius = 2.0
        shadowContentView.layer.cornerRadius = 6.0
        shadowContentView.addSubview(itemView)
        return shadowContentView
    }()
    
    fileprivate lazy var itemView: UIView = {
        let itemView = UIView()
        itemView.layer.cornerRadius = 6.0
        itemView.clipsToBounds = true
        return itemView
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        selectionStyle = .none
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        
        contentView.addSubview(dashLine)
        contentView.addSubview(iconView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(shadowContentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame = CGRect(x: 24.0, y: 0, width: 32.0, height: 32.0)
        iconImageView.frame = CGRect(x: 6.0, y: 6.0, width: 20.0, height: 20.0)
        typeLabel.frame = CGRect(x: 80.0, y: 0.0, width: frame.width - 80.0 - 16.0, height: 30.0)
        dashLine.frame = CGRect(x: 40.0, y: iconView.frame.maxY + 5.0, width: 1.0, height: frame.height - iconView.frame.maxY - 10.0)
        shadowContentView.frame = CGRect(x: 80.0, y: 30.0, width: frame.width - 80.0 - 16.0, height: frame.height - 30.0 - 5.0)
        itemView.frame = shadowContentView.bounds
    }
    
}

// MARK: -

final class TodayViewTextCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            messageLabel.text = item?.text
        }
    }
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = UIColor(red: 33 / 255.0, green: 33 / 255.0, blue: 33 / 255.0, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageLabel.frame = CGRect(x: 15.0, y: 15.0, width: itemView.frame.width - 15.0 * 2.0, height: itemView.frame.height - 15.0 * 2.0)
    }
}

// MARK: -

final class TodayViewArticleCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            titleLabel.text = item?.title
            contentLabel.text = item?.text
            
            if let url = URL(string: item?.imageUrl ?? "") {
                articleImageView.af_setImage(withURL: url)
            } else {
                articleImageView.af_cancelImageRequest()
                articleImageView.image = nil
            }
        }
    }
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(articleImageView)
        itemView.addSubview(titleLabel)
        itemView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        articleImageView.frame = CGRect(x: 0.0, y: 0.0, width: 104.0, height: itemView.frame.height)
        titleLabel.frame = CGRect(x: articleImageView.frame.maxX + 10.0, y: 12.0, width: itemView.frame.width - articleImageView.frame.width - 10.0 * 2.0, height: 50.0)
        contentLabel.frame = CGRect(x: articleImageView.frame.maxX + 10.0, y: titleLabel.frame.maxY + 5, width: titleLabel.frame.width, height: 35.0)
    }
    
}

// MARK: -

final class TodayViewDrinkCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            
        }
    }
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = UIColor(red: 74 / 255.0, green: 144 / 255.0, blue: 226 / 255.0, alpha: 1.0)
        infoView.addSubview(infoImageView)
        return infoView
    }()
    
    private lazy var infoImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup-Big"))
    
    private lazy var cup1ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup2ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup3ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup4ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup5ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup6ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup7ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    private lazy var cup8ImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Cup"))
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(infoView)
        itemView.addSubview(cup1ImageView)
        itemView.addSubview(cup2ImageView)
        itemView.addSubview(cup3ImageView)
        itemView.addSubview(cup4ImageView)
        itemView.addSubview(cup5ImageView)
        itemView.addSubview(cup6ImageView)
        itemView.addSubview(cup7ImageView)
        itemView.addSubview(cup8ImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoView.frame = CGRect(x: 0.0, y: 0.0, width: 104.0, height: itemView.frame.height)
        infoImageView.frame = CGRect(x: (infoView.frame.width - 40.0) / 2.0, y: (infoView.frame.height - 40.0) / 2.0, width: 40.0, height: 40.0)
        
        let spacing = (itemView.frame.width - infoView.frame.width - 16.0 * 2.0 - 22.0 * 4.0) / 3.0
        cup1ImageView.frame = CGRect(x: infoView.frame.maxX + 16.0, y: 24.0, width: 22.0, height: 28.0)
        cup2ImageView.frame = CGRect(x: cup1ImageView.frame.maxX + spacing, y: 24.0, width: 22.0, height: 28.0)
        cup3ImageView.frame = CGRect(x: cup2ImageView.frame.maxX + spacing, y: 24.0, width: 22.0, height: 28.0)
        cup4ImageView.frame = CGRect(x: cup3ImageView.frame.maxX + spacing, y: 24.0, width: 22.0, height: 28.0)
        cup5ImageView.frame = CGRect(x: infoView.frame.maxX + 16.0, y: cup1ImageView.frame.maxY + 8.0, width: 22.0, height: 28.0)
        cup6ImageView.frame = CGRect(x: cup5ImageView.frame.maxX + spacing, y: cup2ImageView.frame.maxY + 8.0, width: 22.0, height: 28.0)
        cup7ImageView.frame = CGRect(x: cup6ImageView.frame.maxX + spacing, y: cup3ImageView.frame.maxY + 8.0, width: 22.0, height: 28.0)
        cup8ImageView.frame = CGRect(x: cup7ImageView.frame.maxX + spacing, y: cup4ImageView.frame.maxY + 8.0, width: 22.0, height: 28.0)
    }
    
}

// MARK: -

final class TodayViewAlarmCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            titleLabel.text = item?.title
            
            if let date = item?.date {
                dateLabel.text = dateFormatter.string(from: date)
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = JKString("today.alarm.date-format")
        return formatter
    }()
    
    private lazy var alarmView: UIView = {
        let alarmView = UIView()
        alarmView.backgroundColor = UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        alarmView.addSubview(alarmImageView)
        return alarmView
    }()
    
    private lazy var alarmImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Alarm-Big"))
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(alarmView)
        itemView.addSubview(titleLabel)
        itemView.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        alarmView.frame = CGRect(x: 0.0, y: 0.0, width: 104.0, height: itemView.frame.height)
        alarmImageView.frame = CGRect(x: (alarmView.frame.width - 60.0) / 2.0, y: (alarmView.frame.height - 60.0) / 2.0, width: 60.0, height: 60.0)
        titleLabel.frame = CGRect(x: alarmView.frame.maxX + 10.0, y: 12.0, width: itemView.frame.width - alarmView.frame.width - 10.0 * 2.0, height: 50.0)
        dateLabel.frame = CGRect(x: alarmView.frame.maxX + 10.0, y: titleLabel.frame.maxY + 5, width: titleLabel.frame.width, height: 35.0)
    }
    
}

// MARK: -

final class TodayViewRecordCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            
        }
    }
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = UIColor(red: 74 / 255.0, green: 144 / 255.0, blue: 226 / 255.0, alpha: 1.0)
        infoView.addSubview(infoImageView)
        return infoView
    }()
    
    private lazy var infoImageView: UIImageView = UIImageView(image: UIImage(named: "Today-HeartBeat"))
    
    private lazy var micButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .main
        button.setImage(UIImage(named: "Today-Record-Mic"), for: .normal)
        button.addTarget(self, action: #selector(micButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var textField1: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor(red: 151 / 255.0, green: 151 / 255.0, blue: 151 / 255.0, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3.0
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        textField.leftViewMode = .always
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "高压 mmHg"
        return textField
    }()
    
    private lazy var textField2: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor(red: 151 / 255.0, green: 151 / 255.0, blue: 151 / 255.0, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3.0
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        textField.leftViewMode = .always
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "低压 mmHg"
        return textField
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(infoView)
        itemView.addSubview(micButton)
        itemView.addSubview(textField1)
        itemView.addSubview(textField2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoView.frame = CGRect(x: 0.0, y: 0.0, width: 104.0, height: itemView.frame.height - 40.0)
        infoImageView.frame = CGRect(x: (infoView.frame.width - 40.0) / 2.0, y: (infoView.frame.height - 40.0) / 2.0, width: 40.0, height: 40.0)
        micButton.frame = CGRect(x: 0.0, y: itemView.frame.height - 40.0, width: itemView.frame.width, height: 40.0)
        textField1.frame = CGRect(x: infoView.frame.maxX + 8.0, y: 16.0, width: itemView.frame.width - 8.0 - 16.0 - infoView.frame.width, height: 40.0)
        textField2.frame = CGRect(x: infoView.frame.maxX + 8.0, y: textField1.frame.maxY + 16.0, width: itemView.frame.width - 8.0 - 16.0 - infoView.frame.width, height: 40.0)
    }
    
    // MARK: Actions
    
    @objc
    private func micButtonTapped(_ sender: UIButton) {
        
    }
    
}

// MARK: -

final class TodayViewTestCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            titleLabel.text = item?.title
            contentLabel.text = item?.text
            
            if let url = URL(string: item?.imageUrl ?? "") {
                backgroundImageView.af_setImage(withURL: url)
            } else {
                backgroundImageView.af_cancelImageRequest()
                backgroundImageView.image = nil
            }
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return separator
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(backgroundImageView)
        itemView.addSubview(titleLabel)
        itemView.addSubview(separator)
        itemView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.frame = itemView.bounds
        titleLabel.frame = CGRect(x: 18.0, y: 18.0, width: itemView.frame.width - 18.0 * 2.0, height: 28.0)
        separator.frame = CGRect(x: 20.0, y: titleLabel.frame.maxY + 18.0, width: itemView.frame.width - 20.0 * 2.0, height: 2.0)
        contentLabel.frame = CGRect(x: 18.0, y: itemView.frame.height - 10.0 - 20.0, width: itemView.frame.width - 18.0 * 2.0, height: 20.0)
    }
    
}

// MARK: -

final class TodayViewSuggestionCell: TodayViewCell {
    
    // MARK: Properties
    
    override var item: TodayItem? {
        didSet {
            titleLabel.text = item?.title
            contentLabel.text = item?.text
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = UIColor(red: 74 / 255.0, green: 144 / 255.0, blue: 226 / 255.0, alpha: 1.0)
        infoView.addSubview(infoImageView)
        return infoView
    }()
    
    private lazy var infoImageView: UIImageView = UIImageView(image: UIImage(named: "Today-Suggestion-Big"))
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        itemView.addSubview(infoView)
        itemView.addSubview(titleLabel)
        itemView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoView.frame = CGRect(x: 0.0, y: 0.0, width: 104.0, height: itemView.frame.height)
        infoImageView.frame = CGRect(x: (infoView.frame.width - 40.0) / 2.0, y: (infoView.frame.height - 40.0) / 2.0, width: 40.0, height: 40.0)
        titleLabel.frame = CGRect(x: infoView.frame.maxX + 8.0, y: 12.0, width: itemView.frame.width - infoView.frame.width - 8.0 * 2.0, height: 25.0)
        contentLabel.frame = CGRect(x: infoView.frame.maxX + 8.0, y: titleLabel.frame.maxY + 8.0, width: itemView.frame.width - infoView.frame.width - 8.0 * 2.0, height: itemView.frame.height - titleLabel.frame.maxY - 8.0 * 2.0)
    }
    
}
