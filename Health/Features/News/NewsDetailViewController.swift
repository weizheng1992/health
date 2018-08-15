//
//  NewsDetailViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/7/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class NewsDetailViewController: WebViewController {
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navBarTintColor = UIColor(red: 102 / 255.0, green: 102 / 255.0, blue: 102 / 255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = .white
        
//        let likeButton = UIBarButtonItem(image: UIImage(named: "NavigationBar-Like"), style: .plain, target: self, action: #selector(likeButtonTapped(_:)))
//        let shareButton = UIBarButtonItem(image: UIImage(named: "NavigationBar-Share"), style: .plain, target: self, action: #selector(likeButtonTapped(_:)))
//        navigationItem.rightBarButtonItems = [shareButton, likeButton]
    }
    
    // MARK: Actions
    
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc
    private func shareButtonTapped(_ sender: UIButton) {
        
    }
    
}
