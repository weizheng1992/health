//
//  TodayViewFooter.swift
//  Health
//
//  Created by Weichen Jiang on 8/14/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class TodayViewFooter: UIView {
    
    // MARK: Properties
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 216 / 255.0, green: 216 / 255.0, blue: 216 / 255.0, alpha: 1.0)
        return separator
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = backgroundColor
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        label.text = JKString("today.footer")
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        
        addSubview(separator)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        separator.frame = CGRect(x: 80.0, y: 28.0 + 10.0, width: frame.width - 80.0 - 16.0, height: 1.0)
        label.frame = CGRect(x: 80.0 + (frame.width - 80.0 - 16.0 - 140.0) / 2.0, y: 28.0, width: 140.0, height: 20.0)
    }
    
}
