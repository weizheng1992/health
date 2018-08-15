//
//  TodayViewHeader.swift
//  Health
//
//  Created by Weichen Jiang on 8/13/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class TodayViewHeader: UIView {
    
    // MARK: Properties
    
    var imageUrl: String? {
        didSet {
            if let url = URL(string: imageUrl ?? "") {
                imageView.af_setImage(withURL: url)
                imageView.frame = bounds
            } else {
                imageView.af_cancelImageRequest()
                imageView.image = nil
            }
        }
    }
    
    var tip: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5.0
            tipLabel.attributedText = NSAttributedString(
                string: tip ?? "",
                attributes: [ NSAttributedStringKey.paragraphStyle: paragraphStyle ]
            )
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = .main
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleLeftMargin.rawValue | UIViewAutoresizing.flexibleRightMargin.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleBottomMargin.rawValue)
        return imageView
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return separator
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var contentOffset: CGFloat = 0 {
        didSet {
            if (contentOffset > 0.0) {
                clipsToBounds = true
            } else {
                let delta: CGFloat = fabs(min(0.0, contentOffset))
                scrollView.frame = CGRect(x: 0.0, y: -delta, width: frame.size.width, height: frame.size.height + delta)
                clipsToBounds = false
            }
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        addSubview(separator)
        addSubview(tipLabel)
        scrollView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = scrollView.bounds
        separator.frame = CGRect(x: 0.0, y: 20.0, width: frame.width, height: 2.0)
        tipLabel.frame = CGRect(x: 28.0, y: separator.frame.maxY + 16.0, width: frame.width - 28.0 * 2.0, height: frame.height - separator.frame.maxY - 16.0 * 2.0)
    }
    
}
