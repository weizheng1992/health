//
//  TodayViewSectionHeader.swift
//  Health
//
//  Created by Weichen Jiang on 8/14/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class TodayViewSectionHeader: UIView {

    // MARK: Properties
    
    var info: TodaySpecialistInfo? {
        didSet {
            let attributedString = NSMutableAttributedString()
            attributedString.append(
                NSAttributedString(
                    string: "李潇潇 · ",
                    attributes: [ NSAttributedStringKey.foregroundColor: UIColor.black ]
                )
            )
            attributedString.append(
                NSAttributedString(
                    string: JKString("today.my-specialist"),
                    attributes: [ NSAttributedStringKey.foregroundColor: UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0) ]
                )
            )
            
            nameLabel.attributedText = attributedString
            avatarImageView.image = UIImage(named: "Avatar-AI")
        }
    }
    
    private lazy var avatarView: UIView = {
        let avatarView = UIView()
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 62.0 / 2.0
        avatarView.addSubview(avatarImageView)
        avatarView.addSubview(statusView)
        return avatarView
    }()
    
    private lazy var statusView: UIView = {
        let statusView = UIView()
        statusView.backgroundColor = .white
        statusView.layer.cornerRadius = 62.0 / 2.0
        return statusView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 56.0 / 2.0
        return imageView
    }()
    
    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 6.0
        infoView.addSubview(imButton)
        infoView.addSubview(nameLabel)
        return infoView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var imButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Today-IM"), for: .normal)
        button.addTarget(self, action: #selector(imButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        
        addSubview(infoView)
        addSubview(avatarView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoView.frame = CGRect(x: 10.0 + 62.0 / 2.0, y: 16.0, width: frame.width - 10.0 * 2.0 - 62.0 / 2.0, height: 40.0)
        avatarView.frame = CGRect(x: 10.0, y: 5.0, width: 62.0, height: 62.0)
        avatarImageView.frame = CGRect(x: 3.0, y: 3.0, width: 56.0, height: 56.0)
        imButton.frame = CGRect(x: infoView.frame.width - 24.0 - 24.0, y: (infoView.frame.height - 24.0) / 2.0, width: 24.0, height: 24.0)
        nameLabel.frame = CGRect(x: 10.0 + 62.0 / 2.0, y: (infoView.frame.height - 30.0) / 2.0, width: infoView.frame.width - 10.0 * 2.0 - 62.0 / 2.0 - imButton.frame.width - 24.0, height: 30.0)
    }
    
    // MARK: Actions
    
    @objc
    private func imButtonTapped(_ sender: UIButton) {
        
    }
    
}
