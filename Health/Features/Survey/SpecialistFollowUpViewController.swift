//
//  SpecialistFollowUpViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class SpecialistFollowUpViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var iconImageView = UIImageView(image: UIImage(named: "Survey-FollowUp"))
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.textColor = UIColor(red: 33 / 255.0, green: 33 / 255.0, blue: 33 / 255.0, alpha: 1.0)
        label.text = JKString("survey.follow-up.title")
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = UIColor(red: 68 / 255.0, green: 68 / 255.0, blue: 68 / 255.0, alpha: 1.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(
            string: JKString("survey.follow-up.text.start"),
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)
            ]
        ))
        attributedString.append(NSAttributedString(
            string: JKString("survey.follow-up.text.underline"),
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.0),
                NSAttributedStringKey.underlineColor: UIColor(red: 68 / 255.0, green: 68 / 255.0, blue: 68 / 255.0, alpha: 1.0),
                NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ]
        ))
        attributedString.append(NSAttributedString(
            string: JKString("survey.follow-up.text.end"),
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)
            ]
        ))
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.follow-up.accept"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("survey.follow-up.skip"), for: .normal)
        button.setTitleColor(.main, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.main.cgColor
        button.addTarget(self, action: #selector(skipButtonTapped(_:)), for: .touchUpInside)
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
        
        let textHeight = textLabel.attributedText!.boundingRect(
            with: CGSize(width: view.frame.width - 24.0 * 2.0, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            context: nil).height
        
        let contentHeight = 64.0 + 40.0 + 30.0 + 24.0 + textHeight + 50.0 + 44.0 + 20.0 + 44.0 + 40.0
        
        iconImageView.frame = CGRect(x: (view.frame.width - 64.0) / 2.0, y: (view.frame.height - contentHeight) / 2.0, width: 64.0, height: 64.0)
        titleLabel.frame = CGRect(x: 24.0, y: iconImageView.frame.maxY + 40.0, width: view.frame.width - 24.0 * 2.0, height: 30.0)
        textLabel.frame = CGRect(x: 24.0, y: titleLabel.frame.maxY + 24.0, width: view.frame.width - 24.0 * 2.0, height: textHeight)
        acceptButton.frame = CGRect(x: 24.0, y: textLabel.frame.maxY + 50.0, width: view.frame.width - 24.0 * 2.0, height: 44.0)
        skipButton.frame = CGRect(x: 24.0, y: acceptButton.frame.maxY + 20.0, width: view.frame.width - 24.0 * 2.0, height: 44.0)
    }
    
    // MARK: Configurations
    
    private func configureNavigationBar() {
        navBarBgAlpha = 0.0
    }
    
    private func configureSubviews() {
        view.backgroundColor = .white
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        view.addSubview(acceptButton)
        view.addSubview(skipButton)
    }
    
    // MARK: Actions
    
    @objc
    private func acceptButtonTapped(_ sender: UIButton) {
        acceptTelephoneReturn()
    }
    
    @objc
    private func skipButtonTapped(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.rootViewController = TabBarController()
    }
    
    // MARK: Networking
    
    private func acceptTelephoneReturn() {
        navigationController?.showHUD()
        
        let _ = HTTPClient.shared.acceptTelephoneReturn { [weak self] (response, error) in
            self?.navigationController?.hideHUD()
            
            if response?.code == 1000 {
                UIApplication.shared.keyWindow?.rootViewController = TabBarController()
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
}
