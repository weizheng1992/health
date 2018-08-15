//
//  TermsOfUseViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/8/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class TermsOfUseViewController: UIViewController {
    
    // MARK: Properties
    
    var acceptClosure: (() -> ())?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.textColor = UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        textView.attributedText = NSAttributedString(
            string: JKString("terms-of-use.content"),
            attributes: [ NSAttributedStringKey.paragraphStyle: paragraphStyle ]
        )
        return textView
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("terms-of-use.accept"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSubviews()
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topY = navigationController?.navigationBar.frame.maxY ?? 0
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            bottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        } else {
            bottomInset = 0
        }
        
        acceptButton.frame = CGRect(x: 100.0, y: view.frame.height - bottomInset - 44.0 - 40.0, width: view.frame.width - 100.0 * 2.0, height: 44.0)
        textView.frame = CGRect(x: 0, y: topY, width: view.frame.width, height: view.frame.height - topY - acceptButton.frame.height - bottomInset - 20.0 - 40.0)
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navigationItem.title = JKString("terms-of-use.title")
        
        navBarBgAlpha = 0.0
    }
    
    private func configureSubviews() {
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(acceptButton)
        
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    // MARK: Actions
    
    @objc
    private func acceptButtonTapped(_ sender: UIButton) {
        acceptClosure?()
        
        navigationController?.popViewController(animated: true)
    }
    
}
