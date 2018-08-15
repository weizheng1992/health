//
//  SurveyViewFooter.swift
//  Health
//
//  Created by Weichen Jiang on 8/10/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class SurveyViewFooter: UIView {

    // MARK: Properties
    
    var submitClosure: (() -> ())?
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .main
        button.setTitle(JKString("survey.done"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
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
        
        addSubview(submitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        submitButton.frame = CGRect(x: 24.0, y: 8.0, width: frame.width - 24.0 * 2.0, height: 44.0)
    }
    
    // MARK: Actions
    
    @objc private func submitButtonTapped(_ sender: UIButton) {
        submitClosure?()
    }
    
}
