//
//  SpecialistPickerViewFooter.swift
//  Health
//
//  Created by Weichen Jiang on 8/9/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class SpecialistPickerViewFooter: UIView {
    
    // MARK: Properties
    
    var refreshClosure: (() -> ())?
    var acceptClosure: (() -> ())?
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.specialist-picker.refresh"), for: .normal)
        button.setTitleColor(.main, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.main.cgColor
        button.addTarget(self, action: #selector(refreshButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .main
        button.setTitle(JKString("survey.specialist-picker.accept"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        
        addSubview(refreshButton)
        addSubview(acceptButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = (frame.width - 16.0 * 3.0) / 2.0
        refreshButton.frame = CGRect(x: 16.0, y: 8.0, width: buttonWidth, height: 44.0)
        acceptButton.frame = CGRect(x: refreshButton.frame.maxX + 16.0, y: 8.0, width: buttonWidth, height: 44.0)
    }
    
    // MARK: Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        refreshClosure?()
    }
    
    @objc private func acceptButtonTapped(_ sender: UIButton) {
        acceptClosure?()
    }
    
}
