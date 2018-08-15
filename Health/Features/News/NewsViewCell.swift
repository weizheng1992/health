//
//  NewsViewCell.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import AlamofireImage

final class NewsViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleView: UIView = {
        let titleView = UIView()
        titleView.backgroundColor = UIColor(red: 87 / 255.0, green: 87 / 255.0, blue: 87 / 255.0, alpha: 1.0)
        return titleView
    }()
    
    var item: NewsItem? {
        didSet {
            titleLabel.text = item?.title
            contentLabel.text = item?.content
            
            if let url = URL(string: item?.imageUrl ?? "") {
                imageView.af_setImage(withURL: url)
            } else {
                imageView.af_cancelImageRequest()
                imageView.image = nil
            }
            
            setNeedsLayout()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        
        let maxHeight = frame.height * 0.6
        let maxLabelHeight = (maxHeight - 24.0 * 2.0) / 2.0
        
        var titleHeight: CGFloat = 0.0
        if let title = item?.title, !title.isEmpty {
            titleHeight = title.boundingRect(
                with: CGSize(width: frame.width - 24.0 * 2.0, height: maxLabelHeight),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedStringKey.font: titleLabel.font],
                context: nil
                ).height
        }
        if titleHeight > maxLabelHeight {
            titleHeight = maxLabelHeight
        }
        
        var contentHeight: CGFloat = 0.0
        if let content = item?.content, !content.isEmpty {
            contentHeight = content.boundingRect(
                with: CGSize(width: frame.width - 24.0 * 2.0, height: maxLabelHeight),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedStringKey.font: contentLabel.font],
                context: nil
                ).height
        }
        if contentHeight > maxLabelHeight {
            contentHeight = maxLabelHeight
        }
        
        var titleViewHeight = titleHeight + contentHeight
        if titleHeight > 0 && contentHeight > 0 {
            titleViewHeight += 15.0
        }
        if titleViewHeight > 0 {
            titleViewHeight += 24.0 * 2.0
        }
//        if titleViewHeight > maxHeight {
//            titleViewHeight = maxHeight
//        }
        
        titleView.frame = CGRect(x: 0, y: frame.height - titleViewHeight, width: frame.width, height: titleViewHeight)
        titleLabel.frame = CGRect(x: 24.0, y: 24.0, width: frame.width - 24.0 * 2.0, height: titleHeight)
        contentLabel.frame = CGRect(x: 24.0, y: titleHeight > 0 ? titleLabel.frame.maxY + 15.0 : 24.0, width: frame.width - 24.0 * 2.0, height: contentHeight)
    }
    
}
