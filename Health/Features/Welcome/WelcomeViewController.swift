//
//  WelcomeViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Welcome"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("welcome.start"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            bottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0
        } else {
            bottomInset = 0.0
        }
        
        startButton.frame = CGRect(x: 24.0, y: view.frame.height - 44.0 - 40.0 - bottomInset, width: view.frame.width - 24.0 * 2.0, height: 44.0)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func configureSubviews() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(startButton)
    }
    
    // MARK: Actions
    
    @objc
    private func startButtonTapped(_ sender: Any?) {
        let surveyViewController = SurveyViewController()
        navigationController?.pushViewController(surveyViewController, animated: true)
    }
    
}
