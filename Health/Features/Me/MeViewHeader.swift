//
//  MeViewHeader.swift
//  Health
//
//  Created by Weichen Jiang on 8/7/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import AlamofireImage

final class MeViewHeader: UIView {
    
    // MARK: Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = .main
        return scrollView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40.0
        imageView.layer.masksToBounds = true
        imageView.af_setImage(withURL: URL(string: "http://img3.duitang.com/uploads/item/201510/12/20151012172435_wuZQf.thumb.700_0.jpeg")!)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .white
        label.text = "James Wong"
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
        addSubview(avatarImageView)
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.frame = CGRect(x: 20.0, y: frame.height - 30.0 - 80.0, width: 80.0, height: 80.0)
        nameLabel.frame = CGRect(x: avatarImageView.frame.maxX + 22.0, y: avatarImageView.frame.origin.y, width: frame.width - avatarImageView.frame.maxX - 22.0 * 2.0, height: 33.0)
    }
    
}
